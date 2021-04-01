/// @description Create a basic GUI static window
/// @param _name Name of window.
/// @param _x Initial x position (top left)
/// @param _y Initial y position (top left)
/// @param _w Default width
/// @param _h Default height
function guiStaticWindow(_name, _x, _y, _w, _h) constructor {
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
	
	static x2 = function() {
		return x+width;
	}
	
	static y2 = function() {
		return y+height;
	}
	
	static mouseOver = function(_mx, _my) {
		return point_in_rectangle(_mx, _my, x, y, x2(), y2());
	}
	
	static mouseClose = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-title_bar, y, x2(), y+title_bar);
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
		// Draw Title Name
		draw_set_color(c_black);
		draw_set_font(global.gui_window_title_font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(x, y, name);

		// Draw Close Button
		draw_set_color(c_red);
		draw_rectangle(x2()-title_bar, y, x2(), y+title_bar, false);
	}
	
}