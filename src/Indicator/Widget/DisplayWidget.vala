public class Widget.DisplayWidget : Gtk.Grid {
    public TemperatureWidget temperature_widget;

    construct {
        temperature_widget = new TemperatureWidget ("temperature-symbolic");

        add (temperature_widget);
    }
}
