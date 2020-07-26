[DBus (name = "local.sample.sensors")]
public class Sensors.DBusServer : Object {
  private const string DBUS_NAME = "local.sample.sensors";
  private const string DBUS_PATH = "/local/sample/sensors";

  private static GLib.Once<DBusServer> instance;

  public static unowned DBusServer get_default () {
      return instance.once (() => { return new DBusServer (); });
  }

  public signal void is_visible (bool state);

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
