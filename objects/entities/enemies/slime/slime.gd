extends Enemy
class_name SlimeEnemy

@export var dash_speed := 350.0
@export var dash_duration := 0.25
var dash_timer := 0.0
var dash_dir := Vector2.ZERO

@export var bounce_force: float = 350.0

var size: int = 3:
	set(value):
		if value < 1:
			size = 1
		else:
			size = value
		update_size()

func _ready() -> void:
	update_size()

func update_size() -> void:
	scale = Vector2(size / 2.0, size / 2.0)

	bullet_speed = 300.0 / size
	bullet_damage = 10.0 * size
	attack_cooldown = size
	bullet_range = 100.0 * size
	contact_damage = size
	max_health = 20 * size
	health = max_health



func attack(dir: Vector2) -> void:
	#Game.flash_effect(self, Color(4.877, 12.413, 0.0, 1.0))
	radial_shoot(dir, 5)
	await get_tree().create_timer(0.25).timeout
	one_shot_particles($Particles)
	dash_dir = dir
	dash_timer = dash_duration
	velocity = dash_dir * dash_speed
	#shoot(dir)

	

func _process_ai(delta: float) -> void:
	super._process_ai(delta)

	if dash_timer > 0:
		dash_timer -= delta
		target_velocity = dash_dir


func apply_damage(amount: float) -> void:
	Game.spawn_paddle(global_position, Game.Puddle_type.GREEN, Vector2(0.5, scale.x))
	one_shot_particles($Particles, int(amount / 10))
	super.apply_damage(amount)
	

func _die() -> void:
	if size > 1:
		for i in range (size):
			var slime_scene: PackedScene = load("res://objects/entities/enemies/slime/slime.tscn")
			var new_slime = Game.spawn_entity(slime_scene.duplicate(), global_position + Vector2(10 * i, 10 * i))
			new_slime.size = size - 1
	super._die()



func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_process_slime_collisions()

func _process_slime_collisions() -> void:
	if state != State.ATTACK:
		return

	for i in range(get_slide_collision_count()):
		var col := get_slide_collision(i)
		var collider := col.get_collider()

		# Отскакиваем от всего твёрдого
		if collider is TileMap or collider is Entity:
			_bounce(col.get_normal())

func _bounce(normal: Vector2) -> void:
	velocity = normal.normalized() * bounce_force

	# ВАЖНО: корректно встраиваемся в FSM
	state = State.ATTACK   # или отдельное SLIDE / RECOVER
	attack_timer = attack_cooldown * 0.5

func one_shot_particles(particles: CPUParticles2D, amount: int = -1) -> void:
	var new_particles: CPUParticles2D = particles.duplicate(true)
	particles.add_child(new_particles)
	if amount > 0:
		new_particles.amount = amount
	new_particles.emitting = true
	await new_particles.finished
	new_particles.queue_free()
