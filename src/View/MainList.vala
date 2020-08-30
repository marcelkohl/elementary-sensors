public class View.MainList {
  private Gtk.ListStore list;
  private Gtk.CellRendererText cell;
  private Gtk.CellRendererToggle cell_toggle;
  private Gtk.TreePath last_row_selected;
  private Gtk.TreeIter iter;
  public Gtk.TreeView view;

  public signal void on_toggled (string record_id, bool is_toggled);

  public MainList () {
    view = new Gtk.TreeView ();
    cell = new Gtk.CellRendererText ();
    cell_toggle = new Gtk.CellRendererToggle ();
    list = new Gtk.ListStore (6, typeof (bool), typeof (string), typeof (string), typeof (string), typeof (string), typeof (string));

    cell.set ("weight_set", true);
    cell.set ("weight", 700);

    view.insert_column_with_attributes (-1, "Check", cell_toggle, "active", Column.CHECK);
    view.insert_column_with_attributes (-1, "Id", cell, "text", Column.ID);
    view.insert_column_with_attributes (-1, "Group", cell, "text", Column.GROUP);
    view.insert_column_with_attributes (-1, "Description", cell, "text", Column.DESCRIPTION);
    view.insert_column_with_attributes (-1, "Type", cell, "text", Column.TYPE);
    view.insert_column_with_attributes (-1, "Value", cell, "text", Column.VALUE);

    view.activate_on_single_click = true;

    view.row_activated.connect( (path, column) => {
        last_row_selected = path;
    });

    // var selection = view.get_selection ();
    // selection.changed.connect ((tree_selection)=>{
    //   debug ("selection changed");
    // });
    //
    cell_toggle.toggled.connect (this.update_clicked_toggle);

    view.set_model (list);
    view.expand = true;
  }

  private void select_row_path (string str_path) {
      Gtk.TreePath path = new Gtk.TreePath.from_string (str_path);
      view.set_cursor(path, null, false);
  }

  private void update_clicked_toggle (Gtk.CellRendererToggle toggle, string str_path) {
      this.select_row_path (str_path);

      Gtk.TreeModel model;
      Gtk.TreeSelection selected = view.get_selection ();
      bool was_checked;
      string record_id;

      selected.get_selected (out model, out iter);

      model.get (iter,
          Column.CHECK, out was_checked,
          Column.ID, out record_id
      );

      list.set (iter,
          Column.CHECK, !was_checked
      );

      this.on_toggled (record_id, !was_checked);
  }

  public Gtk.ListStore feed (DataModel.SensorRecord[] tree_view_record, string records_selected) {
    list.clear();

    for (int i = 0; i < tree_view_record.length; i++) {
        list.append (out iter);
        list.set (
            iter,
            Column.CHECK, records_selected.index_of (tree_view_record[i].id) >= 0,
            Column.ID, tree_view_record[i].id,
            Column.GROUP, tree_view_record[i].group,
            Column.DESCRIPTION, tree_view_record[i].description,
            Column.TYPE, tree_view_record[i].type,
            Column.VALUE, tree_view_record[i].value
        );
    }

    if (last_row_selected != null) {
        view.set_cursor(last_row_selected, null, false);
    }

    return list;
  }
}
