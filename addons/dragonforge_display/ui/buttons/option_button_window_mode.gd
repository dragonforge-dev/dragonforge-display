class_name OptionButtonWindowMode extends OptionButton


func _ready() -> void:
	add_item("Windowed", Window.MODE_WINDOWED)
	add_item("Borderless", Window.MODE_FULLSCREEN)
	add_item("Fullscreen", Window.MODE_EXCLUSIVE_FULLSCREEN)
	self.item_selected.connect(_on_window_mode_selected)
	selected = get_item_index(get_window().mode)


func _on_window_mode_selected(index: int) -> void:
	Display.select_window_mode(get_item_id(index))
