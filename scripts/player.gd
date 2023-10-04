extends CharacterBody2D

const MOV_SPEED = 400
const FALL_SPEED = 30
const JUMP_FORCE = -1000

func _physics_process(_delta):
	if (Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left")):
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		$Sprite2D.play("idle")
		
	elif (Input.is_action_pressed("ui_right")):
		$Sprite2D.set_flip_h(false)
		$Sprite2D.play("walk")
		velocity.x = MOV_SPEED
		
	elif (Input.is_action_pressed("ui_left")):
		$Sprite2D.set_flip_h(true)
		$Sprite2D.play("walk")
		velocity.x = -MOV_SPEED
	
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		$Sprite2D.play("idle")
	
	if not is_on_floor():
		$Sprite2D.play("air")
	
	if (Input.is_action_just_pressed("ui_up") and is_on_floor()):
		$SoundJump.play()
		velocity.y = JUMP_FORCE
	
	velocity.y += FALL_SPEED
	
	move_and_slide()

func _on_fall_zone_body_entered(body):
	if body == self:
		get_tree().change_scene_to_file("res://game_over.tscn")

func bounce(direction: int = 0):
	velocity.y = JUMP_FORCE * 0.5
	velocity.x = MOV_SPEED * direction * 3

func ouch(direction: int):
	$Timer.start()
	$AnimationPlayer.play("flash")
	$SoundOuch.play()
	bounce(direction)
	Input.action_release("ui_left")
	Input.action_release("ui_right")

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://game_over.tscn")
