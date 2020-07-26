[DBus (name = "local.sample.sensors")]
public interface Sensors.DBusClientInterface : Object {
    public signal void is_visible (bool isVisible);
}

public class Sensors.DBusClient : Object {
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
                "local.sample.sensors",
                "/local/sample/sensors"
                );

            Bus.watch_name (
                BusType.SESSION,
                "local.sample.sensors",
                BusNameWatcherFlags.NONE,
                () => on_start (),
                () => on_terminate ()
            );
        } catch (IOError e) {
            error ("Sensors Indicator DBus: %s\n", e.message);
        }
    }
}
