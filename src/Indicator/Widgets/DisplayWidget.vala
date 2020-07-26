public class Sensors.Widgets.DisplayWidget : Gtk.Grid {
    public TemperatureWidget temperature_widget;

    construct {
        temperature_widget = new TemperatureWidget ("temperature-danger");

        add (temperature_widget);
    }
}
