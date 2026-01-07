extends Resource
class_name Upgrade

@export_group("Meta")
@export var title: String
@export_multiline var description: String

@export_group("Perks & Trajectory")
@export var perks: Array[BulletPerk] = []
@export var trajectory_modifiers: Array[TrajectoryModifier] = []

@export_group("Stat modifiers (percent)")
@export var damage_pct: float = 0.0       # +20 = +20%
@export var speed_pct: float = 0.0
@export var range_pct: float = 0.0
@export var fire_rate_pct: float = 0.0    # ВАЖНО: fire_rate — время, см. ниже
@export var spread_pct: float = 0.0
@export var multishot: int = 0

@export var aspect_change: PackedScene = null

func apply(hand: Hand) -> void:
	# --- Статы ---
	hand.damage *= 1.0 + damage_pct / 100.0
	#hand.damage += 5.0
	
	hand.speed *= 1.0 + speed_pct / 100.0
	#hand.speed += 10.0
	
	hand.range *= 1.0 + range_pct / 100.0
	#hand.range += 10.0

	# fire_rate — это задержка, поэтому знак ИНВЕРТИРОВАН
	hand.fire_rate *= 1.0 - fire_rate_pct / 100.0
	#hand.fire_rate += 0.05

	hand.spread *= 1.0 + spread_pct / 100.0
	
	hand.multishot += multishot
	
	#hand.multishot = int(round(
	#	hand.multishot * (1.0 + multishot_pct / 100.0)
	#))

	# --- Перки ---
	for perk in perks:
		hand.perks.append(perk)

	# --- Траектории ---
	for modifier in trajectory_modifiers:
		hand.trajectory_modifiers.append(modifier)
		
	if aspect_change != null:
		hand.bullet_scene = aspect_change


func remove(hand: Hand) -> void:
	hand.damage /= 1.0 + damage_pct / 100.0
	#hand.damage -= 5.0
	
	hand.speed /= 1.0 + speed_pct / 100.0
	#hand.speed -= 10.0
	
	hand.range /= 1.0 + range_pct / 100.0
	#hand.range -= 10.0

	hand.fire_rate /= 1.0 - fire_rate_pct / 100.0
	#hand.fire_rate -= 0.05

	hand.spread /= 1.0 + spread_pct / 100.0
	
	hand.multishot -= multishot
	
	#hand.multishot = int(round(
	#	hand.multishot / (1.0 + multishot_pct / 100.0)
	#))

	for perk in perks:
		hand.perks.erase(perk)

	for modifier in trajectory_modifiers:
		hand.trajectory_modifiers.erase(modifier)
