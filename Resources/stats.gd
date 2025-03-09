extends Resource
class_name base_stats

var HP:int
var Strenght:int
var Vitality:int
var Agility:int
var Defense:int

var level:int = 1
var level_exp:int = 0
var total_exp:int = 100

func _init() -> void:
	HP = 100
	Strenght = 7
	Vitality = 7
	Agility = 7
	Defense = 7

func get_exp(received_exp:int)->void:
	if level < 99:
		level_exp += received_exp;
		total_exp += received_exp;
		while (level_exp >= (100 * (level / 2) * level)):
			level_exp = level_exp - (100 * (level / 2) * level);
			level += 1;
			grown_level()
			if (level == 99):
				total_exp -= level_exp;
				level_exp = 0;
			#print("current level: " + str(level))
			#print("exp level: " + str(level_exp))
			#print("new level required exp: " + str(100 * (level / 2) * level))
				
func grown_level() -> void:
	HP = 100 * level
	Strenght = 7 * level
	Vitality = 7 * level
	Agility = 7 * level
	Defense = 7 * level
