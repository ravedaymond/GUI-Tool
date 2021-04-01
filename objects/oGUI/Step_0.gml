/// @description Control GUI Windows
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
				resizing=true.
			*/
			if(active_window.mouseResize(mouse_gui_x, mouse_gui_y)) {
				console_log("resizing window", active_window.name);
				resizing = true;
				window_set_cursor(cr_size_nwse);
			}
			/*
				If the mouse is clicked while over the overlap lock button,
				toggle the value of overlapLock.
			*/
			if(active_window.mouseOverlapLock(mouse_gui_x, mouse_gui_y)) {
				console_log("overlap locked window", active_window.name);
			}
			/*
				If the mouse is clicked while over the pinned button,
				toggle the value of pinned.
			*/
			if(active_window.mousePinned(mouse_gui_x, mouse_gui_y)) {
				console_log("pinned window", active_window.name);	
			}
		}
		
		/*
			If the active_window is clicked on in the close region,
			delete the struct reference from active_window and remove
			the window from the ds_list.
			
			Needs to be last function in line.
		*/
		if(active_window.mouseClose(mouse_gui_x, mouse_gui_y)) {
			console_log("closed window", active_window.name);
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
	var x_prev = active_window.x;
	var y_prev = active_window.y;
	active_window.x = mouse_gui_x-grab_xdiff;
	active_window.x = clamp(active_window.x, active_window.margin, window_get_width()-(active_window.width+active_window.margin));
	active_window.y = mouse_gui_y-grab_ydiff;
	active_window.y = clamp(active_window.y, active_window.margin, window_get_height()-(active_window.height+active_window.margin));
	var i = 0;
	repeat(ds_list_size(windows)) {
		var _w = windows[|i];
		if(active_window != _w && (active_window.overlapLock || _w.overlapLock)) { // ((instanceof(active_window) == gui_dynamic && instanceof(_w) == gui_dynamic) &&
			#region First Variant
			//if( 
			//	point_in_rectangle(active_window.x, active_window.y, _w.x-_w.margin, _w.y-_w.margin, _w.x2()+_w.margin, _w.y2()+_w.margin) ||
			//	point_in_rectangle(active_window.x, active_window.y2(), _w.x-_w.margin, _w.y-_w.margin, _w.x2()+_w.margin, _w.y2()+_w.margin) ||
			//	point_in_rectangle(active_window.x2(), active_window.y, _w.x-_w.margin, _w.y-_w.margin, _w.x2()+_w.margin, _w.y2()+_w.margin) ||
			//	point_in_rectangle(active_window.x2(), active_window.y2(), _w.x-_w.margin, _w.y-_w.margin, _w.x2()+_w.margin, _w.y2()+_w.margin) ||
			//	point_in_rectangle(_w.x, _w.y, active_window.x-active_window.margin, active_window.y-active_window.margin, active_window.x2()+active_window.margin, active_window.y2()+active_window.margin) ||
			//	point_in_rectangle(_w.x, _w.y2(), active_window.x-active_window.margin, active_window.y-active_window.margin, active_window.x2()+active_window.margin, active_window.y2()+active_window.margin) ||
			//	point_in_rectangle(_w.x2(), _w.y, active_window.x-active_window.margin, active_window.y-active_window.margin, active_window.x2()+active_window.margin, active_window.y2()+active_window.margin) ||
			//	point_in_rectangle(_w.x2(), _w.y2(), active_window.x-active_window.margin, active_window.y-active_window.margin, active_window.x2()+active_window.margin, active_window.y2()+active_window.margin)
			//) {
			//	active_window.x = x_prev;
			//	active_window.y = y_prev;
			//}
			#endregion
			#region Second Variant
			//var x_dir = sign(active_window.x - x_prev);
			//var y_dir = sign(active_window.y - y_prev);
			//if(
			//	(active_window.x <= _w.x2()+_w.margin && active_window.x2() >= _w.x2() && ((active_window.y >= _w.y && active_window.y <= _w.y2()) || (active_window.y2() <= _w.y2() && active_window.y2() >= _w.y)) ||
			//	(active_window.x2() >= _w.x-_w.margin && active_window.x <= _w.x && ((active_window.y >= _w.y && active_window.y <= _w.y2()) || (active_window.y2() <= _w.y2() && active_window.y2() >= _w.y)))
			//)
			//) { // Horizontal Collision
			//	active_window.x = x_prev;
			//}
			#endregion
			#region Third Variant
			//if(rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x, _w.y2()) || rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x2(), _w.y, _w.x2(), _w.y2())) {
			//	active_window.x = x_prev;
			//	if(x_dir > 0) {
			//		//while(active_window.x2() < _w.x-1) {
			//		//	active_window.x++;
			//		//}
			//		active_window.x = _w.x-1-active_window.width;
			//	}
			//	if(x_dir < 0) {
			//		//while(active_window.x > _w.x2()+1) {
			//		//	active_window.x--;
			//		//}
			//		active_window.x = _w.x2()+1;
			//	}
			//	window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			//}
			//if(rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y) || rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y2(), _w.x2(), _w.y2())) {
			//	active_window.y = y_prev;
			//	if(y_dir > 0) {
			//		//while(active_window.y2() < _w.y-1) {
			//		//	active_window.y++;	
			//		//}
			//		active_window.y = _w.y-1-active_window.height;
			//	}
			//	if(y_dir < 0) {
			//		//while(active_window.y < _w.y2()+1) {
			//		//	active_window.y--;
			//		//}
			//		active_window.y = _w.y2()+1;
			//	}
			//	window_mouse_set(mouse_gui_x, clamp(mouse_gui_y, active_window.y, active_window.y2()));
			//}
			#endregion
			#region Fourth Variant
			//if(rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x-_w.margin, _w.y, _w.x, _w.y2()) || rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x2()+_w.margin, _w.y, _w.x2(), _w.y2())) {
			//	active_window.x = x_prev;
			//	if(x_dir > 0) {
			//		active_window.x = _w.x-_w.margin-active_window.width;
			//	}
			//	if(x_dir < 0) {
			//		active_window.x = _w.x2()+_w.margin;
			//	}
			//	//window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			//}
			//if(rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y-_w.margin, _w.x2(), _w.y) || rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y2()+_w.margin, _w.x2(), _w.y2())) {
			//	active_window.y = y_prev;
			//	if(y_dir > 0) {
			//		active_window.y = _w.y-_w.margin-active_window.height;
			//	}
			//	if(y_dir < 0) {
			//		active_window.y = _w.y2()+_w.margin;
			//	}
			//}
			#endregion
			/**
			
			The problem with the above is that left/right is being checked prior to up/down, and not simultaneously. Due to the way moving the windows works (without different speed values like moving
			a character), as soon as it starts to slide right while in the same recatangle_in_rectangle collision box it will clip to the x side it is expecting to be encountering.
			
			Eg. When "touching" either the bottom or the top of another window while moving right will place it on the left side of the window; while moving left it will place it on the right.

			*/
			#region Fifth Variant -- In Use
			if((x_prev+active_window.width) <= _w.x) { // Moving Right; Collision with active windows right edge and other windows left edge
				if(active_window.x2() > _w.x && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.x = _w.x-1-active_window.width;
				}
				window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			}
			if(x_prev >= _w.x2()) { // Moving Left; Collision with active windows left edge and other windows right edge
				if(active_window.x < _w.x2() && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.x = _w.x2()+1;
				}
				window_mouse_set(clamp(mouse_gui_x, active_window.x, active_window.x2()), mouse_gui_y);
			}
			if((y_prev+active_window.height) <= _w.y) { // Moving Down; Collision with active windows bottom edge and other windows top edge
				if(active_window.y2() > _w.y && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.y = _w.y-1-active_window.height;	
				}
				window_mouse_set(mouse_gui_x, clamp(mouse_gui_y, active_window.y, active_window.y2()));
			}
			if(y_prev >= _w.y2()) { // Moving Up; Collision with active windows top edge and other windows bottom edge
				if(active_window.y < _w.y2() && rectangle_in_rectangle(active_window.x, active_window.y, active_window.x2(), active_window.y2(), _w.x, _w.y, _w.x2(), _w.y2())) {
					active_window.y = _w.y2()+1;	
				}
				window_mouse_set(mouse_gui_x, clamp(mouse_gui_y, active_window.y, active_window.y2()));
			}
			#endregion
		}
		i++;
	}
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