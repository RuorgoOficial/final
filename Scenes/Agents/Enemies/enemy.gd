extends Node3D

@onready var animation_player = $AnimationPlayer

var stats : Resource

signal on_enemy_beaten

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("IDLE")
	stats = base_stats.new();

func reduce_hp(quantity: int) -> void:
	stats.HP -= quantity;
	if(stats.HP <= 0):
		on_enemy_beaten.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
