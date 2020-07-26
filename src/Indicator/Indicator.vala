public class Sensors.Indicator : Wingpanel.Indicator {
    private Widgets.DisplayWidget? display_widget = null;
    private Widgets.MenuWidget? menu_widget = null;
    private Settings settings;
    private DBusClient dbusclient;

    construct {
        Gtk.IconTheme.get_default ().add_resource_path ("/local/sample/sensors/icons");
        settings = new Settings ("local.sample.sensors.settings");
        this.visible = false;

        display_widget = new Widgets.DisplayWidget ();
        menu_widget = new Widgets.MenuWidget ();

        dbusclient = DBusClient.get_default ();

        dbusclient.on_terminate.connect (() => this.visible = false);
        dbusclient.on_start.connect (() => this.visible = settings.get_boolean ("show-indicator"));

        dbusclient.interface.is_visible.connect ((visibility) => this.visible = visibility);
        dbusclient.interface.update.connect ((temperature) => {
            display_widget.temperature_widget.temperature = temperature;
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

    return new Sensors.Indicator ();
}
