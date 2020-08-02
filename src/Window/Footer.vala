public class Window.Footer : Gtk.ActionBar {
    public signal void on_show_indicator_change (bool is_checked);
    public Gtk.Switch indicator_switch;

    construct {
        hexpand = false;
        get_style_context ().add_class (Gtk.STYLE_CLASS_INLINE_TOOLBAR);

        var label = new Gtk.Label (_("Show Indicator"));
        label.get_style_context ().add_class (Granite.STYLE_CLASS_H4_LABEL);
        label.margin_start = 6;

        indicator_switch = new Gtk.Switch ();
        indicator_switch.margin = 12;
        indicator_switch.margin_end = 6;

        this.pack_start (label);
        this.pack_end (indicator_switch);

        indicator_switch.notify["active"].connect (
            () => on_show_indicator_change(indicator_switch.active)
        );
    }
}
