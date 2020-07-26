public class Services.Sensor {
  public string last_stdout;
  public string last_stderr;
  public int last_status;

  public Models.SensorRecord[] updated_data () {
      Process.spawn_command_line_sync (
          "sensors -u",
          out last_stdout,
          out last_stderr,
          out last_status
      );

      string[] lines = last_stdout.split ("\n");
      Models.SensorRecord[] sensor_records = {};
      string group_name = "";
      string first_column, second_column;

      foreach (string str in lines) {
          string[] fields = str.split (":");
          first_column = fields[0].strip();
          second_column = fields[1].strip();

          if (first_column != null && fields[0].has_prefix("  ") == false) {
              group_name = first_column;
          }

          if (first_column != null && second_column != null && second_column.length > 0) {
              sensor_records += new Models.SensorRecord (group_name, first_column, second_column);
          }
      };

      return sensor_records;
    }

    public int average_temp (Models.SensorRecord[] data) {
        double average = 0;

        foreach (Models.SensorRecord str in data) {
            if (str.description.contains ("temp") && str.description.contains("input")) {
                average = ((double.parse(str.value) + average) / 2);
            }
        };

        return (int)average;
    }
}