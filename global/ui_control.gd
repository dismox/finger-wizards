extends Control

func _ready() -> void:
	Game.player.health_changed.connect(_on_health_changed)
	Game.player.mana_changed.connect(_on_mana_changed)
	Game.player.right_hand.hand_stat_changed.connect(_on_right_hand_stat_changed)
	Game.player.left_hand.hand_stat_changed.connect(_on_left_hand_stat_changed)
	
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
	
	
func _on_health_changed(entity: Entity, value: float):
	%HealthBar.value = value
	%HealthBarLabel.text = str(roundi(Game.player.health)) + "/" + str(roundi(Game.player.max_health))
	
func _on_mana_changed(value: float):
	%ManaBar.value = value 
	%ManaBarLabel.text = str(roundi(Game.player.mana)) + "/" + str(roundi(Game.player.max_mana))


func _on_right_hand_stat_changed(stat: String):
	match stat:
		"damage":
			$RightHandStats/DamageContainer/DamageLabel.text = str(roundf(Game.player.right_hand.damage))
		"range":
			$RightHandStats/RangeContainer/RangeLabel.text = str(roundi(Game.player.right_hand.range))
		"speed":
			$RightHandStats/SpeedContainer/SpeedLabel.text = str(roundi(Game.player.right_hand.speed))
		"fire_rate":
			$RightHandStats/FireRateContainer/FireRateLabel.text = str(roundf(1 / Game.player.right_hand.fire_rate))
		"spread":
			$RightHandStats/SpreadContainer/SpreadLabel.text = str(snapped(Game.player.right_hand.spread, 0.1))
		"multishot":
			$RightHandStats/MultishotContainer/MultishotLabel.text = "+" + str(Game.player.right_hand.multishot)
		

func _on_left_hand_stat_changed(stat: String):
	match stat:
		"damage":
			$LeftHandStats/DamageContainer/DamageLabel.text = str(roundf(Game.player.left_hand.damage))
		"range":
			$LeftHandStats/RangeContainer/RangeLabel.text = str(roundi(Game.player.left_hand.range))
		"speed":
			$LeftHandStats/SpeedContainer/SpeedLabel.text = str(roundi(Game.player.left_hand.speed))
		"fire_rate":
			$LeftHandStats/FireRateContainer/FireRateLabel.text = str(roundf(1 / Game.player.left_hand.fire_rate))
		"spread":
			$LeftHandStats/SpreadContainer/SpreadLabel.text = str(snapped(Game.player.left_hand.spread, 0.1))
		"multishot":
			$LeftHandStats/MultishotContainer/MultishotLabel.text = "+" + str(Game.player.left_hand.multishot)
