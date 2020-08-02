public class Window.DeviceList : Gtk.ListBox {
    construct {
        selection_mode = Gtk.SelectionMode.SINGLE;
        activate_on_single_click = true;

        row_selected.connect ((row) => {
            row.activate ();
        });
    }
}
