extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var timer = $Timer

var stats : Resource
var actions : Resource

signal on_enemy_beaten
signal on_attacking(index:int)
signal on_attack_on_enemy_timer_timeout(index: int)

@export var current_exp:int = 500

var given_exp :int = 25
var current_hp:int = 100
var enemy_index:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = base_stats.new();
	stats.get_exp(current_exp);
	given_exp = given_exp * stats.level
	current_hp = stats.HP
	actions = agent_actions.new();
	actions.animation_IDLE(self)

func reduce_hp(quantity: int) -> void:
	current_hp -= quantity;
	if(current_hp <= 0):
		on_enemy_beaten.emit(enemy_index)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == actions.ANIMATION_ATACK_NAME:
		actions.animation_IDLE(self)
		on_attacking.emit(enemy_index)

func _on_timer_timeout() -> void:
	on_attack_on_enemy_timer_timeout.emit(enemy_index)
