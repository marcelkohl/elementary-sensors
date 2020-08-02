public class Window.Main : Gtk.Window {
    private Window.DeviceList device_list;
    private Gtk.Stack content_page;

    public Window.Headerbar headerbar;
    public View.MainList list_model;
    public Window.Footer footer;

    public Main (SensorsApp app) {
        this.set_application (app);
        define_content (app);

        this.headerbar = new Window.Headerbar ();
        this.default_height = 500;
        this.default_width = 650;

        this.set_titlebar (this.headerbar);

        app.sensors_data.on_sensor_update.connect ((last_data) => {
            // list_model.feed (last_data);
        });
    }

    private void define_content (SensorsApp app) {
        device_list = new Window.DeviceList ();

        var device_item1 = new Window.DeviceItem ("fan1", "fan");
        device_item1.subtitle = "ISA Adapter - thinkpad-isa-0000";
        device_list.add (device_item1);

        var device_item2 = new Window.DeviceItem ("Core 0", "processor");
        device_item2.subtitle = "ISA Adapter - coretemp-isa-0000";
        device_list.add (device_item2);
        //
        // var device_item2b = new Window.DeviceItem ("Core 1", "processor");
        // device_item2b.subtitle = "ISA Adapter - coretemp-isa-0000";
        // device_list.add (device_item2b);
        //
        // var device_item3 = new Window.DeviceItem ("temp1", "acpi");
        // device_item3.subtitle = "Virtual device - acpitz-virtual-0";
        // device_list.add (device_item3);
        //
        // var device_item4 = new Window.DeviceItem ("wireless", "wifi");
        // device_item4.subtitle = "Virtual device - iwlwifi-virtual-0";
        // device_list.add (device_item4);

        // device_list.add(new Window.DeviceItem ("ISA Adapter", "processor"));
        // device_list.add(new Window.DeviceItem ("Memory", "processor"));


        var scrolled_window = new Gtk.ScrolledWindow (null, null);
        scrolled_window.add (device_list);
        scrolled_window.expand = true;

        footer = new Window.Footer ();
        footer.on_show_indicator_change.connect ((is_checked) => {
            app.show_indicator = is_checked;
        });
        footer.indicator_switch.active = app.show_indicator;

        var content = new Gtk.Grid ();
        content.orientation = Gtk.Orientation.VERTICAL;
        content.attach (scrolled_window, 0, 0, 1, 1);
        content.attach_next_to (footer, scrolled_window, Gtk.PositionType.BOTTOM, 1, 1);

        content_page = new Gtk.Stack ();
        content_page.hexpand = true;
        content_page.add(new Gtk.Label ("Page here"));
        content.attach_next_to (content_page, scrolled_window, Gtk.PositionType.RIGHT, 2, 1);

        // list_model = new View.MainList();
        // grid.add(list_model.view);
        // grid.add(device_list);

        this.add(content);
    }
}
