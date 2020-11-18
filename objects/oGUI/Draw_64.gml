/// @description 
if(!ds_list_empty(windows)) {
	var i=0;
	repeat(ds_list_size(windows)) {
		windows[|i].draw();
		i++;
	}
}
if(resizing) {
	active_window.resize(clamp(mouse_gui_x, active_window.x+active_window.min_width, window_get_width()-(active_window.margin)), clamp(mouse_gui_y, active_window.y+active_window.min_height, window_get_height()-(active_window.margin)));
}
