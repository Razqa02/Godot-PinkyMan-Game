extends Node
class_name Level2Handler

@onready var game_manager: Node = get_tree().get_first_node_in_group("game_manager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect all snail enemy signals
	var enemies = get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			if enemy.has_signal("player_died"):
				enemy.player_died.connect(_on_snail_hit_player)


func _on_snail_hit_player(body: Node2D) -> void:
	print("Snail hit the player at: ", body.global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass