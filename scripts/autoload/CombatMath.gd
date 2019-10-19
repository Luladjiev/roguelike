extends Node

func _ready():
	randomize()

func get_rand_range(from, to):
	#randomize()
	return rand_range(from, to)

func get_randf():
	#randomize()
	return randf()

func damage(min_damage, max_damage):
	return floor(get_rand_range(min_damage, max_damage))

func crit(chance):
	return get_randf() <= chance

func dodge(chance):
	return get_randf() <= chance