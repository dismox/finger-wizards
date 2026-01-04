extends BulletPerk
class_name ChainPerk

@export var chains: int = 3
@export var radius: float = 180.0

var remaining := {}
var hit_targets := {}

func on_bullet_shot(bullet: Bullet) -> void:
	remaining[bullet] = chains
	hit_targets[bullet] = []

func on_bullet_hit(hand, bullet: Bullet, target: Entity) -> void:
	if not remaining.has(bullet):
		remaining[bullet] = chains
		hit_targets[bullet] = []

	if remaining[bullet] <= 0:
		return

	hit_targets[bullet].append(target)
	remaining[bullet] -= 1

	var next := _find_next_target(bullet, target)
	if next == null:
		return

	var dir := (next.global_position - bullet.global_position).normalized()
	bullet.rotation = dir.angle()
	bullet.state = Bullet.BulletState.FLYING

func _find_next_target(bullet: Bullet, from: Entity) -> Entity:
	var best: Entity = null
	var best_dist := radius

	for e in bullet.get_tree().get_nodes_in_group("entities"):
		if e == from:
			continue
		if hit_targets[bullet].has(e):
			continue

		var d = e.global_position.distance_to(from.global_position)
		if d < best_dist:
			best_dist = d
			best = e

	return best
