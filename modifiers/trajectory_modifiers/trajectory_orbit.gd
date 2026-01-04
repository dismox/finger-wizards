extends TrajectoryModifier
class_name TrajectoryOrbitPlayer

#@export var player: Player
@export var radius: float = 50.0
@export var angular_speed: float = 0.5  # обороты в секунду

func process(delta: float, bullet: Bullet) -> Vector2:
	if Game.player == null:
		return Vector2.ZERO
	
	var t = bullet.life_time * TAU * angular_speed
	var offset = Vector2(
		cos(t) * radius,
		sin(t) * radius
	)
	# Сместим пулю к "орбитальной точке"
	var desired_pos = Game.player.global_position + offset
	return (desired_pos - bullet.global_position)
