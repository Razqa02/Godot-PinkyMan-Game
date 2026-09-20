extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_died
const SPEED = 100.0
var direction = -1.0
var damage = 1

@onready var game_manager: Node = get_tree().get_first_node_in_group("game_manager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Auto-connect signal to game manager if available
	if game_manager != null:
		player_died.connect(_on_player_died.bind())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta


func _on_timer_timeout() -> void:
	direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		emit_signal("player_died", body)
		body.take_damage(damage)


func _on_player_died(_body: Node2D) -> void:
	print("Player was hit by snail at position: ", position)
