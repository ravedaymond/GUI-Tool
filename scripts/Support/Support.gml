// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @description Print DEBUG level log to the console. JSON formatted.
/// @param argument[0..16] Arguments to include in the log.
function console_log() {
	var _log = "{INFO:[ ";
	if(argument_count > 0) {
		var i=0;
		repeat(argument_count) {
			if(i > 0) {
				_log+="; ";
			}
			_log += string(argument[i]);
			i++;
		}
	}
	show_debug_message(_log+" ]}");
}

/// @description Reset drawing alpha and color to default values.
function draw_reset() {
	draw_set_alpha(1);
	draw_set_color(c_white);
}