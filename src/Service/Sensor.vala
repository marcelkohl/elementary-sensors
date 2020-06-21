public class Service.Sensor {
  public string last_stdout;
  public string last_stderr;
  public int last_status;

  public Model.SensorRecord[] updated_data () {
    Process.spawn_command_line_sync (
      "sensors -u",
      out last_stdout,
      out last_stderr,
      out last_status
    );

    string[] lines = last_stdout.split ("\n");
    Model.SensorRecord[] sensor_records = {};
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
        sensor_records += new Model.SensorRecord (group_name, first_column, second_column);
      }
    };

    return sensor_records;
  }
}
