[DBus (name = "com.github.marcelkohl.sensors")]
public interface Service.DBusClientInterface : Object {
    public signal void update (int temperature);
    public signal void is_visible (bool isVisible);
}

public class Service.DBusClient : Object {
    private static GLib.Once<DBusClient> instance;
    public DBusClientInterface? interface = null;

    public static unowned DBusClient get_default () {
        return instance.once (() => { return new DBusClient (); });
    }

    public signal void on_terminate ();
    public signal void on_start ();

    construct {
        try {
            interface = Bus.get_proxy_sync (
                BusType.SESSION,
                "com.github.marcelkohl.sensors",
                "/com/github/marcelkohl/sensors"
                );

            Bus.watch_name (
                BusType.SESSION,
                "com.github.marcelkohl.sensors",
                BusNameWatcherFlags.NONE,
                () => on_start (),
                () => on_terminate ()
            );
        } catch (IOError e) {
            error ("Sensors Indicator DBus: %s\n", e.message);
        }
    }
}
