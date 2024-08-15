function log(str) {
	var m = current_minute;
	if (m < 10) {
		m = string_concat("0", current_minute);
	}
	var time = string_concat(current_month, "-", current_day, "-", current_year, " ", current_hour, "-", m);
	var _file = file_text_open_write(string_concat("error_data/", time, ".txt"));
	file_text_write_string(_file, str);
	_file = file_text_close(_file);
}