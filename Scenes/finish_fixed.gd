extends Area2D

const MAIN_MENU_SCENE: String = "res://Scenes/main_menu.tscn"

## Path to the scene loaded when the player reaches the finish line.
## Stored as a String (not a PackedScene) so scene files don't reference each
## other directly — a PackedScene export here would create a circular load
## dependency between finish.tscn and level2.tscn.
## Leave empty to fall back to the main menu.
@export_file("*.tscn") var target_level: String = ""


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var next_scene: String = target_level
		if next_scene.is_empty():
			next_scene = MAIN_MENU_SCENE
		get_tree().change_scene_to_file(next_scene)