globalvar font;
globalvar smallfont;
font = font_add_sprite_ext(spr_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!.1234567890:\\/()", true, -1);
smallfont = font_add_sprite_ext(spr_smallfont, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!._1234567890:?", true, 0);
display_set_gui_size(960, 540);
select = 0;
selected = false;
objs_to_convert = [];
menu = "ctg"
menu_select = 0;
converters = [
	"ctg",
	"gtc"
];
project_name = get_string("What's the name of your project file?", "PizzaTower_GM2");
var _file = file_text_open_write("CTG Input/yeah.txt");
file_text_write_string(_file, "put your rooms here....")
_file = file_text_close(_file);

_file = file_text_open_write("GTC Input/yeah.txt");
file_text_write_string(_file, "put your rooms here....")
_file = file_text_close(_file);

room_name = "main_wfixed.json";
rooms = files_find_recursive("CTG Input/*.json");
text_yy = 0;
scroll = 0;
bg_alpha = [
	1,
	0,
	0,
	0,
	0
];
active_bg = 0;
alarm[0] = 480;
audio_play_sound(mu_two_thousands, 0, true);
window_surface = -4;
