extends Control

@onready var display: Screen = $Display


func _ready() -> void:
	display.show()
