public class Service.Sensor {
  private string last_stdout;
  private string last_stderr;
  private int last_status;

  public DataModel.SensorRecord[] updated_data () {
      try {
        Process.spawn_command_line_sync (
            "sensors -u",
            out last_stdout,
            out last_stderr,
            out last_status
        );
      } catch (GLib.SpawnError e) {
        debug ("Failed to get data");
      }

      string[] lines = last_stdout.split ("\n");
      DataModel.SensorRecord[] sensor_records = {};
      string group_name = "";
      string first_column, second_column;

      foreach (string str in lines) {
          string[] fields = str.split (":");
          first_column = (bool)fields[0] ? fields[0] : "";
          second_column = (bool)fields[1] ? fields[1] : "";

          if (first_column.length > 0 && first_column.has_prefix("  ") == false) {
              group_name = first_column.strip();
          }

          if (first_column.length > 0 && second_column.length > 0) {
              sensor_records += new DataModel.SensorRecord (group_name, first_column, second_column);
          }
      };

      return sensor_records;
    }

    public int average_temp (DataModel.SensorRecord[] data) {
        double average = 0;

        foreach (DataModel.SensorRecord str in data) {
            if (str.description.contains ("temp") && str.description.contains("input")) {
                average = ((double.parse(str.value) + average) / 2);
            }
        };

        return (int)average;
    }
}
