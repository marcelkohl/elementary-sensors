enum Column {
    ID,
    GROUP,
    DESCRIPTION,
    TYPE,
    VALUE
}

public class DataModel.SensorRecord {
  public string id;
	public string group;
	public string description;
  public string type;
	public string value;

	public SensorRecord (string id, string group, string description, string type, string value) {
    this.id = id;
    this.group = group;
		this.description = description;
    this.type = type;
		this.value = value;
	}
}
