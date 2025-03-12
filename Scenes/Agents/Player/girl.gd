extends CharacterBody3D

@export var is_fighting_scene:bool = false

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

@onready var animation_player = $AnimationPlayer;
@onready var sprite3D = $Sprite3D;

var stats : Resource
var actions : Resource

var current_hp: int
var enemy_index: int = 0

signal on_player_is_moving()
signal on_attacking(index:int)

func _ready() -> void:
	stats = player_stats.new();
	stats.get_exp(PlayerManager.total_experience);
	current_hp = stats.HP
	actions = agent_actions.new();
	actions.animation_IDLE(self)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		actions.animation_JUMP_START(self)
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not is_fighting_scene:
		if Input.is_key_pressed(KEY_C):
			actions.animation_ATACK(self)
			
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			actions.sprite_direction(self, direction.x)
			if not actions.is_jumping and not actions.is_attacking:
				on_player_is_moving.emit()
				actions.animation_WALK(self)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			if not actions.is_jumping and not actions.is_attacking:
				actions.animation_IDLE(self)

		move_and_slide()
		
func reduce_hp(quantity: int) -> void:
	current_hp -= quantity;
	
func set_exp(exp: int) -> void:
	PlayerManager.total_experience += exp;
	stats.get_exp(exp);
		
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == actions.ANIMATION_ATACK_NAME:
		actions.animation_IDLE(self)
		on_attacking.emit(enemy_index)
	elif anim_name == actions.ANIMATION_JUMP_START_NAME:
		actions.animation_JUMP(self)
	elif anim_name == actions.ANIMATION_JUMP_NAME:
		actions.animation_JUMP_END(self)
	elif anim_name == actions.ANIMATION_JUMP_END_NAME:
		actions.animation_IDLE(self)
