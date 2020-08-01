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
        // this.headerbar.refresh.connect (() =>
        //     debug ("refresh")
        // );
        this.headerbar.on_show_indicator_change.connect ((is_checked) => {
            // debug (" xxxxx");
            app.show_indicator = is_checked;
            // dbusserver.is_visible (is_checked);
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

            // foreach (Models.SensorRecord data in sensors_data.updated_data()) {
            //   debug("%s -> %s -> %s", data.group, data.description, data.value);
            // }
              //  dbusserver.update (22);
              return true;
        });
    }

    private void define_content () {
        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.row_spacing = 6;

        // var update_button = new Gtk.Button.with_label (_("Update"));

        // update_button.clicked.connect (() => {
        //     dbusserver.is_visible (true);
        // });

        // add first row of widgets
        // grid.attach (update_button, 0, 0, 1, 1);

        list_model = new View.MainList();
        sensors_data = new Service.Sensor();

        //grid.attach_next_to (list_model.view, update_button, Gtk.PositionType.BOTTOM, 1, 1);

        grid.add(list_model.view);
        this.add(grid);
    }
}
