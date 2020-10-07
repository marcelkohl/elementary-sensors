public class Service.Sensor {
    private string last_stdout;
    private string last_stderr;
    private int last_status;

    public signal void on_sensor_update (DataModel.SensorRecord[] sensors_data);

    public Sensor (int update_interval) {
        Timeout.add_seconds (update_interval, () => {
          this.on_sensor_update (this.updated_data());
          return true;
        });
    }

    public DataModel.SensorRecord[] updated_data () {
        DataModel.SensorRecord[] sensor_records = {};

        string sensors_str, item_value, item_hash, group_name;
        string[] item_data;

        foreach (string hwm in get_hw_monitors ()) {
            sensors_str = get_hwm_sensors (@"/sys/class/hwmon/$hwm");

            group_name = get_content (@"/sys/class/hwmon/$hwm/name");
            debug ("%s", group_name);

            foreach (string item_name in sensors_str.split(",")) {
                item_value = get_content (@"/sys/class/hwmon/$hwm/$item_name"); //+"_input");

                if (item_value.length > 0) {
                    item_hash = group_name + item_name;
                    item_hash = GLib.Checksum.compute_for_string (ChecksumType.MD5, item_hash, item_hash.length);
                    item_data = item_name.split ("_");

                    if (item_name.contains("input") || item_name.contains("crit") || item_name.contains("max")) {
                        item_value = "%d".printf(int.parse(item_value) / 1000);
                    }

                    sensor_records += new DataModel.SensorRecord (
                        item_hash,
                        group_name,
                        item_data[0],
                        (bool)item_data[1] ? item_data[1] : "",
                        item_value
                    );

                    // debug ("   %s %s", item_name, item_value);
                }
            }
        }

        return sensor_records;
    }

    public int average_temp (DataModel.SensorRecord[] data, string records_selected) {
        double total = 0;
        int counter = 0;

        foreach (DataModel.SensorRecord str in data) {
            if (
              records_selected.index_of(str.id) >= 0
              && str.type == "input"
              && str.description.contains ("temp")
            ) {
                total += double.parse (str.value);
                counter++;
            }
        };

        return counter > 0 ? (int) (total/counter) : 0;
    }

    private string get_content (string path) {
        string content;
        try {
            FileUtils.get_contents (path, out content);
        } catch (Error e) {
            return "";
        }
        return content.chomp ();
    }

    private Gee.HashSet<string> get_hw_monitors () {
        string? name = null;
        Gee.HashSet<string> hwm_set = new Gee.HashSet<string> ();
        try {
            Dir dir = GLib.Dir.open ("/sys/class/hwmon", 0);
            while ((name = dir.read_name ()) != null) {
                hwm_set.add (name);
            }
        } catch (Error e) {
            warning (e.message);
        }
        return hwm_set;
    }

    private string get_hwm_sensors (string hwm_path) {
      string name, sens_string = "";
      Gee.TreeSet<string> sens_set = new Gee.TreeSet<string> ();
      try {
          Dir dir = GLib.Dir.open (hwm_path, 0);
          while ((name = dir.read_name ()) != null) {
              sens_set.add (name);
          }
      } catch (Error e) {
          warning (e.message);
      }

      foreach (string str in sens_set) {
          if (sens_string != "") {
              sens_string += ",";
          }
          sens_string += str;
      }

      return sens_string;
  }

}
