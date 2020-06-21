public class MyApp : Gtk.Application {
    public MyApp () {
        Object (
            application_id: "com.github.marcelkohl.elementary-vala-gtk-sensors",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        var update_button = new Gtk.Button.with_label ("Update");
        var data_label = new Gtk.Label (null);

        var grid = new Gtk.Grid ();
        grid.column_spacing = 6;
        grid.row_spacing = 6;

        // add first row of widgets
        grid.attach (update_button, 0, 0, 1, 1);

        var listmodel = new View.MainList();
        var sensors = new Service.Sensor();

        update_button.clicked.connect (() => {
            listmodel.feed (sensors.updated_data());
        });

        grid.attach_next_to (listmodel.view, update_button, Gtk.PositionType.BOTTOM, 1, 1);

        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "Sensors";
        main_window.add (grid);
        main_window.show_all ();

        Timeout.add_seconds (3, () => {
            listmodel.feed (sensors.updated_data());
            return true;
        });
    }

    public static int main (string[] args) {
        var app = new MyApp ();
        return app.run (args);
    }
}
