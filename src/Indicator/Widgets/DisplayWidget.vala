public class Sensors.Widgets.DisplayWidget : Gtk.Grid {
    construct {
        add (new SensorsWidget ("temperature"));
    }
}
