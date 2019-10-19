extends Node2D

enum TILE_INFO {
	FREE, ENEMY, PLAYER, OBSTACLE
}

export var max_health = 10
export var dodge_chance = 0.2
export var crit_chance = 0.2
export var crit_multiplier = 1.5
export var min_damage = 1
export var max_damage = 5

var health = 0
var dead = false

onready var TILE_SIZE = $TileMap.cell_size
onready var ray_cast = $RayCast2D

func _ready():
#	Snap node to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE / 2)

	health = max_health

	print("%s's health: %s" % [name, health])


func move(direction):
	position += direction * TILE_SIZE


func hit(_actor, damage_taken):
	var did_dodge = CombatMath.dodge(dodge_chance)

	if did_dodge == false:
		health -= damage_taken
	else:
		print("%s dodged!" % name)

	if health <= 0:
		die()


func attack(actor):
	var damage = CombatMath.damage(min_damage, max_damage)

	if CombatMath.crit(crit_chance):
		damage *= crit_multiplier
		print("%s will critical hit %s for %s damage" % [name, actor.name, damage])
	else:
		print("%s will hit %s for %s damage" % [name, actor.name, damage])

	actor.hit(self, damage)


func die():
	dead = true
	queue_free()
	print("%s died" % name)


func get_next_tile_info(direction):
	ray_cast.cast_to = direction * TILE_SIZE
	ray_cast.force_raycast_update()

	if !ray_cast.is_colliding():
		return { "info": TILE_INFO.FREE }

	var collider = ray_cast.get_collider()

#	If there is no owner that means that we hit an obstacle
	if !collider.owner:
		return { "info": TILE_INFO.OBSTACLE }

	var owner = collider.owner

	if owner.is_in_group(Groups.ENEMY):
		return { "info": TILE_INFO.ENEMY, "enemy": owner }

	if owner.is_in_group(Groups.PLAYER):
		return { "info": TILE_INFO.PLAYER, "player": owner }