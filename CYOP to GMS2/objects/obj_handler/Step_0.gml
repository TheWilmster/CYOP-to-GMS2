select = clamp(select + (keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)), 0, array_length(options) - 1);
if (keyboard_check_pressed(ord("Z")) && !selected) {
	switch (select) {
		case 0:
			selected = true;
			if (!file_exists("Input/PizzaTower_GM2.yyp")) {
				show_error("This file does not exist. Please put your .yyp project file in this folder.", true);
			}
			if (!file_exists("Input/" + room_name +".json")) {
				show_error("This file does not exist. Please go to AppData>>Local>>CYOP to GMS2>>Input>> and put in a cyop room.", true);
			}
			var _file = file_text_open_read("Input/" + room_name +".json");
			var _str = "";
			while (!file_text_eof(_file)) {
				_str += file_text_readln(_file);
				_str += "\n";
			}
			_file = file_text_close(_file);
			var CYOProom = json_parse(_str);
			var _insts = CYOProom[$ "instances"];
			var _settings = CYOProom[$ "properties"];
			var gms2room = create_blank_gms2_room();
			objs_to_convert = [];
			for (var i = 0; i < array_length(_insts); i++) {
				array_push(objs_to_convert, _insts[i]);
			}
			gms2room.roomSettings.Width = CYOProom.properties.levelWidth;
			gms2room.roomSettings.Height = CYOProom.properties.levelHeight;
			var instance_ids = [];
			for (var i = 0; i < array_length(objs_to_convert); i++) {
				var c = objs_to_convert[i];
				var _obj = id_to_object(c.object);
				if (!c.deleted && _obj != "obj_sprite") {
					var _inst_layer = c.layer + 1;
					var _xscale = 1;
					var _yscale = 1;
					var _angle = 0;
					var _variables = c.variables;
					var _x =  c.variables.x - CYOProom.properties.roomX;
					var _y = c.variables.y - CYOProom.properties.roomY;
					var _var_names = struct_get_names(_variables);
					var _has_creation_code = false;
					var _creation_code = "";
					var i_id = generate_instance_id();
					while (array_contains(instance_ids, i_id)) {
						i_id = generate_instance_id();
					}
					for (var j = 0; j < array_length(_var_names); j++) {
						switch (_var_names[j]) {
							case "image_xscale":
								_xscale = c.variables.image_xscale;
								if (struct_exists(c.variables, "flipX") && c.variables.flipX) {
									_xscale *= -1;
									var horDifference = (object_get_width_cyop(_obj) - (object_get_xoffset_cyop(_obj) * 2)) * _xscale;
									_x += horDifference;
								}
								break;
							case "image_yscale":
								_yscale = c.variables.image_yscale;
								if (struct_exists(c.variables, "flipX") && c.variables.flipY) {
									_yscale *= -1;
									var verDifference = (object_get_height_cyop(_obj) - (object_get_yoffset_cyop(_obj) * 2)) * _yscale;
									_y += verDifference;
								}
								break;
							case "image_angle":
								_angle = c.variables.image_angle;
								break;
							default:
								if (_var_names[j] != "flipX" && _var_names[j] != "flipY" && _var_names[j] != "image_xscale" && _var_names[j] != "image_yscale" && _var_names[j] != "x" && _var_names[j] != "y") {
									_has_creation_code = true;
									_creation_code += string_concat(_var_names[j], " = ", c.variables[$ _var_names[j]], "; \n");
								}
								break;
						}
					}
					if (!gms2_layer_exists(gms2room, string_concat("Instances_", _inst_layer))) {
						array_push(gms2room.layers, create_blank_instances_layer(string_concat("Instances_", _inst_layer)));
					}
					var instance = create_instance(_obj, _x, _y, _xscale, _yscale, _angle, _creation_code != "", i_id);
					if (_creation_code != "") {
						_file = file_text_open_write(string_concat("Export/" + room_name + "/" + "InstanceCreationCode_", i_id, ".gml"));
						file_text_write_string(_file, _creation_code);
						_file = file_text_close(_file);
						array_push(gms2room.instanceCreationOrder, {
							name: i_id,
							path: "rooms/" + room_name + "/" + room_name + ".yy"
						});
					}
					array_push(gms2room.layers[gms2_find_layer_index(gms2room, string_concat("Instances_", _inst_layer))][$ "instances"], instance);
				}
			}
			_file = file_text_open_write("Export/" + room_name + "/" + room_name + ".yy");
			var _yy = json_stringify(gms2room, true);
			file_text_write_string(_file, _yy);
			_file = file_text_close(_file);
			
			var _yyp = file_text_open_read("Input/PizzaTower_GM2.yyp");
			_str = "";
			while (!file_text_eof(_yyp)) {
				_str += file_text_readln(_yyp);
				_str += "\n";
			}
			_yyp = file_text_close(_yyp);
			var decompiled_yyp = json_parse(_str);
			var resource = {
				id: {
					name: "main",
					path: "rooms/" + room_name + "/" + room_name + ".yy"
				},
				order: 0
			};
			array_push(decompiled_yyp.resources, resource);
			var roomNode = {
			    roomId:{
					name: "main",
					path: "rooms/" + room_name + "/" + room_name + ".yy"
			    },
			};
			array_push(decompiled_yyp.RoomOrderNodes, roomNode);
			var compiled_yyp = json_stringify(decompiled_yyp, true);
			_yyp = file_text_open_write("Export/PizzaTower_GM2.yyp");
			file_text_write_string(_yyp, compiled_yyp);
			_yyp = file_text_close(_yyp);
			show_message("Remember: this wont convert obj_sprite! You MUST use an Assets Layer in GameMaker.")
			selected = false;
			room_name = get_string("Which room do you want to port? (_wfixed is added automatically.)", "main") + "_wfixed";
			break;
	}
}