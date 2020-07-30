public class SensorsApp : Gtk.Application {
    public static Settings settings;
    private Window.Main main_window = null;

    public SensorsApp () {
        Object (
            application_id: "com.github.marcelkohl.sensors",
            flags : ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {
        settings = new Settings ("com.github.marcelkohl.sensors.settings");
    }

    public override void activate () {
        if (get_windows () != null) {
            main_window.show_all ();
            main_window.present ();
            return;
        }

        main_window = new Window.Main (this);
        main_window.show_all ();
    }

    public static int main (string [] args) {
        var app = new SensorsApp ();
        return app.run (args);
    }
}
