local customization_menu = {};

local table_helpers;
local config;
local screen;
local player;

customization_menu.is_opened = false;
customization_menu.status = "OK";
customization_menu.window_flags = 0x10120;
customization_menu.color_picker_flags = 327680;

customization_menu.orientation_types = {"Horizontal", "Vertical"};

customization_menu.monster_UI_sorting_types = {"Normal", "Health", "Health Percentage"};

customization_menu.damage_meter_UI_highlighted_bar_types = {"Me", "Top Damage", "None"};
customization_menu.damage_meter_UI_damage_bar_relative_types = {"Total Damage", "Top Damage"};
customization_menu.damage_meter_UI_my_damage_bar_location_types = {"Normal", "First", "Last"};
customization_menu.damage_meter_UI_sorting_types = {"Normal", "Damage"};

customization_menu.fonts = {"Arial", "Arial Black", "Bahnschrift", "Calibri", "Cambria", "Cambria Math", "Candara", "Comic Sans MS",
"Consolas", "Constantia", "Corbel", "Courier New", "Ebrima", "Franklin Gothic Medium", "Gabriola", "Gadugi",
"Georgia", "HoloLens MDL2 Assets", "Impact", "Ink Free", "Javanese Text", "Leelawadee UI", "Lucida Console",
"Lucida Sans Unicode", "Malgun Gothic", "Marlett", "Microsoft Himalaya", "Microsoft JhengHei",
"Microsoft New Tai Lue", "Microsoft PhagsPa", "Microsoft Sans Serif", "Microsoft Tai Le", "Microsoft YaHei",
"Microsoft Yi Baiti", "MingLiU-ExtB", "Mongolian Baiti", "MS Gothic", "MV Boli", "Myanmar Text", "Nirmala UI",
"Palatino Linotype", "Segoe MDL2 Assets", "Segoe Print", "Segoe Script", "Segoe UI", "Segoe UI Historic",
"Segoe UI Emoji", "Segoe UI Symbol", "SimSun", "Sitka", "Sylfaen", "Symbol", "Tahoma", "Times New Roman",
"Trebuchet MS", "Verdana", "Webdings", "Wingdings", "Yu Gothic"};

customization_menu.monster_UI_orientation_index = 0;
customization_menu.monster_UI_sorting_type_index = 0;

customization_menu.damage_meter_UI_orientation_index = 0;
customization_menu.damage_meter_UI_sorting_type_index = 0;
customization_menu.damage_meter_UI_highlighted_bar_index = 0;
customization_menu.damage_meter_UI_damage_bar_relative_index = 0;
customization_menu.damage_meter_UI_my_damage_bar_location_index = 0;

customization_menu.selected_font_index = 9;

function customization_menu.init()
	customization_menu.monster_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types, config.current_config.large_monster_UI.settings.orientation, false);

	customization_menu.monster_UI_sorting_type_index = table_helpers.find_index(customization_menu.monster_UI_sorting_types, config.current_config.large_monster_UI.sorting.type, false);

	customization_menu.damage_meter_UI_orientation_index = table_helpers.find_index(customization_menu.orientation_types, config.current_config.damage_meter_UI.settings.orientation,
	false);

	customization_menu.damage_meter_UI_highlighted_bar_index = table_helpers.find_index(customization_menu.damage_meter_UI_highlighted_bar_types,
	config.current_config.damage_meter_UI.settings.highlighted_bar, false);

	customization_menu.damage_meter_UI_damage_bar_relative_index = table_helpers.find_index(customization_menu.damage_meter_UI_damage_bar_relative_types,
	config.current_config.damage_meter_UI.settings.damage_bar_relative_to, false);

	customization_menu.damage_meter_UI_my_damage_bar_location_index = table_helpers.find_index(customization_menu.damage_meter_UI_my_damage_bar_location_types,
	config.current_config.damage_meter_UI.settings.my_damage_bar_location, false);

	customization_menu.damage_meter_UI_sorting_type_index = table_helpers.find_index(customization_menu.damage_meter_UI_sorting_types, config.current_config.damage_meter_UI.sorting.type,
	false);

	customization_menu.selected_font_index = table_helpers.find_index(customization_menu.fonts, config.current_config.global_settings.font.family, false);
end

function customization_menu.draw()
	customization_menu.is_opened = imgui.begin_window("MHR Overlay " .. config.current_config.version, customization_menu.is_opened, customization_menu.window_flags);
	
	if not customization_menu.is_opened then
		return;
	end

	local config_changed = false;
	local changed;
	local status_string = tostring(customization_menu.status);
	imgui.text("Status: " .. status_string);

	if imgui.tree_node("Modules") then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox("Small Monster UI", config.current_config.small_monster_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.current_config.large_monster_UI.enabled = imgui.checkbox("Large Monster UI", config.current_config.large_monster_UI.enabled);
		config_changed = config_changed or changed;

		changed, config.current_config.time_UI.enabled = imgui.checkbox("Time UI", config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;
		imgui.same_line();

		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox("Damage Meter UI", config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		imgui.tree_pop();
	end

	if imgui.tree_node("Global Settings") then
		if imgui.tree_node("Module Visibility on Different Screens") then
			
			if imgui.tree_node("During Quest") then
				changed, config.current_config.global_settings.module_visibility.during_quest.small_monster_UI = imgui.checkbox("Small Monster UI", config.current_config.global_settings.module_visibility.during_quest.small_monster_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.large_monster_UI = imgui.checkbox("Large Monster UI", config.current_config.global_settings.module_visibility.during_quest.large_monster_UI);
				config_changed = config_changed or changed;

				changed, config.current_config.global_settings.module_visibility.during_quest.time_UI = imgui.checkbox("Time UI", config.current_config.global_settings.module_visibility.during_quest.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.current_config.global_settings.module_visibility.during_quest.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Quest Summary Screen") then
				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.time_UI = imgui.checkbox("Time UI", config.current_config.global_settings.module_visibility.quest_summary_screen.time_UI);
				config_changed = config_changed or changed;
				imgui.same_line();

				changed, config.current_config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.current_config.global_settings.module_visibility.quest_summary_screen.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end
	
			if imgui.tree_node("Training Area") then
				changed, config.current_config.global_settings.module_visibility.training_area.large_monster_UI = imgui.checkbox("Large Monster UI", config.current_config.global_settings.module_visibility.training_area.large_monster_UI);
				config_changed = config_changed or changed;
				imgui.same_line();
				
				changed, config.current_config.global_settings.module_visibility.training_area.damage_meter_UI = imgui.checkbox("Damage Meter UI", config.current_config.global_settings.module_visibility.training_area.damage_meter_UI);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Font") then
			imgui.text("Any changes to the font require script reload!");
	
			changed, customization_menu.selected_font_index = imgui.combo("Family", customization_menu.selected_font_index, customization_menu.fonts);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.global_settings.font.family = customization_menu.fonts[customization_menu.selected_font_index];
			end
	
			changed, config.current_config.global_settings.font.size = imgui.slider_int("Size", config.current_config.global_settings.font.size, 1, 100);
			config_changed = config_changed or changed;
	
			changed, config.current_config.global_settings.font.bold = imgui.checkbox("Bold", config.current_config.global_settings.font.bold);
			config_changed = config_changed or changed;
	
			changed, config.current_config.global_settings.font.italic = imgui.checkbox("Italic", config.current_config.global_settings.font.italic);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Small Monster UI") then
		changed, config.current_config.small_monster_UI.enabled = imgui.checkbox("Enabled", config.current_config.small_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Spacing") then
			changed, config.current_config.small_monster_UI.spacing.y = imgui.drag_float("X",
				config.current_config.small_monster_UI.spacing.y, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.spacing.y = imgui.drag_float("Y",
				config.current_config.small_monster_UI.spacing.y, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Settings") then
			changed, customization_menu.monster_UI_orientation_index = imgui.combo("Orientation", customization_menu.monster_UI_orientation_index, customization_menu.orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.settings.orientation = customization_menu.orientation_types[customization_menu.monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Dynamic Positioning") then
			changed, config.current_config.small_monster_UI.dynamic_positioning.enabled =
				imgui.checkbox("Enabled", config.current_config.small_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox("Opacity Falloff", config.current_config.small_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.dynamic_positioning.max_distance = imgui.drag_float("Max Distance",
					config.current_config.small_monster_UI.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");
				config_changed = config_changed or changed;

			if imgui.tree_node("World Offset") then
				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float("X",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float("Y",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float("Z",
					config.current_config.small_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float("X",
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float("Y",
					config.current_config.small_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.current_config.small_monster_UI.position.x = imgui.drag_float("X", config.current_config.small_monster_UI.position.x, 0.1, 0,
				screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.small_monster_UI.position.y = imgui.drag_float("Y", config.current_config.small_monster_UI.position.y, 0.1, 0,
				screen.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, customization_menu.monster_UI_sort_type_index = imgui.combo("Type", customization_menu.monster_UI_sort_type_index, customization_menu.monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.small_monster_UI.sorting.type = customization_menu.monster_UI_sorting_types[customization_menu.monster_UI_sort_type_index];
			end

			changed, config.current_config.small_monster_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.current_config.small_monster_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.current_config.small_monster_UI.monster_name_label.visibility =
				imgui.checkbox("Visible", config.current_config.small_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.small_monster_UI.monster_name_label.offset.x =
					imgui.drag_float("X", config.current_config.small_monster_UI.monster_name_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.small_monster_UI.monster_name_label.offset.y =
					imgui.drag_float("Y", config.current_config.small_monster_UI.monster_name_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.small_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.small_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.small_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.small_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.small_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.monster_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
		end

		if imgui.tree_node("Health") then
			if imgui.tree_node("Text Label") then
				changed, config.current_config.small_monster_UI.health.text_label.visibility =
					imgui.checkbox("Visible", config.current_config.small_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.text_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.health.text_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.current_config.small_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.x =
							imgui.drag_float("X", config.current_config.small_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.health.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.current_config.small_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.current_config.small_monster_UI.health.value_label.visibility =
					imgui.checkbox("Visible", config.current_config.small_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.value_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.health.value_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.health.value_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.health.value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.small_monster_UI.health.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.percentage_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.health.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.health.percentage_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.current_config.small_monster_UI.health.bar.visibility = imgui.checkbox("Visible", config.current_config.small_monster_UI.health.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.health.bar.offset.x = imgui.drag_float("X", config.current_config.small_monster_UI.health.bar
						.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.health.bar.offset.y = imgui.drag_float("Y", config.current_config.small_monster_UI.health.bar
						.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.current_config.small_monster_UI.health.bar.size.width =
						imgui.drag_float("Width", config.current_config.small_monster_UI.health.bar.size.width, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.health.bar.size.height =
						imgui.drag_float("Height", config.current_config.small_monster_UI.health.bar.size.height, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.current_config.small_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
					--	changed, config.current_config.small_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.health.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Stamina (Pointless: small monsters don't get tired)") then
			if imgui.tree_node("Text Label") then
				changed, config.current_config.small_monster_UI.stamina.text_label.visibility =
					imgui.checkbox("Visible", config.current_config.small_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.text_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.stamina.text_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.current_config.small_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x =
							imgui.drag_float("X", config.current_config.small_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.current_config.small_monster_UI.stamina.value_label.visibility =
					imgui.checkbox("Visible", config.current_config.small_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.value_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.stamina.value_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.stamina.value_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.small_monster_UI.stamina.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.small_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.x =
						imgui.drag_float("X", config.current_config.small_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.stamina.percentage_label.offset.y =
						imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.small_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.small_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.small_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.small_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.current_config.small_monster_UI.stamina.bar.visibility = imgui.checkbox("Visible", config.current_config.small_monster_UI.stamina.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.small_monster_UI.stamina.bar.offset.x = imgui.drag_float("X", config.current_config.small_monster_UI.stamina.bar
						.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.stamina.bar.offset.y = imgui.drag_float("Y", config.current_config.small_monster_UI.stamina.bar
						.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.current_config.small_monster_UI.stamina.bar.size.width =
						imgui.drag_float("Width", config.current_config.small_monster_UI.stamina.bar.size.width, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.small_monster_UI.stamina.bar.size.height =
						imgui.drag_float("Height", config.current_config.small_monster_UI.stamina.bar.size.height, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.current_config.small_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.current_config.small_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.small_monster_UI.stamina.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Large Monster UI") then
		changed, config.current_config.large_monster_UI.enabled = imgui.checkbox("Enabled", config.current_config.large_monster_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Spacing") then
			changed, config.current_config.large_monster_UI.spacing.x = imgui.drag_float("X",
				config.current_config.large_monster_UI.spacing.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.large_monster_UI.spacing.y = imgui.drag_float("Y",
				config.current_config.large_monster_UI.spacing.y, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Settings") then
			changed, customization_menu.monster_UI_orientation_index = imgui.combo("Orientation", customization_menu.monster_UI_orientation_index, customization_menu.orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.large_monster_UI.settings.orientation = customization_menu.orientation_types[customization_menu.monster_UI_orientation_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Dynamic Positioning") then
			changed, config.current_config.large_monster_UI.dynamic_positioning.enabled =
				imgui.checkbox("Enabled", config.current_config.large_monster_UI.dynamic_positioning.enabled);
			config_changed = config_changed or changed;

			changed, config.current_config.large_monster_UI.dynamic_positioning.opacity_falloff = imgui.checkbox("Opacity Falloff", config.current_config.large_monster_UI.dynamic_positioning.opacity_falloff);
			config_changed = config_changed or changed;

			changed, config.current_config.large_monster_UI.dynamic_positioning.max_distance = imgui.drag_float("Max Distance",
					config.current_config.large_monster_UI.dynamic_positioning.max_distance, 1, 0, 10000, "%.0f");
				config_changed = config_changed or changed;

			if imgui.tree_node("World Offset") then
				changed, config.current_config.large_monster_UI.dynamic_positioning.world_offset.x = imgui.drag_float("X",
					config.current_config.large_monster_UI.dynamic_positioning.world_offset.x, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic_positioning.world_offset.y = imgui.drag_float("Y",
					config.current_config.large_monster_UI.dynamic_positioning.world_offset.y, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic_positioning.world_offset.z = imgui.drag_float("Z",
					config.current_config.large_monster_UI.dynamic_positioning.world_offset.z, 0.1, -100, 100, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Viewport Offset") then
				changed, config.current_config.large_monster_UI.dynamic_positioning.viewport_offset.x = imgui.drag_float("X",
					config.current_config.large_monster_UI.dynamic_positioning.viewport_offset.x, 0.1, 0, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.dynamic_positioning.viewport_offset.y = imgui.drag_float("Y",
					config.current_config.large_monster_UI.dynamic_positioning.viewport_offset.y, 0.1, 0, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.current_config.large_monster_UI.position.x = imgui.drag_float("X", config.current_config.large_monster_UI.position.x, 0.1, 0,
				screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.large_monster_UI.position.y = imgui.drag_float("Y", config.current_config.large_monster_UI.position.y, 0.1, 0,
				screen.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, customization_menu.monster_UI_sort_type_index = imgui.combo("Type", customization_menu.monster_UI_sort_type_index, customization_menu.monster_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.large_monster_UI.sorting.type = customization_menu.monster_UI_sorting_types[customization_menu.monster_UI_sort_type_index];
			end

			changed, config.current_config.large_monster_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.current_config.large_monster_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Monster Name Label") then
			changed, config.current_config.large_monster_UI.monster_name_label.visibility =
				imgui.checkbox("Visible", config.current_config.large_monster_UI.monster_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				changed, config.current_config.large_monster_UI.monster_name_label.include.monster_name =
					imgui.checkbox("Monster Name", config.current_config.large_monster_UI.monster_name_label.include.monster_name);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.monster_name_label.include.crown =
					imgui.checkbox("Crown", config.current_config.large_monster_UI.monster_name_label.include.crown);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.monster_name_label.include.size =
					imgui.checkbox("Size", config.current_config.large_monster_UI.monster_name_label.include.size);
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.monster_name_label.include.scrown_thresholds = imgui.checkbox(
					"Crown Thresholds", config.current_config.large_monster_UI.monster_name_label.include.scrown_thresholds);
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.current_config.large_monster_UI.monster_name_label.offset.x =
					imgui.drag_float("X", config.current_config.large_monster_UI.monster_name_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.large_monster_UI.monster_name_label.offset.y =
					imgui.drag_float("Y", config.current_config.large_monster_UI.monster_name_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.large_monster_UI.monster_name_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.monster_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.large_monster_UI.monster_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.large_monster_UI.monster_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.monster_name_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.large_monster_UI.monster_name_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.large_monster_UI.monster_name_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.large_monster_UI.monster_name_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.monster_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.monster_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Health") then
			if imgui.tree_node("Text Label") then
				changed, config.current_config.large_monster_UI.health.text_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.health.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.health.text_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.health.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.health.text_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.health.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.health.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.health.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.current_config.large_monster_UI.health.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.health.text_label.shadow.offset.x =
							imgui.drag_float("X", config.current_config.large_monster_UI.health.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.health.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.current_config.large_monster_UI.health.text_label.shadow.offset.y, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.health.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.current_config.large_monster_UI.health.value_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.health.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.health.value_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.health.value_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.health.value_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.health.value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.health.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.health.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.health.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.health.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.health.value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.health.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.health.value_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.health.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.large_monster_UI.health.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.large_monster_UI.health.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.health.percentage_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.health.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.health.percentage_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.health.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.health.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.health.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.health.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.health.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.health.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.health.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.health.percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.health.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.current_config.large_monster_UI.health.bar.visibility = imgui.checkbox("Visible", config.current_config.large_monster_UI.health.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.health.bar.offset.x = imgui.drag_float("X", config.current_config.large_monster_UI.health.bar
						.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.health.bar.offset.y = imgui.drag_float("Y", config.current_config.large_monster_UI.health.bar
						.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.current_config.large_monster_UI.health.bar.size.width =
						imgui.drag_float("Width", config.current_config.large_monster_UI.health.bar.size.width, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.health.bar.size.height =
						imgui.drag_float("Height", config.current_config.large_monster_UI.health.bar.size.height, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.current_config.large_monster_UI.health.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.current_config.large_monster_UI.health.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Monster can be captured") then
						if imgui.tree_node("Foreground") then
							--changed, config.current_config.large_monster_UI.health.bar.colors.capture.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.bar.colors.capture.foreground, color_picker_flags);
							config_changed = config_changed or changed;
							
							imgui.tree_pop();
						end
		
						if imgui.tree_node("Background") then
							--changed, config.current_config.large_monster_UI.health.bar.colors.capture.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.health.bar.colors.capture.background, color_picker_flags);
							config_changed = config_changed or changed;
							
							imgui.tree_pop();
						end
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Stamina") then
			if imgui.tree_node("Text Label") then
				changed, config.current_config.large_monster_UI.stamina.text_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.stamina.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.stamina.text_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.stamina.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.stamina.text_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.stamina.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.stamina.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.stamina.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.current_config.large_monster_UI.stamina.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.stamina.text_label.shadow.offset.x =
							imgui.drag_float("X", config.current_config.large_monster_UI.stamina.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.stamina.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.current_config.large_monster_UI.stamina.text_label.shadow.offset.y, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.stamina.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.current_config.large_monster_UI.stamina.value_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.stamina.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.stamina.value_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.stamina.value_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.stamina.value_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.stamina.value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.stamina.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.stamina.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.stamina.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.stamina.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.stamina.value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.stamina.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.stamina.value_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.stamina.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.large_monster_UI.stamina.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.large_monster_UI.stamina.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.stamina.percentage_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.stamina.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.stamina.percentage_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.stamina.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.stamina.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.stamina.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.stamina.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.stamina.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.stamina.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.stamina.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.stamina.percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.stamina.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.current_config.large_monster_UI.stamina.bar.visibility = imgui.checkbox("Visible", config.current_config.large_monster_UI.stamina.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.stamina.bar.offset.x = imgui.drag_float("X", config.current_config.large_monster_UI.stamina.bar
						.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.stamina.bar.offset.y = imgui.drag_float("Y", config.current_config.large_monster_UI.stamina.bar
						.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.current_config.large_monster_UI.stamina.bar.size.width =
						imgui.drag_float("Width", config.current_config.large_monster_UI.stamina.bar.size.width, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.stamina.bar.size.height =
						imgui.drag_float("Height", config.current_config.large_monster_UI.stamina.bar.size.height, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.current_config.large_monster_UI.stamina.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.current_config.large_monster_UI.stamina.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.stamina.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Rage") then
			if imgui.tree_node("Text Label") then
				changed, config.current_config.large_monster_UI.rage.text_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.rage.text_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.rage.text_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.rage.text_label.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.rage.text_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.rage.text_label.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.rage.text_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.text_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.rage.text_label.shadow.visibility =
						imgui.checkbox("Enable", config.current_config.large_monster_UI.rage.text_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.rage.text_label.shadow.offset.x =
							imgui.drag_float("X", config.current_config.large_monster_UI.rage.text_label.shadow.offset.x, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.rage.text_label.shadow.offset.y =
							imgui.drag_float("Y", config.current_config.large_monster_UI.rage.text_label.shadow.offset.y, 0.1, -screen.width,
								screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.rage.text_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.text_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Value Label") then
				changed, config.current_config.large_monster_UI.rage.value_label.visibility =
					imgui.checkbox("Visible", config.current_config.large_monster_UI.rage.value_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.rage.value_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.rage.value_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.rage.value_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.rage.value_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.rage.value_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.value_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.rage.value_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.rage.value_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.rage.value_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.rage.value_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.rage.value_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.rage.value_label.shadow.offset.y, 0.1, -screen.height, screen.height, "%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.rage.value_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.value_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Percentage Label") then
				changed, config.current_config.large_monster_UI.rage.percentage_label.visibility = imgui.checkbox("Visible",
					config.current_config.large_monster_UI.rage.percentage_label.visibility);
				config_changed = config_changed or changed;
	
				-- add text format
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.rage.percentage_label.offset.x =
						imgui.drag_float("X", config.current_config.large_monster_UI.rage.percentage_label.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.rage.percentage_label.offset.y =
						imgui.drag_float("Y", config.current_config.large_monster_UI.rage.percentage_label.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Color") then
					--changed, config.current_config.large_monster_UI.rage.percentage_label.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.percentage_label.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Shadow") then
					changed, config.current_config.large_monster_UI.rage.percentage_label.shadow.visibility = imgui.checkbox("Enable",
						config.current_config.large_monster_UI.rage.percentage_label.shadow.visibility);
					config_changed = config_changed or changed;
	
					if imgui.tree_node("Offset") then
						changed, config.current_config.large_monster_UI.rage.percentage_label.shadow.offset.x = imgui.drag_float("X",
							config.current_config.large_monster_UI.rage.percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width,
							"%.1f");
						config_changed = config_changed or changed;
	
						changed, config.current_config.large_monster_UI.rage.percentage_label.shadow.offset.y = imgui.drag_float("Y",
							config.current_config.large_monster_UI.rage.percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
							"%.1f");
						config_changed = config_changed or changed;
	
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Color") then
						--changed, config.current_config.large_monster_UI.rage.percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.percentage_label.shadow.color, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end
	
			if imgui.tree_node("Bar") then
				changed, config.current_config.large_monster_UI.rage.bar.visibility = imgui.checkbox("Visible", config.current_config.large_monster_UI.rage.bar
					.visibility);
				config_changed = config_changed or changed;
	
				if imgui.tree_node("Offset") then
					changed, config.current_config.large_monster_UI.rage.bar.offset.x = imgui.drag_float("X", config.current_config.large_monster_UI.rage.bar
						.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.rage.bar.offset.y = imgui.drag_float("Y", config.current_config.large_monster_UI.rage.bar
						.offset.y, 0.1, -screen.height, screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Size") then
					changed, config.current_config.large_monster_UI.rage.bar.size.width =
						imgui.drag_float("Width", config.current_config.large_monster_UI.rage.bar.size.width, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;
	
					changed, config.current_config.large_monster_UI.rage.bar.size.height =
						imgui.drag_float("Height", config.current_config.large_monster_UI.rage.bar.size.height, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;
	
					imgui.tree_pop();
				end
	
				if imgui.tree_node("Colors") then
					if imgui.tree_node("Foreground") then
						--changed, config.current_config.large_monster_UI.rage.bar.colors.foreground = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.bar.colors.foreground, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					if imgui.tree_node("Background") then
						--changed, config.current_config.large_monster_UI.rage.bar.colors.background = imgui.color_picker_argb("", config.current_config.large_monster_UI.rage.bar.colors.background, color_picker_flags);
						config_changed = config_changed or changed;
						
						imgui.tree_pop();
					end
	
					imgui.tree_pop();
				end
	
				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Time UI") then
		changed, config.current_config.time_UI.enabled = imgui.checkbox("Enabled", config.current_config.time_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Position") then
			changed, config.current_config.time_UI.position.x = imgui.drag_float("X", config.current_config.time_UI.position.x, 0.1, 0, screen.width,
				"%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.time_UI.position.y = imgui.drag_float("Y", config.current_config.time_UI.position.y, 0.1, 0, screen.height,
				"%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Time Label") then
			changed, config.current_config.time_UI.time_label.visibility = imgui.checkbox("Visible", config.current_config.time_UI.time_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.time_UI.time_label.offset.x = imgui.drag_float("X", config.current_config.time_UI.time_label.offset.x, 0.1,
					-screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.time_UI.time_label.offset.y = imgui.drag_float("Y", config.current_config.time_UI.time_label.offset.y, 0.1,
					-screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.time_UI.time_label.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.time_UI.time_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.time_UI.time_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.time_UI.time_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.time_UI.time_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.time_UI.time_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.time_UI.time_label.shadow.offset.y, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.time_UI.time_label.shadow.color = imgui.color_picker_argb("", config.current_config.time_UI.time_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end
			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	if imgui.tree_node("Damage Meter UI") then
		changed, config.current_config.damage_meter_UI.enabled = imgui.checkbox("Enabled", config.current_config.damage_meter_UI.enabled);
		config_changed = config_changed or changed;

		if imgui.tree_node("Settings") then
			changed, config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero = imgui.checkbox(
				"Hide Module if Total Damage is 0", config.current_config.damage_meter_UI.settings.hide_module_if_total_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero = imgui.checkbox(
				"Hide Player if Player Damage is 0", config.current_config.damage_meter_UI.settings.hide_player_if_player_damage_is_zero);
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative = imgui.checkbox(
				"Total Damage Offset is Relative", config.current_config.damage_meter_UI.settings.total_damage_offset_is_relative);
			config_changed = config_changed or changed;

			changed, customization_menu.damage_meter_UI_orientation_index = imgui.combo("Orientation", customization_menu.damage_meter_UI_orientation_index,
				customization_menu.orientation_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.orientation = customization_menu.orientation_types[customization_menu.damage_meter_UI_orientation_index];
			end

			changed, customization_menu.damage_meter_UI_highlighted_bar_index = imgui.combo("Highlighted Bar",
			customization_menu.damage_meter_UI_highlighted_bar_index, customization_menu.damage_meter_UI_highlighted_bar_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.highlighted_bar =
				customization_menu.damage_meter_UI_highlighted_bar_types[customization_menu.damage_meter_UI_highlighted_bar_index];
			end

			changed, customization_menu.damage_meter_UI_damage_bar_relative_index = imgui.combo("Damage Bars are Relative to",
			customization_menu.damage_meter_UI_damage_bar_relative_index, customization_menu.damage_meter_UI_damage_bar_relative_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.damage_bar_relative_to =
				customization_menu.damage_meter_UI_damage_bar_relative_types[customization_menu.damage_meter_UI_damage_bar_relative_index];
			end

			changed, customization_menu.damage_meter_UI_my_damage_bar_location_index = imgui.combo("My Damage Bar Location",
			customization_menu.damage_meter_UI_my_damage_bar_location_index, customization_menu.damage_meter_UI_my_damage_bar_location_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.settings.my_damage_bar_location =
				customization_menu.damage_meter_UI_my_damage_bar_location_types[customization_menu.damage_meter_UI_my_damage_bar_location_index];
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Monster Types") then
			local tracked_monster_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_monster_types.small_monsters =
				imgui.checkbox("Small Monsters", config.current_config.damage_meter_UI.tracked_monster_types.small_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_monster_types.large_monsters =
				imgui.checkbox("Large Monsters", config.current_config.damage_meter_UI.tracked_monster_types.large_monsters);
			config_changed = config_changed or changed;
			tracked_monster_types_changed = tracked_monster_types_changed or changed;

			if tracked_monster_types_changed then
				for player_id, _player in pairs(player.list) do
					_player.update_display(player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Tracked Damage Types") then
			local tracked_damage_types_changed = false;
			changed, config.current_config.damage_meter_UI.tracked_damage_types.player_damage =
				imgui.checkbox("Player Damage", config.current_config.damage_meter_UI.tracked_damage_types.player_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage = imgui.checkbox("Bomb Damage",
				config.current_config.damage_meter_UI.tracked_damage_types.bomb_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage =
				imgui.checkbox("Kunai Damage", config.current_config.damage_meter_UI.tracked_damage_types.kunai_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.installation_damage =
				imgui.checkbox("Installation Damage", config.current_config.damage_meter_UI.tracked_damage_types.installation_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage =
				imgui.checkbox("Otomo Damage", config.current_config.damage_meter_UI.tracked_damage_types.otomo_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			changed, config.current_config.damage_meter_UI.tracked_damage_types.monster_damage =
				imgui.checkbox("Monster Damage", config.current_config.damage_meter_UI.tracked_damage_types.monster_damage);
			config_changed = config_changed or changed;
			tracked_damage_types_changed = tracked_damage_types_changed or changed;

			if tracked_damage_types_changed then
				for player_id, _player in pairs(player.list) do
					player.update_display(_player);
				end
				player.update_display(player.total);
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Spacing") then
			changed, config.current_config.damage_meter_UI.spacing.x = imgui.drag_float("X",
				config.current_config.damage_meter_UI.spacing.x, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.spacing.y = imgui.drag_float("Y",
				config.current_config.damage_meter_UI.spacing.y, 0.1, 0, screen.width, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Position") then
			changed, config.current_config.damage_meter_UI.position.x = imgui.drag_float("X", config.current_config.damage_meter_UI.position.x, 0.1, 0,
				screen.width, "%.1f");
			config_changed = config_changed or changed;

			changed, config.current_config.damage_meter_UI.position.y = imgui.drag_float("Y", config.current_config.damage_meter_UI.position.y, 0.1, 0,
				screen.height, "%.1f");
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Sorting") then
			changed, customization_menu.damage_meter_UI_sort_type_index = imgui.combo("Type", customization_menu.damage_meter_UI_sort_type_index,
			customization_menu.damage_meter_UI_sorting_types);
			config_changed = config_changed or changed;
			if changed then
				config.current_config.damage_meter_UI.sorting.type = customization_menu.damage_meter_UI_sorting_types[customization_menu.damage_meter_UI_sort_type_index];
			end

			changed, config.current_config.damage_meter_UI.sorting.reversed_order = imgui.checkbox("Reversed Order",
				config.current_config.damage_meter_UI.sorting.reversed_order);
			config_changed = config_changed or changed;

			imgui.tree_pop();
		end

		if imgui.tree_node("Player Name Label") then
			changed, config.current_config.damage_meter_UI.player_name_label.visibility =
				imgui.checkbox("Visible", config.current_config.damage_meter_UI.player_name_label.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Include") then
				if imgui.tree_node("Me") then
					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank = imgui.checkbox("Hunter Rank",
						config.current_config.damage_meter_UI.player_name_label.include.myself.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.word_player =
						imgui.checkbox("Word \"Player\"", config.current_config.damage_meter_UI.player_name_label.include.myself.word_player);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_id = imgui.checkbox("Player ID",
						config.current_config.damage_meter_UI.player_name_label.include.myself.player_id);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.myself.player_name = imgui.checkbox("Player Name",
						config.current_config.damage_meter_UI.player_name_label.include.myself.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Other Players") then
					changed, config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank = imgui.checkbox("Hunter Rank",
						config.current_config.damage_meter_UI.player_name_label.include.others.hunter_rank);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.word_player =
						imgui.checkbox("Word \"Player\"", config.current_config.damage_meter_UI.player_name_label.include.others.word_player);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_id = imgui.checkbox("Player ID",
						config.current_config.damage_meter_UI.player_name_label.include.others.player_id);
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.include.others.player_name = imgui.checkbox("Player Name",
						config.current_config.damage_meter_UI.player_name_label.include.others.player_name);
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.player_name_label.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.player_name_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.player_name_label.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.player_name_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.damage_meter_UI.player_name_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.player_name_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.player_name_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.x =
						imgui.drag_float("X", config.current_config.damage_meter_UI.player_name_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.player_name_label.shadow.offset.y =
						imgui.drag_float("Y", config.current_config.damage_meter_UI.player_name_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.damage_meter_UI.player_name_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.player_name_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Value Label") then
			changed, config.current_config.damage_meter_UI.damage_value_label.visibility =
				imgui.checkbox("Visible", config.current_config.damage_meter_UI.damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_value_label.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.damage_value_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_value_label.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.damage_value_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.damage_meter_UI.damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x =
						imgui.drag_float("X", config.current_config.damage_meter_UI.damage_value_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y =
						imgui.drag_float("Y", config.current_config.damage_meter_UI.damage_value_label.shadow.offset.y, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.damage_meter_UI.damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Percentage Label") then
			changed, config.current_config.damage_meter_UI.damage_percentage_label.visibility =
				imgui.checkbox("Visible", config.current_config.damage_meter_UI.damage_percentage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.damage_percentage_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_percentage_label.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.damage_percentage_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.damage_meter_UI.damage_percentage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.damage_percentage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.x, 0.1, -screen.width, screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.damage_percentage_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.damage_meter_UI.damage_percentage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_percentage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Label") then
			changed, config.current_config.damage_meter_UI.total_damage_label.visibility =
				imgui.checkbox("Visible", config.current_config.damage_meter_UI.total_damage_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.total_damage_label.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.total_damage_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_label.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.total_damage_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.damage_meter_UI.total_damage_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.total_damage_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.total_damage_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x =
						imgui.drag_float("X", config.current_config.damage_meter_UI.total_damage_label.shadow.offset.x, 0.1, -screen.width,
							screen.width, "%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y =
						imgui.drag_float("Y", config.current_config.damage_meter_UI.total_damage_label.shadow.offset.y, 0.1, -screen.height,
							screen.height, "%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.damage_meter_UI.total_damage_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Total Damage Value Label") then
			changed, config.current_config.damage_meter_UI.total_damage_value_label.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.total_damage_value_label.visibility);
			config_changed = config_changed or changed;

			-- add text format

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.total_damage_value_label.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.total_damage_value_label.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.total_damage_value_label.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Color") then
				--changed, config.current_config.damage_meter_UI.total_damage_value_label.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.color, color_picker_flags);
				config_changed = config_changed or changed;
				
				imgui.tree_pop();
			end

			if imgui.tree_node("Shadow") then
				changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility = imgui.checkbox("Enable",
					config.current_config.damage_meter_UI.total_damage_value_label.shadow.visibility);
				config_changed = config_changed or changed;

				if imgui.tree_node("Offset") then
					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x = imgui.drag_float("X",
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.x, 0.1, -screen.width, screen.width,
						"%.1f");
					config_changed = config_changed or changed;

					changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y = imgui.drag_float("Y",
						config.current_config.damage_meter_UI.total_damage_value_label.shadow.offset.y, 0.1, -screen.height, screen.height,
						"%.1f");
					config_changed = config_changed or changed;

					imgui.tree_pop();
				end

				if imgui.tree_node("Color") then
					--changed, config.current_config.damage_meter_UI.total_damage_value_label.shadow.color = imgui.color_picker_argb("", config.current_config.damage_meter_UI.total_damage_value_label.shadow.color, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Damage Bar") then
			changed, config.current_config.damage_meter_UI.damage_bar.visibility = imgui.checkbox("Visible",
				config.current_config.damage_meter_UI.damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.damage_bar.offset.x = imgui.drag_float("X",
					config.current_config.damage_meter_UI.damage_bar.offset.x, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.offset.y = imgui.drag_float("Y",
					config.current_config.damage_meter_UI.damage_bar.offset.y, 0.1, -screen.height, screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.current_config.damage_meter_UI.damage_bar.size.width = imgui.drag_float("Width", config.current_config.damage_meter_UI.damage_bar
					.size.width, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.damage_bar.size.height =
					imgui.drag_float("Height", config.current_config.damage_meter_UI.damage_bar.size.height, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					--changed, config.current_config.damage_meter_UI.damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					--changed, config.current_config.damage_meter_UI.damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		if imgui.tree_node("Highlighted Damage Bar") then
			changed, config.current_config.damage_meter_UI.highlighted_damage_bar.visibility =
				imgui.checkbox("Visible", config.current_config.damage_meter_UI.highlighted_damage_bar.visibility);
			config_changed = config_changed or changed;

			if imgui.tree_node("Offset") then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x =
					imgui.drag_float("X", config.current_config.damage_meter_UI.highlighted_damage_bar.offset.x, 0.1, -screen.width,
						screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y =
					imgui.drag_float("Y", config.current_config.damage_meter_UI.highlighted_damage_bar.offset.y, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Size") then
				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.width = imgui.drag_float("Width", config.current_config.damage_meter_UI.highlighted_damage_bar
					.size.width, 0.1, -screen.width, screen.width, "%.1f");
				config_changed = config_changed or changed;

				changed, config.current_config.damage_meter_UI.highlighted_damage_bar.size.height =
					imgui.drag_float("Height", config.current_config.damage_meter_UI.highlighted_damage_bar.size.height, 0.1, -screen.height,
						screen.height, "%.1f");
				config_changed = config_changed or changed;

				imgui.tree_pop();
			end

			if imgui.tree_node("Colors") then
				if imgui.tree_node("Foreground") then
					--changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.foreground, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				if imgui.tree_node("Background") then
					--changed, config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background = imgui.color_picker_argb("", config.current_config.damage_meter_UI.highlighted_damage_bar.colors.background, color_picker_flags);
					config_changed = config_changed or changed;
					
					imgui.tree_pop();
				end

				imgui.tree_pop();
			end

			imgui.tree_pop();
		end

		imgui.tree_pop();
	end

	imgui.end_window();

	if config_changed then
		config.save();
	end
end

function customization_menu.init_module()
	table_helpers = require("MHR_Overlay.Misc.table_helpers");
	config = require("MHR_Overlay.Misc.config");
	screen = require("MHR_Overlay.Game_Handler.screen");
	player = require("MHR_Overlay.Damage_Meter.player");

	customization_menu.init();
end

return customization_menu;