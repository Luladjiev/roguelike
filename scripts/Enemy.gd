extends Node2D

export var max_health = 0
export var dodge_chance = 0.2
export var crit_chance = 0.2
export var crit_multiplier = 2
export var min_damage = 1
export var max_damage = 5

var health = 0

onready var TILE_SIZE = $TileMap.cell_size

func _ready():
	add_to_group(Groups.ENEMY)

#	Snap node to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE)

	health = max_health


func hit(actor, damage_taken):
	var did_dodge = CombatMath.dodge(dodge_chance)

	if did_dodge == false:
		health -= damage_taken
	else:
		print("%s dodged!" % name)

	if health <= 0:
		queue_free()
		print("%s died" % name)
		return

	attack(actor)

func attack(actor):
	var damage = CombatMath.damage(min_damage, max_damage)

	if CombatMath.crit(crit_chance):
		damage *= crit_multiplier
		print("%s will critical hit %s for %s damage" % [name, actor.name, damage])
	else:
		print("%s will hit %s for %s damage" % [name, actor.name, damage])

	actor.hit(self, damage)