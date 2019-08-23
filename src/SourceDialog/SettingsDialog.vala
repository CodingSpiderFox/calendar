// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2019 elementary, Inc. (https://elementary.io)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authored by: CodingSpiderFox@gmail.com
 */

public class Maya.View.SettingsDialog : Gtk.Grid {
    public EventType event_type { get; private set; default=EventType.EDIT;}

    private Gtk.Entry name_entry;
    private bool set_as_default = false;
    private string hex_color = "#da3d41";
    private Backend current_backend;
    private Gee.Collection<PlacementWidget> backend_widgets;
    private Gtk.Grid main_grid;
    private Gtk.Button cancel_button;
    private Gtk.Button confirm_button;
    private E.Source source = null;

    private EventEdition.ReminderPanel reminder_panel;

    public signal void cancel ();
    public signal void confirm ();

    construct {
        reminder_panel = new EventEdition.ReminderPanel.withSettingsDialog (this);

        var cancel_button = new Gtk.Button.with_label (_("Cancel"));
        confirm_button = new Gtk.Button.with_label (_("Confirm"));

        confirm_button.clicked.connect (save);
        cancel_button.clicked.connect (() => cancel ());

        var buttonbox = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);
        buttonbox.layout_style = Gtk.ButtonBoxStyle.END;
        buttonbox.spacing = 6;
        buttonbox.pack_end (cancel_button);
        buttonbox.pack_end (confirm_button);

        var name_label = new Gtk.Label (_("Default reminders"));
        name_label.xalign = 1;

        main_grid = new Gtk.Grid ();
        main_grid.row_spacing = 6;
        main_grid.column_spacing = 12;
        main_grid.attach (name_label, 0, 0);
        main_grid.attach (reminder_panel, 0 , 1);
        
        margin = 12;
        margin_bottom = 8;
        row_spacing = 24;
        attach (main_grid, 0, 0);
        attach (buttonbox, 0, 1);

        show_all ();
    }

    public void set_source (E.Source? source = null) {
        this.source = source;
    }

    public void save () {
        if (event_type == EventType.ADD) {
            current_backend.add_new_calendar (name_entry.text, hex_color, set_as_default, backend_widgets);
            confirm ();
        } else {
            current_backend.modify_calendar (name_entry.text, hex_color, set_as_default, backend_widgets, source);
            cancel ();
        }
    }
}
