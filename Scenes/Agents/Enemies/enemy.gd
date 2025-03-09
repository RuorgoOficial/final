extends Node3D

@onready var animation_player = $AnimationPlayer

var stats : Resource
var actions : Resource

signal on_enemy_beaten
signal on_attacking

@export var current_exp:int = 500

var given_exp :int = 25
var current_hp:int = 100

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
		on_enemy_beaten.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == actions.ANIMATION_ATACK_NAME:
		actions.animation_IDLE(self)
		on_attacking.emit()
