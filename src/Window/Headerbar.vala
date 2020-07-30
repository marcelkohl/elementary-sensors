public class Window.Headerbar : Gtk.HeaderBar {
    public signal void refresh ();

    public Headerbar () {
        Object (
            has_subtitle: false,
            show_close_button: true,
            title: "Sensors"
        );
    }

    construct {
        var refresh_button = new Gtk.Button.from_icon_name ("view-refresh", Gtk.IconSize.BUTTON);
        refresh_button.tooltip_text = "Refresh";
        refresh_button.clicked.connect (() => {
            debug (" clicked here to refresh ");
        });

        pack_start (refresh_button);
    }
}
