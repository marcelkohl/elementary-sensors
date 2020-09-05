public class Indicator : Wingpanel.Indicator {
    private Widget.DisplayWidget? display_widget = null;
    private Widget.MenuWidget? menu_widget = null;
    private Settings settings;
    private Service.DBusClient dbusclient;

    construct {
        Gtk.IconTheme.get_default ().add_resource_path ("/com/github/marcelkohl/sensors/icons");
        settings = new Settings ("com.github.marcelkohl.sensors.settings");
        this.visible = false;

        display_widget = new Widget.DisplayWidget ();
        menu_widget = new Widget.MenuWidget ();

        dbusclient = Service.DBusClient.get_default ();

        dbusclient.on_terminate.connect (() => this.visible = false);
        dbusclient.on_start.connect (() => this.visible = settings.get_boolean ("show-indicator"));

        dbusclient.interface.is_visible.connect ((visibility) => this.visible = visibility);

        dbusclient.interface.update.connect ((temperature) => {
            display_widget.temperature_widget.temperature = temperature;

            if (temperature < 60) {
              display_widget.temperature_widget.icon_name = "temperature-safe-symbolic";
            } else if (temperature > 60 && temperature < 90) {
              display_widget.temperature_widget.icon_name = "temperature-attention-symbolic";
            } else if (temperature > 90) {
              display_widget.temperature_widget.icon_name = "temperature-danger-symbolic";
            }
        });

        menu_widget.show_window.connect (() => {
            try {
                dbusclient.interface.show_window ();
            } catch (Error e) {
                warning (e.message);
            }
        });

        menu_widget.quit_app.connect (() => {
            try {
                dbusclient.interface.quit_app ();
            } catch (Error e) {
                warning (e.message);
            }
        });
    }

    public Indicator () {
        Object (code_name: "sensors");
    }

    public override Gtk.Widget get_display_widget () {
        return display_widget;
    }

    public override Gtk.Widget? get_widget () {
        return menu_widget;
    }

    public override void opened () {
    }

    public override void closed () {
    }
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Sensors Indicator");

    if (server_type != Wingpanel.IndicatorManager.ServerType.SESSION) {
        return null;
    }

    return new Indicator ();
}
