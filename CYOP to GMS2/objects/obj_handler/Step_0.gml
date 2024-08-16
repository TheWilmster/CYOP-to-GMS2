menu_select = clamp(menu_select + (keyboard_check_pressed(vk_right) - keyboard_check_pressed(vk_left)), 0, array_length(converters) - 1);
menu = converters[menu_select];
rooms = menu == "ctg" ? files_find_recursive("CTG Input/*.json") : files_find_recursive("GTC Input/*");
if (array_contains(rooms, "yeah.txt")) {
	array_delete(rooms, array_get_index(rooms, "yeah.txt"), 1);
}
select = clamp(select + (keyboard_check_pressed(vk_down) - keyboard_check_pressed(vk_up)), 0, array_length(rooms) - 1);
if (keyboard_check_pressed(ord("Z")) && !selected && room_name != "" && array_length(rooms) > 0) {
	switch (menu) {
		case "ctg":
			try {
				#region CYOP to GMS2
				room_name = string_replace(rooms[select], ".json", "");
	
				selected = true;
				if (!file_exists("CTG Input/" + project_name + ".yyp")) {
					show_error("This file (" + project_name + ".yyp) does not exist. Please put your .yyp project file in this folder.", true);
				}
				if (!file_exists("CTG Input/" + room_name + ".json")) {
					show_error("This file does not exist. Please go to AppData>>Local>>CYOP to GMS2>>CTG Input>> and put in a cyop room.", true);
				}
				var _file = file_text_open_read("CTG Input/" + room_name +".json");
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
										var horDifference = (object_get_width_cyop(_obj) - (object_get_xoffset_cyop(_obj) * 2)) * _xscale;
										_x += horDifference;
										_xscale *= -1;
									}
									break;
								case "image_yscale":
									_yscale = c.variables.image_yscale;
									if (struct_exists(c.variables, "flipX") && c.variables.flipY) {
										var verDifference = (object_get_height_cyop(_obj) - (object_get_yoffset_cyop(_obj) * 2)) * _yscale;
										_y += verDifference;
										_yscale *= -1;
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
							_file = file_text_open_write(string_concat("CTG Export/" + room_name + "/" + "InstanceCreationCode_", i_id, ".gml"));
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
				_file = file_text_open_write("CTG Export/" + room_name + "/" + room_name + ".yy");
				var _yy = json_stringify(gms2room, true);
				file_text_write_string(_file, _yy);
				_file = file_text_close(_file);
	
				var _yyp = file_text_open_read("CTG Input/PizzaTower_GM2.yyp");
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
				var b = "CTG Export/" + project_name
				var a = "CTG Input/" + project_name
				_yyp = file_text_open_write(b + ".yyp");
				file_text_write_string(_yyp, compiled_yyp);
				_yyp = file_text_close(_yyp);
	
				if (!file_exists(a + ".resource_order")) {
					var _resor = file_text_open_write(a + ".resource_order");
					var struct = {
						FolderOrderSettings: [],
						ResourceOrderSettings: [],
					};
					file_text_write_string(_resor, json_stringify(struct, true));
					_resor = file_text_close(_resor);
				}
	
				var _resor = file_text_open_read(a + ".resource_order");
				_str = "";
				while (!file_text_eof(_resor)) {
					_str += file_text_readln(_resor);
					_str += "\n";
				}
				_resor = file_text_close(_resor);
				var decompiled_resor = json_parse(_str);
				var struct = {
					name: room_name,
					order: 0,
					path: "rooms/" + room_name + "/" + room_name + ".yy",
				}
				array_push(decompiled_resor.ResourceOrderSettings, struct);
				var compiled_resor = json_stringify(decompiled_resor, true);
				_resor = file_text_open_write(b + ".resource_order");
				file_text_write_string(_resor, compiled_resor);
				_resor = file_text_close(_resor);
				show_message("Remember: this wont convert obj_sprite! You MUST use an Assets Layer in GameMaker.")
				selected = false;
				#endregion
			} catch (error_data) {
				show_message("Failed to convert level. This can be caused by:\n-The selected room not being a .json file\n-An error in the rooms code.\nYou can check the error logs folder for more information.")
				var e = string_concat(error_data.message, "\n\n", error_data.longMessage, "\n\n", error_data.script, "\n\n", error_data.stacktrace);
				log(e);
			}
			break;
		case "gtc":
			try {
				#region GMS2 to CYOP
			room_name = rooms[select];
			selected = true;
			var directory = "GTC Input/" + room_name + "/";
			
			var _str = "";
			var _file = file_text_open_read(directory + room_name + ".yy");
			while (!file_text_eof(_file)) {
				_str += file_text_readln(_file);
				_str += "\n"
			}
			_file = file_text_close(_file);
			var gms2room = json_parse(_str);
			var CYOProom = create_blank_cyop_room();
			
			for (var i = 0; i < array_length(gms2room.layers); i++) {
				var _layer = gms2room.layers[i];
				if (_layer.resourceType == "GMRInstanceLayer") {
					for (var j = 0; j < array_length(_layer.instances); j++) {
						var gms2object = _layer.instances[j];
						var _obj = gms2object.objectId.name;
						var _x = gms2object.x;
						var _y = gms2object.y;
						var _xscale = abs(gms2object.scaleX);
						var _yscale = abs(gms2object.scaleY);
						if (gms2object.scaleX < 0) {
							var horDifference = (object_get_width_cyop(_obj) - (object_get_xoffset_cyop(_obj) * 2)) * _xscale;
							_x -= horDifference;
						}
						if (gms2object.scaleY < 0) {
							var verDifference = (object_get_height_cyop(_obj) - (object_get_yoffset_cyop(_obj) * 2)) * _yscale;
							_y -= verDifference;
						}
						var instance = create_cyop_object(object_to_id(gms2object.objectId.name), i, _x, _y, _xscale, _yscale, gms2object.scaleX < 0, gms2object.scaleY < 0);
						array_push(CYOProom.instances, instance);
					}
				}
			}
			
			CYOProom.properties.levelWidth = gms2room.roomSettings.Width;
			CYOProom.properties.levelHeight = gms2room.roomSettings.Height;
			
			_file = file_text_open_write("GTC Export/" + room_name + "_wfixed.json");
			file_text_write_string(_file, json_stringify(CYOProom, true));
			_file = file_text_close(_file);
			_file = file_text_open_write("GTC Export/" + room_name + ".json");
			file_text_write_string(_file, json_stringify(CYOProom, true));
			_file = file_text_close(_file);
			show_message("Make sure to drag both _wfixed AND normal room files into the rooms folder!");
			selected = false;
			#endregion
			} catch (error_data) {
				show_message("Failed to convert level. This can be caused by:\n-The folder not having a .yy file inside of it.\n-An error in the rooms code.\n-Trying to convert a single .yy file instead of a room folder.\nYou can check the error logs folder for more information.")
				var e = string_concat(error_data.message, "\n\n", error_data.longMessage, "\n\n", error_data.script, "\n\n", error_data.stacktrace);
				log(e);
			}
			break;
	}
}