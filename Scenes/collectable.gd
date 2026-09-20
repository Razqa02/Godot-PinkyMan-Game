extends Area2D

## Found via group rather than "%GameManager": unique-name lookups are not
## resolved yet during the collectable's @onready, which made this null.
@onready var game_manager: GameManager = get_tree().get_first_node_in_group(GameManager.GROUP_NAME)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if game_manager != null:
			game_manager.add_point()
		queue_free()
