extends Control


var label: Label

func _ready():
	label = $Panel/Label


# Display player names and their timer. Sort timers in ascending order and display them.
func display_all_players():
	var player_list = $Panel/Results/PlayerList

	for child in player_list.get_children():
		player_list.remove_child(child)
		child.queue_free()
	
	# sort all_players array by players[i].timer value in ascending order
	var players_sorted = []
	for player in get_tree().get_nodes_in_group("players"):
		var car_name = player.get_vehicle_name()
		players_sorted.append([player.name, car_name, player.timer])
	
	# Sort the players_sorted list by the timer values (second element of each sublist) without using lambda
	var n = players_sorted.size()
	for i in range(n - 1):
		for j in range(n - i - 1):
			if players_sorted[j][2] > players_sorted[j + 1][2]:
				# Swap the elements
				var temp = players_sorted[j]
				players_sorted[j] = players_sorted[j + 1]
				players_sorted[j + 1] = temp
	
	for player in players_sorted:
		var hbox = HBoxContainer.new()
		
		var name_label = Label.new()
		name_label.text = player[0]
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var car_label = Label.new()
		car_label.text = player[1]
		car_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		car_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var time_label = Label.new()
		time_label.text = str(snapped(player[2], 0.001))
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		time_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		hbox.add_child(name_label)
		hbox.add_child(car_label)
		hbox.add_child(time_label)
		
		player_list.add_child(hbox)


func _on_back_to_main_menu_button_pressed():
	SceneManager.switch_scene(
		SceneManager.load_scene("res://MainMenu/MainMenu.tscn")
	)
