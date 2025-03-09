extends Node

var attackingPool = Array([], TYPE_OBJECT, "Node", null)
var current_attacker: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_attacker == null and attackingPool.any(func(element): return true):
		current_attacker = attackingPool[0]
		current_attacker.actions.attack(current_attacker)

func remove_attacker() -> void:
	if attackingPool.any(func(element): return true):
		attackingPool.remove_at(0)
	current_attacker = null
	
func add_attacker(attacker: Node) -> void:
	attackingPool.append(attacker)
	
func get_damage(attacker: Node, defender: Node) -> int:
	return 10 * (attacker.stats.Strenght / defender.stats.Defense) + (10 * attacker.stats.level)
