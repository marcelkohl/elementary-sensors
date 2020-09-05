public class SensorsApp : Gtk.Application {
    private Window.Main main_window = null;
    public static Settings settings;
    public Service.DBusServer indicator;
    public Service.Sensor sensors_data;
    public string records_selected = "";

    public SensorsApp () {
        Object (
            application_id: "cthis.records_selectedom.github.marcelkohl.sensors",
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
        records_selected = settings.get_string ("selected-hashes");

        indicator.is_visible (settings.get_boolean ("show-indicator"));

        sensors_data.on_sensor_update.connect ((last_data) => {
          indicator.update (sensors_data.average_temp(last_data, this.records_selected));
        });

        indicator.on_quit_app.connect (() => { this.quit (); });
        indicator.on_show_window.connect (() => { main_window.show (); });

        main_window.show_all ();

        if (this.run_background == true) {
          main_window.hide ();
        }

        // main_window.close_before.connect(()=>{
        //   debug ("xxx uu");
        //   return;
        // });
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

    public bool run_background {
      get {
          return settings.get_boolean ("run-background");
      }
      set {
          debug ("run background attribute %s", value ? "y" : "n");

          settings.set_boolean ("run-background", value);

          if (value == true) {
              main_window.hide ();
          }
      }
    }

    public void add_record_hash_to_settings (string record_hash) {
      this.records_selected += record_hash + ",";
      settings.set_string ("selected-hashes", this.records_selected);
    }

    public void remove_record_hash_from_settings (string record_hash) {
      this.records_selected = this.records_selected.replace(record_hash + ",", "");
      settings.set_string ("selected-hashes", this.records_selected);
    }

    public static int main (string[] args) {
        var app = new SensorsApp ();
        return app.run (args);
    }
}
