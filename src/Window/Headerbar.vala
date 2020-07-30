public class Window.Headerbar : Gtk.HeaderBar {
    construct {
      has_subtitle = false;
      show_close_button = true;
      title = "Sensors";
    }

    public signal void on_show_indicator_change (bool is_checked);

    public Headerbar () {
        var preferences_button = new Gtk.MenuButton ();
        preferences_button.set_image (new Gtk.Image.from_icon_name ("open-menu", Gtk.IconSize.LARGE_TOOLBAR));
        preferences_button.has_tooltip = true;
        preferences_button.tooltip_text = (_("Settings"));
        pack_end (preferences_button);

        var preferences_grid = new Gtk.Grid ();
        preferences_grid.margin = 6;
        preferences_grid.row_spacing = 6;
        preferences_grid.column_spacing = 12;
        preferences_grid.orientation = Gtk.Orientation.VERTICAL;

        var preferences_popover = new Gtk.Popover (null);
        preferences_popover.add (preferences_grid);
        preferences_button.popover = preferences_popover;

        var show_indicator_label = new Gtk.Label (_("Show indicator"));
        show_indicator_label.halign = Gtk.Align.END;

        var show_indicator_checker = new Gtk.CheckButton ();

        preferences_grid.attach (show_indicator_label, 1, 0, 1, 1);
        preferences_grid.attach (show_indicator_checker, 0, 0, 1, 1);

        preferences_grid.show_all ();

        show_indicator_checker.notify["active"].connect (
            () => this.on_show_indicator_change(show_indicator_checker.active)
        );
    }
}
