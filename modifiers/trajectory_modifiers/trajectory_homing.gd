extends TrajectoryModifier
class_name TrajectoryHoming

@export var turn_speed: float = 10.0        # скорость доворота
@export var acquire_radius: float = 50.0  # радиус захвата цели
@export var lose_distance: float = 100.0   # дистанция потери цели
@export var target_group: String = "entities"

var target: Entity = null

func process(delta: float, bullet: Bullet) -> Vector2:
	if target == null or not is_instance_valid(target):
		target = _find_target(bullet)

	if target == null:
		return Vector2.ZERO

	var dist := bullet.global_position.distance_to(target.global_position)
	if dist > lose_distance:
		target = null
		return Vector2.ZERO

	var desired_angle := (target.global_position - bullet.global_position).angle()
	bullet.rotation = lerp_angle(
		bullet.rotation,
		desired_angle,
		turn_speed * delta
	)

	return Vector2.ZERO

func _find_target(bullet: Bullet) -> Entity:
	var best: Entity = null
	var best_dist := acquire_radius
	
	if bullet.source == null or bullet.source is Enemy:
		best = Game.player
		return best

	for e in bullet.get_tree().get_nodes_in_group(target_group):
		if not e is Entity:
			continue
		if e == bullet.source:
			continue

		var d := bullet.global_position.distance_to(e.global_position)
		if d < best_dist:
			best_dist = d
			best = e

	return best
