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

var health = max_health

onready var TILE_SIZE = $TileMap.cell_size
onready var ray_cast = $RayCast2D

func _ready():
#	Snap player to the grid
	position = position.snapped(Vector2.ONE * TILE_SIZE)


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


func hit(actor, damage):
	print("player hit: %s damage" % damage)
	health -= damage

	if health <= 0:
		queue_free()


func attack(enemy):
	enemy.hit(self, 1)