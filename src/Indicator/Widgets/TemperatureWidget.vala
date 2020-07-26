public class Sensors.Widgets.TemperatureWidget : Gtk.Box {
    private Gtk.Label content;
    private Gtk.Image icon;

    public string icon_name { get; construct; }
    public int temperature {
        set {
          content.label = "%i° C".printf (value);
        }
    }

    public TemperatureWidget (string icon_name) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            icon_name: icon_name
        );
    }

    construct {
        icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.SMALL_TOOLBAR);
        icon.margin_top = 4;

        content = new Gtk.Label ("N/A");
        content.margin_top = 4;

        pack_start (icon);
        pack_start (content);
    }
}
