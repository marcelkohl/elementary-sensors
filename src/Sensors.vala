public class SensorsApp : Gtk.Application {
    private Window.Main main_window = null;
    public static Settings settings;
    public Service.DBusServer indicator;
    public Service.Sensor sensors_data;

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

        sensors_data = new Service.Sensor (5);
        indicator = Service.DBusServer.get_default ();
        main_window = new Window.Main (this);

        main_window.show_all ();
        indicator.is_visible (settings.get_boolean ("show-indicator"));
        sensors_data.on_sensor_update.connect ((last_data) => {
            indicator.update (sensors_data.average_temp(last_data));
        });
    }

    public bool show_indicator {
      get {
          return settings.get_boolean ("show-indicator");
      }
      set {
          settings.set_boolean ("show-indicator", value);
          indicator.is_visible (value);
      }
    }

    public static int main (string [] args) {
        var app = new SensorsApp ();
        return app.run (args);
    }
}
