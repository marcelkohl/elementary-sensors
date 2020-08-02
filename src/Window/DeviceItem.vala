public class Window.DeviceItem : Gtk.ListBoxRow {
    public string title { get; set; default = ""; }
    public string subtitle { get; set; default = ""; }
    public string icon_name { get; set; default = "isa-adapter"; }

    public DeviceItem (string title, string icon_name = "isa-adapter") {
        Object (
            title: title,
            icon_name: icon_name
        );
    }

    construct {
        var row_image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.DND);
        row_image.pixel_size = 32;

        var row_title = new Gtk.Label (title);
        row_title.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        row_title.ellipsize = Pango.EllipsizeMode.END;
        row_title.halign = Gtk.Align.START;
        row_title.valign = Gtk.Align.START;

        var row_description = new Gtk.Label (subtitle);
        row_description.margin_top = 0;
        row_description.use_markup = true;
        row_description.ellipsize = Pango.EllipsizeMode.END;
        row_description.halign = Gtk.Align.START;
        row_description.valign = Gtk.Align.START;

        var overlay = new Gtk.Overlay ();
        overlay.width_request = 38;
        overlay.add (row_image);

        var row_grid = new Gtk.Grid ();
        row_grid.margin = 6;
        row_grid.margin_start = 3;
        row_grid.column_spacing = 3;
        row_grid.attach (overlay, 0, 0, 1, 2);
        row_grid.attach (row_title, 1, 0, 1, 1);
        row_grid.attach (row_description, 1, 1);

        add (row_grid);

        bind_property ("title", row_title, "label");
        bind_property ("subtitle", row_description, "label");
        bind_property ("icon-name", row_image, "icon-name");

        show_all ();
    }
}
