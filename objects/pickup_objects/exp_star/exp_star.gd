extends PickupObject
class_name ExpStar

@export var exp_amount: int = 1

func _ready() -> void:
	super._ready()
	#max_pickup_distance = 100
	rotation += randf() * 10
	scale = scale * exp_amount / (4.0 - randf())

func apply_to_player(player: Node) -> void:
	Game.player.exp += exp_amount
