extends Node

var player: Player
var bullets_layer: CanvasLayer
var entities_layer: CanvasLayer
var ui_layer: CanvasLayer


enum Puddle_type {
	SNOW,
	RED,
	BLUE,
	GREEN,
	RAINBOW,
	BLACK,
}

enum Bullet_type {
	MANA,
	FIRE,
	ICE
}


func spawn_bullet(
	scene: PackedScene,
	position: Vector2,
	rotation: float,
	source: Entity,
	damage: float,
	speed: float,
	range: float,
	trajectory_modifiers: Array[TrajectoryModifier] = []
) -> Bullet:
	var bullet: Bullet = scene.instantiate()
	bullet.global_position = position
	bullet.rotation = rotation
	bullet.trajectory_modifiers = trajectory_modifiers.duplicate()

	bullets_layer.add_child(bullet)
	bullet.init(source, damage, speed, range)
	bullet.particle.emitting = true

	return bullet


func spawn_radial_bullets(
	scene: PackedScene,
	center: Vector2,
	count: int,
	source: Entity,
	damage: float,
	speed: float,
	range: float,
	start_angle := 0.0,
	trajectory_modifiers: Array[TrajectoryModifier] = []
) -> Array[Bullet]:
	var bullets: Array[Bullet] = []
	var step := TAU / count

	for i in count:
		var angle := start_angle + step * i
		var bullet := spawn_bullet(
			scene,
			center,
			angle,
			source,
			damage,
			speed,
			range,
			trajectory_modifiers
		)
		bullets.append(bullet)

	return bullets



func spawn_paddle(position: Vector2, type: Puddle_type, size: Vector2) -> void:
	var puddle_scene = load("res://objects/puddle.tscn")
	var puddle: Puddle = puddle_scene.instantiate()
	puddle.global_position = position
	
	var random_scale = randf_range(size.x, size.y)
	puddle.scale = Vector2(random_scale, random_scale)
	
	get_tree().current_scene.add_child(puddle)
	puddle.initiate(type)
	
	
func spawn_entity(scene: PackedScene, position: Vector2 = Vector2.ZERO) -> Entity:
	var entity = scene.instantiate()
	entity.position = position
	entities_layer.add_child(entity)
	entity.add_to_group("entities")
	return entity

	
func spawn_snow(position: Vector2) -> void:
	var snow = Sprite2D.new()
	snow.texture = load("res://assets/puddle.png")
	snow.position = position
	var random_skale = randf()
	snow.scale = Vector2(random_skale, random_skale)
	get_tree().current_scene.add_child(snow)

func flash_effect(object: Node, color: Color) -> void:
	object.modulate = color
	await get_tree().create_timer(0.1).timeout
	if object:
		object.modulate = Color.WHITE

func _flash_effect(object: Node, color: Color) -> void:
	#color = color * 4.0
	var tween = create_tween()
	tween.tween_property(object, "modulate", color, 0.1)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()
	await tween.finished
	#object.modulate = Color.WHITE
	if object:
		await get_tree().create_timer(0.1).timeout
		tween = create_tween()
		tween.tween_property(object, "modulate", Color.WHITE, 0.1)
		tween.set_trans(Tween.TRANS_ELASTIC)
		tween.play()
		await tween.finished
	return
	
	
func _apply_gravity(center: Vector2, radius: float, strength: float, delta := 1.0) -> void:
	for e in get_tree().get_nodes_in_group("entities"):
		if not e is Entity:
			continue

		var dir = center - e.global_position
		var dist = dir.length()
		if dist > radius or dist <= 0.001:
			continue

		var falloff = 1.0 - (dist / radius)
		var force = dir.normalized() * strength * falloff * delta
		e.target_velocity += force
