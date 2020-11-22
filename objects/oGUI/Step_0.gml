/// @description Control GUI Windows
// Create new window
if(mouse_check_button_pressed(mb_middle)) {
	active_window = new guiStaticWindow("Window "+string(ds_list_size(windows)), mouse_gui_x, mouse_gui_y, 400, 350);
	ds_list_add(windows, active_window);
}
if(mouse_check_button_pressed(mb_right)) {
	active_window = new guiDynamicWindow("Window "+string(ds_list_size(windows)), mouse_gui_x, mouse_gui_y, 200, 300);
	ds_list_add(windows, active_window);
}
if(!ds_list_empty(windows)) {
	// Ensure active_window is assigned if a window exists.
	if(active_window == undefined) {
		active_window = windows[| ds_list_size(windows)-1];	
	}
	// If we are already interacting, ignore interaction checks
	if(!grabbed && !resizing) {
		#region Assign active_window
		/* 
			If the cursor is over the active_window, do nothing.
			
			If the cursor is not over the active_window, then for every known
			window check that the cursor is over them and that the left mouse
			button was pressed. If those conditions are true, assign that window
			as the active_window.
		*/
		if(!active_window.mouseOver(mouse_gui_x, mouse_gui_y)) {
			var i=0;
			repeat(ds_list_size(windows)) {
				var _window = windows[|i];
				if(_window.mouseOver(mouse_gui_x, mouse_gui_y) && mouse_check_button_pressed(mb_left)) {
					console_log("active window change", _window.name);
					active_window = _window;
					ds_list_delete(windows, i);
					ds_list_add(windows, _window);
				}
				i++;
			}
		}
		#endregion;
		
		#region Check for interaction with active_window
		// Allow resize and moving for only dynamic windows
		if(instanceof(active_window) == "guiDynamicWindow") {
			/*
				If the active_window is grabbed in the title region, set 
				grabbed=true and record the inital difference between the 
				mouse x,y and the window x,y to use as offset when moving.
			*/
			if(active_window.mouseGrab(mouse_gui_x, mouse_gui_y)) {
				console_log("moving window", active_window.name);
				grabbed = true;
				grab_xdiff = mouse_gui_x-active_window.x;
				grab_ydiff = mouse_gui_y-active_window.y;
				window_set_cursor(cr_size_all);
			}
			/*
				If the active_window is grabbed in the resize region, set 
				resize=true.
			*/
			if(active_window.mouseResize(mouse_gui_x, mouse_gui_y)) {
				console_log("resizing window", active_window.name);
				resizing = true;
				window_set_cursor(cr_size_nwse);
			}	
		}
		/*
			If the active_window is clicked on in the close region,
			delete the struct reference from active_window and remove
			the window from the ds_list.
		*/
		if(active_window.mouseClose(mouse_gui_x, mouse_gui_y)) {
			console_log("closed_window", active_window.name);
			delete active_window;
			ds_list_delete(windows, ds_list_size(windows)-1);
		}
		#endregion
	}
} else {
	/* Ensure active_window is undefined if there are no windows.*/
	active_window = undefined;	
}

#region Move active_window
if(grabbed) {
	active_window.x = mouse_gui_x-grab_xdiff;
	active_window.x = clamp(active_window.x, active_window.margin, window_get_width()-(active_window.width+active_window.margin));
	active_window.y = mouse_gui_y-grab_ydiff;
	active_window.y = clamp(active_window.y, active_window.margin, window_get_height()-(active_window.height+active_window.margin));
}
#endregion

#region End active_window interaction
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
#endregion

#region /**** DEMO PURPOSES ONLY ****/
if(keyboard_check_pressed(vk_escape)) {
	game_restart();
}
#endregion