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
        // grid.attach_next_to (data_label, update_button, Gtk.PositionType.RIGHT, 1, 1);

        // var store = new Gtk.ListStore(string, string);
        // var tree = new Gtk.TreeView(store);

        var listmodel = new Gtk.ListStore (3, typeof (string),
                                                  typeof (string),
                                                  typeof (string));

        var view = new Gtk.TreeView ();
    		setup_treeview (view);
        view.set_model (feed_model_list (listmodel, updated_data()));
    		view.expand = true;

        update_button.clicked.connect (() => {
            feed_model_list (listmodel, updated_data());
        });

        grid.attach_next_to (view, update_button, Gtk.PositionType.BOTTOM, 1, 1);

        var main_window = new Gtk.ApplicationWindow (this);
        main_window.default_height = 300;
        main_window.default_width = 300;
        main_window.title = "Sensors";
        main_window.add (grid);
        main_window.show_all ();

        Timeout.add_seconds (3, () => {
            feed_model_list (listmodel, updated_data());
            return true;
        });
    }

    public TreeViewRecord[] updated_data () {
        string ls_stdout;
        string ls_stderr;
        int ls_status;

        Process.spawn_command_line_sync ("sensors -u",
                  out ls_stdout,
                  out ls_stderr,
                  out ls_status);
        //target_label.label = ls_stdout;

        string[] lines = ls_stdout.split ("\n");

        TreeViewRecord[] tree_view_records = {};
        string group_name = "";
        string first_column, second_column;

        foreach (string str in lines) {
          string[] fields = str.split (":");
          first_column = fields[0].strip();
          second_column = fields[1].strip();

          if (first_column != null && fields[0].has_prefix("  ") == false) {
            group_name = first_column;
          }

          if (first_column != null && second_column != null && second_column.length > 0) {
            tree_view_records += new TreeViewRecord (group_name, first_column, second_column);
          }
        };

        return tree_view_records;
    }

    public static int main (string[] args) {
        var app = new MyApp ();
        return app.run (args);
    }

    enum Column {
    		GROUP,
    		DESCRIPTION,
    		VALUE
  	}

    private Gtk.ListStore feed_model_list (Gtk.ListStore listmodel, TreeViewRecord[] tree_view_record) {
      listmodel.clear();

      /* Insert the record into the ListStore */
      Gtk.TreeIter iter;
      for (int i = 0; i < tree_view_record.length; i++) {
        listmodel.append (out iter);
        listmodel.set (iter, Column.GROUP, tree_view_record[i].group,
                             Column.DESCRIPTION, tree_view_record[i].description,
                             Column.VALUE, tree_view_record[i].value);
      }

      return listmodel;
    }

    void setup_treeview (Gtk.TreeView view) {
      var cell = new Gtk.CellRendererText ();

      /* 'weight' refers to font boldness.
       *  400 is normal.
       *  700 is bold.
       */
      cell.set ("weight_set", true);
      cell.set ("weight", 700);

      /*columns*/
      view.insert_column_with_attributes (-1, "Group",
                                                  cell, "text",
                                                  Column.GROUP);

      view.insert_column_with_attributes (-1, "Description",
                                                  new Gtk.CellRendererText (),
                                                  "text", Column.DESCRIPTION);

      view.insert_column_with_attributes (-1, "Value",
                                                  new Gtk.CellRendererText (),
                                                  "text", Column.VALUE);
    }
}

public class TreeViewRecord {
	public string group;
	public string description;
	public string value;

	public TreeViewRecord (string group, string description, string value) {
		this.group = group;
		this.description = description;
		this.value = value;
	}
}
