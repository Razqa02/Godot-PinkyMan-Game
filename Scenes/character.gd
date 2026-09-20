extends CharacterBody2D
class_name Player

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sound_jump: AudioStreamPlayer2D = $SoundJump

# ── Movement ──
const MAX_SPEED: float = 300.0
const ACCELERATION: float = 2400.0
const FRICTION: float = 5000.0
const JUMP_VELOCITY: float = -620.0

# ── Coyote Time (bisa lompat sesaat setelah lepas dari platform) ──
const COYOTE_DURATION: float = 0.09

# ── Jump Buffer (tekan lompat sedikit sebelum mendarat tetap jalan) ──
const JUMP_BUFFER_DURATION: float = 0.09

# ── Variable Jump Height (lepas tombol lompat lebih awal = lompatan lebih pendek) ──
const JUMP_CUT_MULTIPLIER: float = 0.45

# ── Fall speed cap ──
const MAX_FALL_SPEED: float = 900.0

var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0
var health: int = 3

func _ready() -> void:
	collision_mask = 1
	# RectangleShape2D (10x26) — lebih sempit dari tile (16px) agar tidak nyangkut
	$CollisionShape2D.position.y = 2.2
	# Safe margin: jarak aman sebelum deteksi tabrakan
	safe_margin = 0.08
	# Floor settings
	floor_snap_length = 4.0
	floor_max_angle = deg_to_rad(46.0)
	floor_constant_speed = true
	floor_block_on_wall = false

func _physics_process(delta: float) -> void:
	# ── Timer ──
	coyote_timer = maxf(coyote_timer - delta, 0.0)
	jump_buffer_timer = maxf(jump_buffer_timer - delta, 0.0)

	if is_on_floor():
		coyote_timer = COYOTE_DURATION

	# ── Jump Buffer ──
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_DURATION

	# ── Gravitasi ──
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
		velocity.y = minf(velocity.y, MAX_FALL_SPEED)

	# ── Lompat (coyote time + jump buffer) ──
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		sound_jump.play()

	# ── Variable Jump Height ──
	if Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	# ── Horizontal Movement (akselerasi & friksi halus) ──
	var direction: float = Input.get_axis("left", "right")
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	move_and_slide()

	# ── Flip Sprite ──
	if direction > 0.0:
		animated_sprite_2d.flip_h = false
	elif direction < 0.0:
		animated_sprite_2d.flip_h = true

	# ── Animasi ──
	update_animation(direction)

func update_animation(direction: float) -> void:
	if not is_on_floor():
		animated_sprite_2d.play("jumping")
	elif direction != 0.0:
		animated_sprite_2d.play("running")
	else:
		animated_sprite_2d.play("idle")


func take_damage(amount: int) -> void:
	health -= amount
	print("Player took damage! Health: ", health)
	if health <= 0:
		_die()


func _die() -> void:
	print("Player died! Returning to main menu.")
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
