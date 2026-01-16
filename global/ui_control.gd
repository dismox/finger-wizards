extends Control

var player: Player

func _ready() -> void:
	player = Game.player
	
	player.health_changed.connect(_on_health_changed)
	player.mana_changed.connect(_on_mana_changed)
	player.right_hand.hand_stat_changed.connect(_on_right_hand_stat_changed)
	player.left_hand.hand_stat_changed.connect(_on_left_hand_stat_changed)
	
	_on_right_hand_stat_changed("damage")
	_on_right_hand_stat_changed("range")
	_on_right_hand_stat_changed("speed")
	_on_right_hand_stat_changed("fire_rate")
	_on_right_hand_stat_changed("spread")
	_on_right_hand_stat_changed("multishot")
	
	_on_left_hand_stat_changed("damage")
	_on_left_hand_stat_changed("range")
	_on_left_hand_stat_changed("speed")
	_on_left_hand_stat_changed("fire_rate")
	_on_left_hand_stat_changed("spread")
	_on_left_hand_stat_changed("multishot")
	
	player.level_changed.connect(_on_level_changed)
	player.max_exp_changed.connect(_on_max_exp_changed)
	player.exp_changed.connect(_on_exp_changed)
	
	_on_level_changed(player.level)
	_on_exp_changed(player.exp)
	_on_max_exp_changed(player.max_exp)
	
	
	
func _on_health_changed(entity: Entity, value: float):
	%HealthBar.value = value
	%HealthBarLabel.text = str(roundi(player.health)) + "/" + str(roundi(player.max_health))
	
func _on_mana_changed(value: float):
	%ManaBar.value = value 
	%ManaBarLabel.text = str(roundi(player.mana)) + "/" + str(roundi(player.max_mana))


func _on_right_hand_stat_changed(stat: String):
	match stat:
		"damage":
			$RightHandStats/DamageContainer/DamageLabel.text = str(roundf(player.right_hand.damage))
		"range":
			$RightHandStats/RangeContainer/RangeLabel.text = str(roundi(player.right_hand.range))
		"speed":
			$RightHandStats/SpeedContainer/SpeedLabel.text = str(roundi(player.right_hand.speed))
		"fire_rate":
			$RightHandStats/FireRateContainer/FireRateLabel.text = str(roundf(1 / player.right_hand.fire_rate))
		"spread":
			$RightHandStats/SpreadContainer/SpreadLabel.text = str(snapped(player.right_hand.spread, 0.1))
		"multishot":
			$RightHandStats/MultishotContainer/MultishotLabel.text = "+" + str(player.right_hand.multishot)
		

func _on_left_hand_stat_changed(stat: String):
	match stat:
		"damage":
			$LeftHandStats/DamageContainer/DamageLabel.text = str(roundf(player.left_hand.damage))
		"range":
			$LeftHandStats/RangeContainer/RangeLabel.text = str(roundi(player.left_hand.range))
		"speed":
			$LeftHandStats/SpeedContainer/SpeedLabel.text = str(roundi(player.left_hand.speed))
		"fire_rate":
			$LeftHandStats/FireRateContainer/FireRateLabel.text = str(roundf(1 / player.left_hand.fire_rate))
		"spread":
			$LeftHandStats/SpreadContainer/SpreadLabel.text = str(snapped(player.left_hand.spread, 0.1))
		"multishot":
			$LeftHandStats/MultishotContainer/MultishotLabel.text = "+" + str(player.left_hand.multishot)

func _on_level_changed(value: int):
	$LeveBarContainer/LevelBarLabel.text = str(value) + " lvl"

func _on_max_exp_changed(value: int):
	$LeveBarContainer/LevelBar.max_value = value
	
func _on_exp_changed(value: int):
	$LeveBarContainer/LevelBar.value = value
