public class Widget.TemperatureWidget : Gtk.Box {
    private Gtk.Label content;
    private Gtk.Image icon;

    public string icon_as_param {get; construct;}

    public string icon_name {
        set {
            icon.set_from_icon_name (value, Gtk.IconSize.SMALL_TOOLBAR);
        }
    }

    public bool is_temperature_visible {
        set {
            if (value == true) {
                content.show ();
            } else {
                content.hide ();
            }
        }
    }

    public int temperature {
        set {
          content.label = "%i° C".printf (value);
        }
    }

    public TemperatureWidget (string icon_name) {
        Object (
            orientation: Gtk.Orientation.HORIZONTAL,
            icon_as_param: icon_name
        );
    }

    construct {
        icon = new Gtk.Image.from_icon_name (icon_as_param, Gtk.IconSize.SMALL_TOOLBAR);
        icon.margin_top = 4;

        content = new Gtk.Label ("N/A");
        content.margin_top = 4;

        pack_start (icon);
        pack_start (content);
    }
}
