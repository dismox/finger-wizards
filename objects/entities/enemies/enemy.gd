extends Entity
class_name Enemy

@export var agro_range: float = 300.0
@export var bullet_scene: PackedScene

func _process_ai(delta: float) -> void:
	if Game.player == null:
		target_velocity = Vector2.ZERO
		return

	var to_player = Game.player.global_position - global_position
	var dist = to_player.length()

	if dist <= agro_range:
		# Преследуем игрока
		target_velocity = to_player.normalized()
	else:
		# Стоим
		target_velocity = Vector2.ZERO


#func _on_hitbox_area_area_entered(area: Area2D) -> void:
#	var bullet = area.get_parent()
#	if bullet is Bullet and bullet.source is Player:
#		return
#		apply_damage(bullet.damage)
