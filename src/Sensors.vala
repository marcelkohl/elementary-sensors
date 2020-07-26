public class Sensors.SensorsApp : Gtk.Application {
    public static Settings settings;
    private MainWindow window = null;

    public SensorsApp () {
        Object (
            application_id: "local.sample.sensors",
            flags : ApplicationFlags.FLAGS_NONE
        );
    }

    static construct {
        settings = new Settings ("local.sample.sensors.settings");
    }

    public override void activate () {
        if (get_windows () != null) {
            window.show_all ();
            window.present ();
            return;
        }

        window = new MainWindow (this);
        window.show_all ();
    }

    public static int main (string [] args) {
        var app = new SensorsApp ();
        return app.run (args);
    }
}