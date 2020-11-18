// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function GUI(){

}

function guiWindowActive() {
	
}

/// @description Create a basic GUI Window
/// @param _name Name of window.
/// @param _x Initial x position (top left)
/// @param _y Initial y position (top left)
/// @param _w Default width
/// @param _h Default height
function guiBasicWindow(_name, _x, _y, _w, _h) constructor {
	name = _name;
	x = _x;
	y = _y;
	depth = -y;
	def_width = _w;
	def_height = _h;
	width = def_width;
	height = def_height;
	margin = 10;
	padding = 10;
	border = 2;
	title_bar = 20;
	scroll_bar = 5;
	resize_box = 10;
	min_width = title_bar*2;
	min_height = min_width;
	
	static xscale = 1;
	static yscale = 1;
	
	static setXscale = function(_xscale) {
		xscale = _xscale;	
	}
	
	static setYscale = function(_yscale) {
		yscale = _yscale;	
	}
	
	static resetToDefault = function() {
		width = def_width;
		height = def_height;
	}
	
	static x2 = function() {
		return x+width;
	}
	
	static y2 = function() {
		return y+height;
	}
	
	static mouseGrab = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x, y, x2()-title_bar, y+title_bar);	
	}
	
	static mouseClose = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-title_bar, y, x2(), y+title_bar);
	}
	
	static mouseResize = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-resize_box, y2()-resize_box, x2(), y2());
	}
	
	static mouseOver = function(_mx, _my) {
		return point_in_rectangle(_mx, _my, x, y, x2(), y2());
	}
	
	static resize = function(_mx, _my) {
		draw_set_alpha(0.45);
		draw_set_color(c_blue);
		draw_rectangle(x, y, _mx, _my, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
	
	static draw = function() {
		// Draw Background
		draw_set_alpha(0.6);
		draw_set_color(c_dkgray);
		draw_rectangle(x, y, x2(), y2(), false);
		// Draw Content Area
		draw_rectangle(x+padding, y+title_bar+padding, x2()-padding, y2()-padding, false);

		// Draw Title Bar
		draw_set_alpha(0.75);
		draw_set_color(c_ltgray);
		draw_rectangle(x, y, x2()-title_bar, y+title_bar, false);

		// Draw Close Button
		draw_set_color(c_red);
		draw_rectangle(x2()-title_bar, y, x2(), y+title_bar, false);

		// Draw Resize Corner
		draw_rectangle(x2()-resize_box, y2()-resize_box, x2(), y2(), false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
}
	
