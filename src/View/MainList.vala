public class View.MainList {
  private Gtk.ListStore list;
  public Gtk.TreeView view;
  private Gtk.CellRendererText cell;

  public MainList () {
    view = new Gtk.TreeView ();
    cell = new Gtk.CellRendererText ();
    list = new Gtk.ListStore (3, typeof (string), typeof (string), typeof (string));

    cell.set ("weight_set", true);
    cell.set ("weight", 700);

    view.insert_column_with_attributes (-1, "Group", cell, "text", Column.GROUP);
    view.insert_column_with_attributes (-1, "Description", new Gtk.CellRendererText (), "text", Column.DESCRIPTION);
    view.insert_column_with_attributes (-1, "Value", new Gtk.CellRendererText (), "text", Column.VALUE);

    view.set_model (list);
    view.expand = true;
  }

  public Gtk.ListStore feed (DataModel.SensorRecord[] tree_view_record) {
    list.clear();

    Gtk.TreeIter iter;
    for (int i = 0; i < tree_view_record.length; i++) {
      list.append (out iter);
      list.set (iter, Column.GROUP, tree_view_record[i].group,
                       Column.DESCRIPTION, tree_view_record[i].description,
                       Column.VALUE, tree_view_record[i].value);
    }

    return list;
  }
}
