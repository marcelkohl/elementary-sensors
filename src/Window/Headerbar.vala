public class Window.Headerbar : Gtk.HeaderBar {
    public Gtk.CheckButton show_indicator_checker;
    public Gtk.CheckButton run_background_checker;
    public Gtk.CheckButton show_percentage_checker;

    construct {
      has_subtitle = false;
      show_close_button = true;
      title = "Sensors";
    }

    public signal void on_show_indicator_change (bool is_checked);
    public signal void on_run_background_change (bool is_checked);
    public signal void on_show_percentage_change (bool is_checked);

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

        show_indicator_checker = new Gtk.CheckButton.with_label (_("Show indicator"));
        run_background_checker = new Gtk.CheckButton.with_label (_("Run in background"));
        show_percentage_checker = new Gtk.CheckButton.with_label (_("Show indicator percentage"));

        preferences_grid.add (run_background_checker);
        preferences_grid.add (show_indicator_checker);
        preferences_grid.add (show_percentage_checker);

        preferences_grid.show_all ();

        show_indicator_checker.notify["active"].connect (
            () => this.on_show_indicator_change(show_indicator_checker.active)
        );

        run_background_checker.notify["active"].connect (
            () => this.on_run_background_change(run_background_checker.active)
        );

        show_percentage_checker.notify["active"].connect (
            () => this.on_show_percentage_change(show_percentage_checker.active)
        );
    }
}
