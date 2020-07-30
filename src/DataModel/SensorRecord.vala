enum Column {
    GROUP,
    DESCRIPTION,
    VALUE
}

public class DataModel.SensorRecord {
	public string group;
	public string description;
	public string value;

	public SensorRecord (string group, string description, string value) {
		this.group = group;
		this.description = description;
		this.value = value;
	}
}
