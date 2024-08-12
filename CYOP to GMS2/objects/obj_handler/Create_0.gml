globalvar font;
globalvar smallfont;
font = font_add_sprite_ext(spr_font, "ABCDEFGHIJKLMNOPQRSTUVWXYZ!.1234567890:\\/()", true, -1);
smallfont = font_add_sprite_ext(spr_smallfont, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!._1234567890:?", true, 0);
display_set_gui_size(960, 540);
options = [
	"CYOP to GMS2",
	"GMS2 to CYOP W.I.P",
	"Close Converter"
];
select = 0;
menu = "main";

selected = false;
objs_to_convert = [];
input_cyop = {};
show_json = false;
var _file = file_text_open_write("Input/yeah.txt");
file_text_write_string(_file, "put your levels here....")
_file = file_text_close(_file);
room_name = get_string("Which room do you want to port? (_wfixed is added automatically.)", "main") + "_wfixed";