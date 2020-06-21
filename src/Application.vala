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
        grid.attach_next_to (data_label, update_button, Gtk.PositionType.RIGHT, 1, 1);

        update_button.clicked.connect (() => {
            update_data(data_label);
        });

        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "Sensors";
        main_window.add (grid);
        main_window.show_all ();

        Timeout.add_seconds (3, () => {
            update_data(data_label);
            return true;
        });
    }

    public void update_data (Gtk.Label target_label) {
        string ls_stdout;
        string ls_stderr;
        int ls_status;

        Process.spawn_command_line_sync ("sensors -u",
                  out ls_stdout,
                  out ls_stderr,
                  out ls_status);
        target_label.label = ls_stdout;
    }

    public static int main (string[] args) {
        var app = new MyApp ();
        return app.run (args);
    }
}
