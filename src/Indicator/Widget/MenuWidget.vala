public class Widget.MenuWidget : Gtk.Grid {
    private Gtk.ModelButton button_quit;
    private Gtk.ModelButton button_show;

    public signal void quit_app ();
    public signal void show_window ();

    construct {
        orientation = Gtk.Orientation.VERTICAL;

        button_quit = new Gtk.ModelButton ();
        button_quit.text = _("Quit");
        button_quit.hexpand = true;
        button_quit.clicked.connect (() => quit_app ());

        button_show = new Gtk.ModelButton ();
        button_show.text = _("Show sensors");
        button_show.hexpand = true;
        button_show.clicked.connect (() => show_window ());

        add (button_quit);
        add (button_show);
    }
}
