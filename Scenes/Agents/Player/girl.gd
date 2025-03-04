extends CharacterBody3D

@export var is_fighting_scene:bool = false

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

@onready var animation_player = $AnimationPlayer;
@onready var sprite3D = $Sprite3D;

var stats : Resource

signal on_player_is_moving()
signal on_attacking()

func _ready() -> void:
	animation_IDLE()
	stats = player_stats.new();

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		animation_JUMP_START()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_fighting_scene:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			on_player_is_moving.emit()
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			sprite_direction(direction.x)
			if not is_jumping and not is_attacking:
				animation_WALK()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			if not is_jumping and not is_attacking:
				animation_IDLE()

		move_and_slide()
		
	if Input.is_key_pressed(KEY_C):
		animation_ATACK()
			
#region Animation Region
const ANIMATION_IDLE_NAME : String = "IDLE"
const ANIMATION_ATACK_NAME : String = "ATACK"
const ANIMATION_WALK_NAME : String = "WALK"

const ANIMATION_JUMP_START_NAME : String = "JUMP_START"
const ANIMATION_JUMP_NAME : String = "JUMP"
const ANIMATION_JUMP_END_NAME : String = "JUMP_END"

var is_jumping : bool = false
var is_attacking: bool = false

func animation_IDLE():
	is_jumping = false
	is_attacking = false
	animation_player.play(ANIMATION_IDLE_NAME)
	
func animation_ATACK():
	is_attacking = true
	animation_player.play(ANIMATION_ATACK_NAME)
	
func animation_WALK() -> void: 
	animation_player.play(ANIMATION_WALK_NAME)
	
func animation_JUMP_START() -> void: 
	is_jumping = true
	animation_player.play(ANIMATION_JUMP_START_NAME)
	
func animation_JUMP() -> void: 
	animation_player.play(ANIMATION_JUMP_NAME)
	
func animation_JUMP_END() -> void: 
	animation_player.play(ANIMATION_JUMP_END_NAME)
	
func sprite_direction(direction:int) -> void:
	if direction > 0:
		sprite3D.flip_h = false
	elif direction < 0:
		sprite3D.flip_h = true
#endregion

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ANIMATION_ATACK_NAME:
		animation_IDLE()
		on_attacking.emit()
	elif anim_name == ANIMATION_JUMP_START_NAME:
		animation_JUMP()
	elif anim_name == ANIMATION_JUMP_NAME:
		animation_JUMP_END()
	elif anim_name == ANIMATION_JUMP_END_NAME:
		animation_IDLE()
		
