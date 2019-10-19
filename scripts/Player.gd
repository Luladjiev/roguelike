extends Node2D

enum ACTIONS {
	NONE, MOVE, ATTACK
}

const inputs = {
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

export var max_health = 10
export var dodge_chance = 0.2
export var crit_chance = 0.2
export var crit_multiplier = 1.5
export var min_damage = 1
export var max_damage = 5

var health = 0

onready var TILE_SIZE = $TileMap.cell_size
onready var ray_cast = $RayCast2D

func _ready():
#	Snap node to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE)

	health = max_health

	print("%s's health: %s" % [name, health])


func _unhandled_input(event):
	for direction in inputs.keys():
		if event.is_action_pressed(direction):
			do_action(direction)


func do_action(index):
	var direction = inputs[index]

	var tile = get_tile_action(direction)

	match tile.action:
		ACTIONS.MOVE:
			position += direction * TILE_SIZE
		ACTIONS.ATTACK:
			print("================")
			attack(tile.enemy)


func get_tile_action(direction):
	ray_cast.cast_to = direction * TILE_SIZE
	ray_cast.force_raycast_update()

	if !ray_cast.is_colliding():
		return { "action": ACTIONS.MOVE }

	var collider = ray_cast.get_collider()

#	If there is no owner that means that we hit an obstacle
	if !collider.owner:
		return { "action": ACTIONS.NONE }

	var owner = collider.owner

	if owner.is_in_group(Groups.ENEMY):
		return { "action": ACTIONS.ATTACK, "enemy": owner }


func hit(actor, damage_taken):
	var did_dodge = CombatMath.dodge(dodge_chance)

	if did_dodge == false:
		health -= damage_taken
	else:
		print("%s dodged!" % name)

	if health <= 0:
		queue_free()
		print("%s died" % name)


func attack(actor):
	var damage = CombatMath.damage(min_damage, max_damage)

	if CombatMath.crit(crit_chance):
		damage *= crit_multiplier
		print("%s will critical hit %s for %s damage" % [name, actor.name, damage])
	else:
		print("%s will hit %s for %s damage" % [name, actor.name, damage])

	actor.hit(self, damage)