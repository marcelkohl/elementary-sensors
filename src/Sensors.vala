public class SensorsApp : Gtk.Application {
    private Window.Main main_window = null;
    public static Settings settings;
    public Service.DBusServer dbusserver;

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

        dbusserver = Service.DBusServer.get_default ();
        main_window = new Window.Main (this);
        main_window.show_all ();
        dbusserver.is_visible (settings.get_boolean ("show-indicator"));
    }

    public bool show_indicator {
      get {
          return settings.get_boolean ("show-indicator");
      }
      set {
          settings.set_boolean ("show-indicator", value);
          dbusserver.is_visible (value);
      }
    }

    // public void show_indicator (bool must_show) {
    //     settings.set_boolean ("show-indicator", must_show);
    //     dbusserver.is_visible (must_show);
    // }

    public static int main (string [] args) {
        var app = new SensorsApp ();
        return app.run (args);
    }
}
