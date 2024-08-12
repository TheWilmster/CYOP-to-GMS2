draw_set_font(font);
draw_set_halign(fa_center);
draw_text(480, 50, "CYOP ROOM TO GMS2 ROOM CONVERTER");
if (menu == "main" && !selected) {
	draw_set_font(smallfont);
	for (var i = 0; i < array_length(options); i++) {
		draw_set_alpha((select == i) + 0.5);
		draw_text(480, 100 + (18 * i), options[i]);
	}
}
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_text(0, 500, "CONVERTING ROOM...");
draw_set_font(smallfont);
draw_set_halign(fa_right);
if (show_json) {
	draw_text_ext_transformed(950, 0, json_stringify(input_cyop, true), 18, 240, 0.5, 0.5, 0);
}
draw_set_halign(fa_left);
if (!selected) {
	draw_set_color(c_white);
	draw_rectangle(10, 490, 50, 530, true);
	draw_set_color(show_json ? c_lime : c_red);
	draw_rectangle(10, 490, 50, 530, false);
	draw_set_color(c_white);
	draw_text(60, 500, "Show conversion data? WILL cause significant performance drop.");
	if (mouse_check_button_pressed(mb_left)) {
		show_json = !show_json;
	}
}
