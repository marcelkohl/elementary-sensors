public class Window.Main : Gtk.Window {
    public Window.Headerbar headerbar;
    public Service.Sensor sensors_data;
    public View.MainList list_model;
    public SensorsApp sensors;

    public Main (SensorsApp app) {
        this.set_application (app);
        sensors = app;
        define_content ();


        this.headerbar = new Window.Headerbar ();
        this.headerbar.on_show_indicator_change.connect ((is_checked) => {
            app.show_indicator = is_checked;
        });
        this.headerbar.show_indicator_checker.active = app.show_indicator;

        this.set_titlebar (this.headerbar);
        this.enable_sensor_cron ();
    }

    public void enable_sensor_cron () {
        Timeout.add_seconds (2, () => {
            DataModel.SensorRecord[] last_data = sensors_data.updated_data();
            list_model.feed (last_data);
            debug ("%g", sensors_data.average_temp(last_data));
            sensors.dbusserver.update (sensors_data.average_temp(last_data));

            return true;
        });
    }

    private void define_content () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.row_spacing = 6;

        list_model = new View.MainList();
        sensors_data = new Service.Sensor();

        grid.add(list_model.view);
        this.add(grid);
    }
}
