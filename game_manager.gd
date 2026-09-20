extends Node
class_name GameManager

## Group used by other scenes (e.g. collectables) to find the active manager.
const GROUP_NAME: String = "game_manager"

@onready var points_label: Label = $"../UI/Panel/PointsLabel"

var points: int = 0


func _ready() -> void:
	add_to_group(GROUP_NAME)


func add_point() -> void:
	points += 1
	points_label.text = "Points: " + str(points)
