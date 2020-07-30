public class Window.Main : Gtk.Window {
    public Service.DBusServer dbusserver;
    public Service.Sensor sensors_data;
    public View.MainList list_model;
    public Window.Headerbar headerbar;

    public Main (SensorsApp app) {
        this.set_application (app);

        define_content ();

        dbusserver = Service.DBusServer.get_default ();

        Timeout.add_seconds (2, () => {
          DataModel.SensorRecord[] last_data = sensors_data.updated_data();
          list_model.feed (last_data);
          debug ("%g", sensors_data.average_temp(last_data));
          dbusserver.update (sensors_data.average_temp(last_data));

          // foreach (Models.SensorRecord data in sensors_data.updated_data()) {
          //   debug("%s -> %s -> %s", data.group, data.description, data.value);
          // }
            //  dbusserver.update (22);
            return true;
        });

        this.headerbar = new Window.Headerbar ();
        // this.headerbar.refresh.connect (() =>
        //     debug ("refresh")
        // );
        this.headerbar.on_show_indicator_change.connect ((is_checked) => {
            // debug (" xxxxx");
            dbusserver.is_visible (is_checked);
        });

        this.set_titlebar (this.headerbar);
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