public class Sensors.Widgets.SensorsWidget : Gtk.Box {
    private Gtk.Label percentage_label;
    private Gtk.Image icon;

    public string icon_name { get; construct; }
    public int percentage_value {
        set {
          percentage_label.label = "%i° C".printf (value);
        }
    }

    public SensorsWidget (string icon_name) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            icon_name: icon_name
        );
    }

    construct {
        icon = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.SMALL_TOOLBAR);
        icon.margin_top = 4;

        percentage_label = new Gtk.Label ("N/A");
        percentage_label.margin_top = 4;

        pack_start (icon);
        pack_start (percentage_label);
    }
}
