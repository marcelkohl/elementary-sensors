[DBus (name = "com.github.marcelkohl.sensors")]
public class Service.DBusServer : Object  {
    private const string DBUS_NAME = "com.github.marcelkohl.sensors";
    private const string DBUS_PATH = "/com/github/marcelkohl/sensors";

    private static GLib.Once<DBusServer> instance;

    public static unowned DBusServer get_default () {
        return instance.once (() => { return new DBusServer (); });
    }

    public signal void is_visible (bool state);
    public signal void update (int temperature);

    construct {
        Bus.own_name (
            BusType.SESSION,
            DBUS_NAME,
            BusNameOwnerFlags.NONE,
            (connection) => on_bus_aquired (connection),
            () => { },
            null
        );
    }

    private void on_bus_aquired (DBusConnection conn) {
        try {
            debug ("DBus registered!");
            conn.register_object (DBUS_PATH, get_default ());
        } catch (Error e) {
            error (e.message);
        }
    }
}
