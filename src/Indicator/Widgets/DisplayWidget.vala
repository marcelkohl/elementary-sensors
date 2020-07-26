public class Sensors.Widgets.DisplayWidget : Gtk.Grid {
    public SensorsWidget sensor_widget;

    construct {
        sensor_widget = new SensorsWidget ("temperature");
        
        add (sensor_widget);
    }
}
