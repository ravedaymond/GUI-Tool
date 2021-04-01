/// @description Create a resizeable GUI window
/// @param _name Name of window.
/// @param _x Initial x position (top left)
/// @param _y Initial y position (top left)
/// @param _w Default width
/// @param _h Default height
function GuiDynamicWindow(_name, _x, _y, _w, _h) : GuiStaticWindow(_name, _x, _y, _w, _h) constructor {
	
	resize_box = 10;

	overlapLock = false;
	overlapLockHover = false;
	pinned = false;
	pinnedHover = false;
	
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
	
	static mouseOver = function(_mx, _my) {
		return point_in_rectangle(_mx, _my, x, y, x2(), y2());
	}
	
	static mouseClose = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-title_bar, y, x2(), y+title_bar);
	}
	
	static mouseGrab = function(_mx, _my) {
		return !pinned && mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x, y, x2()-title_bar, y+title_bar);	
	}
	
	static mouseResize = function(_mx, _my) {
		return mouse_check_button_pressed(mb_left) && point_in_rectangle(_mx, _my, x2()-resize_box, y2()-resize_box, x2(), y2());
	}
	
	static hoverOverlapLock = function(_mx, _my) {
		overlapLockHover = point_in_rectangle(_mx, _my, x2()-(title_bar*2), y, x2()-title_bar, y+title_bar);
		return overlapLockHover;
	}
	
	static mouseOverlapLock = function(_mx, _my) {
		var retval = hoverOverlapLock(_mx, _my) && mouse_check_button_pressed(mb_left);
		if(retval) {
			overlapLock = !overlapLock;	
		}
		return retval;
	}
	
	static hoverPinned = function(_mx, _my) {
		pinnedHover = point_in_rectangle(_mx, _my, x2()-(title_bar*3), y, x2()-(title_bar*2), y+title_bar);
		return pinnedHover;
	}
	
	static mousePinned = function (_mx, _my) {
		var retval = hoverPinned(_mx, _my) && mouse_check_button_pressed(mb_left);
		if(retval) {
			pinned = !pinned;
		}
		return retval;
	}
	
	static resize = function(_mx, _my) {
		draw_set_alpha(0.45);
		draw_set_color(c_blue);
		draw_rectangle(x, y, _mx, _my, false);
		draw_set_alpha(1);
		draw_set_color(c_white);
	}
	
	static draw = function() {
		drawBackground();
		drawContentArea();
		drawTitleBar();
		drawTitleName();
		drawCloseButton();
		drawPinnedButton();
		drawOverlapLockButton();
		drawResizeCorner();
		draw_set_alpha(1);
		draw_set_color(c_white);	
	}
	
	static drawBackground = function() {
		draw_set_alpha(0.6);
		draw_set_color(c_dkgray);
		draw_rectangle(x, y, x2(), y2(), false);	
	}
	
	static drawContentArea = function() {
		draw_rectangle(x+padding, y+title_bar+padding, x2()-padding, y2()-padding, false);
	}
	
	static drawTitleBar = function() {
		draw_set_alpha(0.75);
		draw_set_color(c_ltgray);
		draw_rectangle(x, y, x2()-title_bar, y+title_bar, false);
	}
	
	static drawTitleName = function() {
		draw_set_color(c_black);
		draw_set_font(global.gui_window_title_font);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text(x, y, name);
	}
	
	static drawCloseButton = function() {
		draw_set_color(c_red);
		draw_rectangle(x2()-title_bar, y, x2(), y+title_bar, false);	
	}
	
	static drawPinnedButton = function() {
		if(pinned) {
			draw_set_color(c_lime);
			if(pinnedHover) {
				draw_set_color(c_olive);	
			}
		} else {
			draw_set_color(c_olive);
			if(pinnedHover) {
				draw_set_color(c_lime);
			}
		}
		draw_rectangle(x2()-(title_bar*3), y, x2()-(title_bar*2), y+title_bar, false);
	}
	static drawOverlapLockButton = function() {
		if(overlapLock) {
			draw_set_color(c_orange);
			if(overlapLockHover) {
				draw_set_color(c_blue);
			}
		} else {
			draw_set_color(c_blue);
			if(overlapLockHover) {
				draw_set_color(c_orange);	
			}
		}
		draw_rectangle(x2()-(title_bar*2), y, x2()-title_bar, y+(title_bar), false);	
	}
	
	static drawResizeCorner = function() {
		draw_set_color(c_red);
		draw_rectangle(x2()-resize_box, y2()-resize_box, x2(), y2(), false);
	}
	
}