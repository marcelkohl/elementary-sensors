public class Window.Main : Gtk.Window {
    public Window.Headerbar headerbar;
    public View.MainList list_model;

    public Main (SensorsApp app) {
        this.set_application (app);
        define_content ();

        this.headerbar = new Window.Headerbar ();
        this.headerbar.on_show_indicator_change.connect ((is_checked) => {
            app.show_indicator = is_checked;
        });
        this.headerbar.show_indicator_checker.active = app.show_indicator;

        this.set_titlebar (this.headerbar);

        app.sensors_data.on_sensor_update.connect ((last_data) => {
            list_model.feed (last_data, app.records_selected);
        });

        list_model.on_toggled.connect ((record_id, is_checked)=> {
            if (is_checked) {
                app.add_record_hash_to_settings(record_id);
            } else {
                app.remove_record_hash_from_settings(record_id);
            }
        });
    }

    private void define_content () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.row_spacing = 6;

        list_model = new View.MainList ();

        grid.add(list_model.view);
        this.default_height = 400;
        this.default_width = 550;

        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (grid);
        scrolled_window.expand = true;

        this.add(scrolled_window);
    }
}
