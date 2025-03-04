extends Resource
class_name base_stats

var HP:int
var Strenght:int
var Vitality:int
var Agility:int
var Defense:int

func _init() -> void:
	HP = 100
	Strenght = 7
	Vitality = 7
	Agility = 7
	Defense = 7

func set_base_stats(target) -> void:
	target.HP = HP
	target.Strenght = Strenght
	target.Vitality = Vitality
	target.Agility = Agility
	target.Defense = Defense
	
func stat_growth(target) -> void:
	target.HP += 20
	target.Strenght += 4
	target.Vitality += 4
	target.Agility += 4
	target.Defense += 4
