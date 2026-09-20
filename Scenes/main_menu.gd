extends Node

const LEVEL_1_SCENE: String = "res://Scenes/level1.tscn"
const LEVEL_2_SCENE: String = "res://Scenes/level2.tscn"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_1_SCENE)


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_2_SCENE)
