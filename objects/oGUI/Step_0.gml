/// @description 
if(mouse_check_button_pressed(mb_right)) {
	ds_list_add(windows, new guiBasicWindow("window "+string(ds_list_size(windows)), mouse_gui_x, mouse_gui_y, 200, 300));
}
if(!ds_list_empty(windows) && !grabbed && !resizing) {
	var i=0;
	repeat(ds_list_size(windows)) {
		var _window;
		if(active_window != undefined && active_window.mouseOver(mouse_gui_x, mouse_gui_y)) {
			_window = active_window;
		} else {
			_window = windows[|i];
		}
		if(_window.mouseGrab(mouse_gui_x, mouse_gui_y)) {
			console_log("moving window", _window.name);
			grabbed = true;
			grab_xdiff = mouse_gui_x-_window.x;
			grab_ydiff = mouse_gui_y-_window.y;
			if(active_window != _window) {
				active_window = _window;
				ds_list_delete(windows, i);
				ds_list_add(windows, _window);	
			}
			window_set_cursor(cr_size_all);
		}
		if(_window.mouseResize(mouse_gui_x, mouse_gui_y)) {
			console_log("resizing window", _window.name);
			resizing = true;
			if(active_window != _window) {
				active_window = _window;
				ds_list_delete(windows, i);
				ds_list_add(windows, _window);	
			}
			window_set_cursor(cr_size_nwse);
		}
		if(_window.mouseClose(mouse_gui_x, mouse_gui_y)) {
			console_log("closed_window", _window.name);
			delete _window;
			ds_list_delete(windows, i);
			i--;
		}
		i++;
	}
}

if(grabbed) {
	active_window.x = mouse_gui_x-grab_xdiff;
	active_window.x = clamp(active_window.x, active_window.margin, window_get_width()-(active_window.width+active_window.margin));
	active_window.y = mouse_gui_y-grab_ydiff;
	active_window.y = clamp(active_window.y, active_window.margin, window_get_height()-(active_window.height+active_window.margin));
}
	
/* Stop window interaction */
if(mouse_check_button_released(mb_left)) {
	if(grabbed) {
		grabbed = false;
	}
	if(resizing) {
		resizing = false;
		active_window.width -= active_window.x2()-clamp(mouse_gui_x, active_window.x+active_window.min_width, window_get_width()-(active_window.margin));
		if(active_window.width < active_window.min_width) {
			active_window.width = active_window.min_width;
		}
		active_window.height -= active_window.y2()-clamp(mouse_gui_y, active_window.y+active_window.min_height, window_get_height()-(active_window.margin));
		if(active_window.height < active_window.min_height) {
			active_window.height = active_window.min_height;
		}
	}
	window_set_cursor(cr_default);
}