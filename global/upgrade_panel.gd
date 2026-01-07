extends Control

var upgrade: Upgrade
@export var hand: String


func _ready() -> void:
	get_upgrade()


func get_upgrade():
	upgrade = Game.player.all_upgrades.pick_random()
	%TitleLabel.text = upgrade.title
	%DescriptionLabel.text = upgrade.description
	

func _on_button_pressed() -> void:
	if hand == "right":
		Game.player.right_hand.add_upgrade(upgrade)
	else:
		Game.player.left_hand.add_upgrade(upgrade)
	get_parent().queue_free()


func _on_panel_mouse_entered() -> void:
	$AnimationPlayer.play("mouse_entered")

func _on_panel_mouse_exited() -> void:
	$AnimationPlayer.play("mouse_exited")
