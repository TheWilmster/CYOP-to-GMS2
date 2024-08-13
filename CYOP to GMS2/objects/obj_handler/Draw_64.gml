for (var i = 0; i < array_length(bg_alpha); i++) {
	bg_alpha[i] = approach(bg_alpha[i], active_bg == i, 0.025);
}

draw_set_font(smallfont);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _max = ((array_length(rooms) * 18) - (29 * 18)) + 100;
text_yy = lerp(text_yy, clamp(18 * select, 0, _max), 0.1);

draw_set_halign(fa_left);
draw_set_alpha(bg_alpha[0]);
draw_sprite_tiled(SecretBG, 0, scroll, scroll - (text_yy * 1.5));
draw_set_halign(fa_right);
draw_text(958, 522, "Background: Pizza Tower   McPig");

draw_set_halign(fa_left);
draw_set_alpha(bg_alpha[1]);
draw_sprite_tiled(boolsecretbg, 0, (scroll * 0.5), (scroll * 0.5) - (text_yy * 1.5));
draw_sprite_tiled(boolsecretbg2, 0, scroll, scroll - (text_yy * 1.5));
draw_set_halign(fa_right);
draw_text(958, 522, "Background: Bool Tower   Pebls");

draw_set_halign(fa_left);
draw_set_alpha(bg_alpha[2]);
draw_sprite_tiled(secret1, 0, scroll, scroll - (text_yy * 1.5));
draw_set_halign(fa_right);
draw_text(958, 522, "Background: Cherry's Manor   PaperLoogi");

draw_set_halign(fa_left);
draw_set_alpha(bg_alpha[3]);
draw_sprite_tiled(secretback, 0, (scroll * 0.5), (scroll * 0.5) - (text_yy * 1.5));
draw_sprite_tiled(secretfront, 0, scroll, scroll - (text_yy * 1.5));
draw_set_halign(fa_right);
draw_text(958, 522, "Background: Other Tower   SamWow and Choo Choo Trainee");

draw_set_halign(fa_left);
draw_set_alpha(bg_alpha[4]);
draw_sprite_tiled(secretbgr, 0, scroll, scroll - (text_yy * 1.5));
draw_set_halign(fa_right);
draw_text(958, 522, "Background: Floor R   rapparep");

scroll++;

draw_set_halign(fa_left);
var widths = [];
for (var i = 0; i < array_length(rooms); i++) {
	array_push(widths, string_width(rooms[i]));
}
var highest_width = get_highest_value(widths);

if (!selected) {
	draw_set_font(smallfont);
	draw_set_alpha(0.5);
	draw_rectangle_color(90, ((-text_yy) - 10) + 100, highest_width + 110, (-text_yy) + (array_length(rooms) * 18) + 110, c_black, c_black, c_dkgray, c_dkgray, false);
	draw_rectangle(90, ((-text_yy) - 10) + 100, highest_width + 110, (-text_yy) + (array_length(rooms) * 18) + 110, true);
	for (var i = 0; i < array_length(rooms); i++) {
		var option_selected = (select == i);
		draw_set_alpha(option_selected + 0.5);
		if (option_selected) {
			draw_text_color(100, (100 + (18 * i)) - text_yy, rooms[i], c_red, c_orange, c_yellow, c_purple, draw_get_alpha());
		} else {
			draw_text(100, (100 + (18 * i)) - text_yy, rooms[i]);
		}
	}
}
draw_set_alpha(1);
draw_set_font(font);
draw_text(100, 50 - text_yy, "CYOP ROOM TO GMS2 ROOM CONVERTER");
