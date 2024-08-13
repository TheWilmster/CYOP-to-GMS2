for (var i = 0; i < array_length(bg_alpha); i++) {
	bg_alpha[i] = approach(bg_alpha[i], active_bg == i, 0.025);
}

draw_set_font(smallfont);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _max = ((max(array_length(rooms), 25) * 18) - (25 * 18)) + 100;
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
draw_set_font(smallfont);

if (surface_exists(window_surface)) {
	window_surface = surface_free(window_surface);
}
if (!surface_exists(window_surface)) {
	window_surface = surface_create(380, 360)
}

surface_set_target(window_surface);
for (var i = 0; i < array_length(rooms); i++) {
	var option_selected = (select == i);
	draw_set_alpha(option_selected + 0.5);
	if (option_selected) {
		draw_text_color(10, (10 + (18 * i)) - text_yy, rooms[i], c_red, c_orange, c_yellow, c_purple, draw_get_alpha());
	} else {
		draw_text(10, (10 + (18 * i)) - text_yy, rooms[i]);
	}
}
surface_reset_target();

draw_set_alpha(0.5);
draw_rectangle_color(90, 90, 470, 450, c_black, c_black, c_dkgray, c_dkgray, false);
draw_set_alpha(1);
draw_surface(window_surface, 90, 90);
draw_rectangle(90, 90, 470, 450, true);
draw_set_halign(fa_left)
var title_string = "CYOP ROOM\nTO\nGMS2\nROOM CONVERTER";
switch menu {
	case "gtc":
		title_string = "GMS2 ROOM\nTO\nCYOP\nROOM CONVERTER";
		break;
	default:
	case "ctg":
		title_string = "CYOP ROOM\nTO\nGMS2\nROOM CONVERTER";
		draw_set_font(smallfont);
		draw_text_ext_color(475, 228, "Warning: This will most likely remove the organizing of your GMS2 project! Please use GitHub to discard any unwanted changes caused by this!", 18, 320, c_red, c_red, c_black, c_black, 1);
		break;
}
draw_text_ext(475, 352, "Press left or right to switch between converters.\nPress up or down to select a room.\nPress Z to confirm.", 18, 10000)
draw_text(10, 10, "Go to User/AppData/Local/CYOP_to_GMS2 to input files.")
draw_set_font(font);
draw_text(475, 100, title_string);
