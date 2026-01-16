extends BulletPerk
class_name ExplodePerk

@export var radius: float = 50.0
@export var damage_multiplier: float = 1.0
@export var push_force: float = 120.0

func on_bullet_fade(hand, bullet: Bullet) -> void:
	radius += bullet.damage
	push_force += bullet.damage
	Game.spawn_explosion(bullet.global_position, bullet.damage, bullet.damage * 2).modulate = bullet.main_color

func on_bullet_hit(hand, bullet: Bullet, target) -> void:
	if target is Enemy:
		radius += bullet.damage
		push_force += bullet.damage
		
		Game.spawn_explosion(bullet.global_position, bullet.damage, bullet.damage * 2).modulate = bullet.main_color
	
#	for e in bullet.get_tree().get_nodes_in_group("entities"):
#		if e == target:
#			continue

#		var dist = e.global_position.distance_to(bullet.global_position)
#		if dist > radius:
#			continue

#		var falloff = 1.0 - (dist / radius)
#		e.apply_damage(bullet.damage * damage_multiplier * falloff)

#		if e is CharacterBody2D:
#			var dir = (e.global_position - bullet.global_position).normalized()
#			e.velocity += dir * push_force * falloff
