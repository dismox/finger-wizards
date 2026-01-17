extends Node2D

class_name Puddle

@onready var particles: CPUParticles2D = $Particles

var type: Game.Puddle_type
var damage

func initiate(_type: Game.Puddle_type, min_scale: float = 0.5) -> void:
	type = _type
	var random_color = 0.4 + randf()/2
	match type:
		Game.Puddle_type.BLACK:
			modulate = Color(0.0, 0.0, 0.0, 0.3)
		Game.Puddle_type.GREEN:
			modulate = Color(0.0, 0.094, 0.043, 1.0)
		Game.Puddle_type.BLUE:
			modulate = Color(0.009, 0.127, 0.232, 1.0)
		Game.Puddle_type.RED:
			modulate = Color(0.339, 0.013, 0.074, 1.0)
		Game.Puddle_type.RAINBOW:
			modulate = Color(randf(), randf(), randf(), 1.0)
	particles.color = modulate


func _on_puddle_area_area_entered(area: Area2D) -> void:
	particles.emitting = true
	if area.get_parent() is Bullet:
		var bullet: Bullet = area.get_parent()
		if bullet.bullet_type == Game.Bullet_type.FIRE and type == Game.Puddle_type.SNOW:
			queue_free()
