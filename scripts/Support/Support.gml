// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// @description Log to the console. JSON formatted.
/// @param argument[0..16] Arguments to include in the log.
function console_log() {
	var _log = timestamp()+" -- {LOG:[ ";
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

/// @description Returns a formatted timestamp string.
function timestamp() {
	return string(current_month)+"-"+string(current_day)+"-"+string(current_year)+" "+string(current_hour)+":"+string(current_minute)+"."+string(current_second);
}

/// @description Reset drawing alpha and color to default values.
function draw_rgba_reset() {
	draw_set_alpha(1);
	draw_set_color(c_white);
}
