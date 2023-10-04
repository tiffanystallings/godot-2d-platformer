extends Area2D

signal coin_collected

func _on_body_entered(body):
	$AnimationPlayer.play("bounce")
	$SoundCollect.play()
	set_collision_mask_value(2, false)
	coin_collected.emit()

func _on_animation_player_animation_finished(anim_name):
	queue_free()
