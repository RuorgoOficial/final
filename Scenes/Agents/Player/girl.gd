extends CharacterBody3D

@export var is_fighting_scene:bool = false

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

@onready var animation_player = $AnimationPlayer;
@onready var sprite3D = $Sprite3D;

func _ready() -> void:
	animation_IDLE()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_fighting_scene:
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			animation_WALK()
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			animation_IDLE()

		move_and_slide()
	elif is_fighting_scene:
		if Input.is_key_pressed(KEY_W):
			animation_ATACK()
			
#region Animation Region
const ANIMATION_IDLE_NAME : String = "IDLE"
const ANIMATION_ATACK_NAME : String = "ATACK"
const ANIMATION_WALK_NAME : String = "WALK"

func animation_IDLE():
	animation_player.play(ANIMATION_IDLE_NAME)
	
func animation_ATACK():
	animation_player.play(ANIMATION_ATACK_NAME)
	
func animation_WALK():
	animation_player.play(ANIMATION_WALK_NAME)
#endregion

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ANIMATION_ATACK_NAME:
		animation_IDLE();
