extends TrajectoryModifier
class_name TrajectoryZigZag

@export var amplitude: float = 1.8
@export var switch_rate: float = 0.4

func process(delta: float, bullet: Bullet) -> Vector2:
	var phase = int(bullet.life_time / switch_rate) % 2
	var dir
	if phase == 0:
		dir = 1
	else:
		dir = -1
		
	var offset = Vector2(0, amplitude * dir)
	return offset.rotated(bullet.rotation)
