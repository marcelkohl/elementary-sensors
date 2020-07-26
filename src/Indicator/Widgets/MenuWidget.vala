public class Sensors.Widgets.MenuWidget : Gtk.Grid {
    private Gtk.ModelButton button_quit;

    public signal void quit_sensors ();

    construct {
        orientation = Gtk.Orientation.VERTICAL;

        button_quit = new Gtk.ModelButton ();
        button_quit.text = _("Quit Sensors");
        button_quit.hexpand = true;
        button_quit.clicked.connect (() => quit_sensors ());

        add (button_quit);
    }
}
