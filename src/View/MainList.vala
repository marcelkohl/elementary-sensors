public class View.MainList {
  private Gtk.ListStore list;
  public Gtk.TreeView view;
  private Gtk.CellRendererText cell;
  private Gtk.CellRendererToggle cell_toggle;

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

    cell_toggle.toggled.connect( (toggle, path) => {
        debug ("clicked %s", path);
    });

    view.set_model (list);
    view.expand = true;
  }

  public Gtk.ListStore feed (DataModel.SensorRecord[] tree_view_record) {
    list.clear();

    Gtk.TreeIter iter;

    for (int i = 0; i < tree_view_record.length; i++) {
        list.append (out iter);
        list.set (
            iter,
            Column.CHECK, false,
            Column.ID, tree_view_record[i].id,
            Column.GROUP, tree_view_record[i].group,
            Column.DESCRIPTION, tree_view_record[i].description,
            Column.TYPE, tree_view_record[i].type,
            Column.VALUE, tree_view_record[i].value
        );
    }

    return list;
  }
}
