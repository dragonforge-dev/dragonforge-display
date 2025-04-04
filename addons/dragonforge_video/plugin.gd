@tool
extends EditorPlugin


const AUTOLOAD_VIDEO = "Video"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_VIDEO, "res://addons/dragonforge_video/video.tscn")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_VIDEO)
