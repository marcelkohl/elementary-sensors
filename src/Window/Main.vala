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
            list_model.feed (last_data);
            app.indicator.update (app.sensors_data.average_temp(last_data));
        });
    }

    private void define_content () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.row_spacing = 6;

        list_model = new View.MainList();

        grid.add(list_model.view);
        this.add(grid);
    }
}
