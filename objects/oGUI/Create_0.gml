/// @description 

global.gui_window_title_font = fntGUItitle;
global.gui_window_body_font = fntGUIbody;

#macro mouse_gui_x window_mouse_get_x()
#macro mouse_gui_y window_mouse_get_y()

windows = ds_list_create();
active_window = undefined;

grabbed = false;
grab_xdiff = 0;
grab_ydiff = 0;

resizing = false;
