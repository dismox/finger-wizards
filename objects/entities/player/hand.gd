extends AnimatedSprite2D

class_name Hand

@export var signal_type: String

@export var damage: float = 10.0:
	set(value):
		damage = value
		emit_signal("hand_stat_changed", "damage")
@export var speed: float = 250.0:
	set(value):
		speed = value
		emit_signal("hand_stat_changed", "speed")
@export var range: float = 200.0:
	set(value):
		range = value
		emit_signal("hand_stat_changed", "range")
@export var fire_rate: float = 0.25:
	set(value):
		fire_rate = value
		emit_signal("hand_stat_changed", "fire_rate")
@export var spread: float = 0.1:
	set(value):
		spread = value
		emit_signal("hand_stat_changed", "spread")
@export var multishot: int = 0:
	set(value):
		multishot = value
		emit_signal("hand_stat_changed", "multishot")

@export var trajectory_modifiers: Array[TrajectoryModifier] = []
@export var perks: Array[BulletPerk] = []

var upgrades: Array[Upgrade] = []

var fire_cooldown: float = 0.0

@export var player: Player
@export var bullet_point: Marker2D
@export var particle: CPUParticles2D

@export var bullet_scene: PackedScene

signal hand_stat_changed(stat: String)

func _physics_process(delta: float) -> void:
	_process_shooting()

func shoot() -> void:
	player.camera_rig.shake(0.1, damage * 2.0)
	particle.emitting = true
	
	for i in range (1 + multishot):
		var angle := (
			get_global_mouse_position() - global_position
		).angle() + (randf_range(-spread, spread) * multishot/1.5)
		
		var bullet := Game.spawn_bullet(
			bullet_scene,
			bullet_point.global_position,
			angle,
			player,
			damage,
			speed,
			range,
			trajectory_modifiers
		)
		
		#var bullet = spawn_bullet()
		
		Game.flash_effect(self, bullet.main_color)
		particle.color = bullet.main_color
		
		#await get_tree().create_timer(0.01).timeouta
		for perk in perks:
			perk.on_shoot(self, bullet)
			
		bullet.hit.connect(_on_bullet_hit)
		bullet.faded.connect(_on_bullet_fade)
		bullet.flight_tick.connect(_on_bullet_flight)


func _process_shooting() -> void:
	if fire_cooldown > 0:
		fire_cooldown -= get_process_delta_time()

	if Input.is_action_pressed(signal_type) and fire_cooldown <= 0:
		var cost = calculate_mana_cost()
		if Game.player.mana - cost > -1.0:
			fire_cooldown = fire_rate
			Game.player.mana -= calculate_mana_cost()
			shoot()


func calculate_mana_cost() -> float:
	var cost: float = 0.0
	cost += damage 
	cost -= fire_rate * 10.0
	cost *= (multishot / 1.5) + 1
	cost = clamp(cost, 0, Game.player.max_mana)
	return cost


func add_upgrade(upgrade: Upgrade) -> void:
	#if upgrades.has(upgrade):
	#	return
	upgrades.append(upgrade)
	upgrade.apply(self)

func remove_upgrade(upgrade: Upgrade) -> void:
	#if not upgrades.has(upgrade):
	#	return
	upgrades.erase(upgrade)
	upgrade.remove(self)



func _on_bullet_hit(bullet: Bullet, target):
	for perk in perks:
		perk.on_bullet_hit(self, bullet, target)

func _on_bullet_fade(bullet: Bullet):
	for perk in perks:
		perk.on_bullet_fade(self, bullet)

func _on_bullet_flight(bullet: Bullet, delta):
	for perk in perks:
		perk.on_bullet_flight(self, bullet, delta)
