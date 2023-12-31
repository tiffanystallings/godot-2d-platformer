extends CharacterBody2D

enum State {AIR, FLOOR, LADDER, WALL}

const MOV_SPEED: int = 300
const RUN_SPEED: int = 500
const FALL_SPEED: int = 30
const JUMP_FORCE: int = -800
const FIREBALL: PackedScene = preload("res://assets/fireball.tscn")
const FIREBALL_OFFSET_X = 25
const FIREBALL_OFFSET_Y = 25

var state: State = State.AIR
var direction: int
var sprinting: bool
var jumping: bool
var firing: bool

func _physics_process(delta):
	direction = Input.get_axis("ui_left", "ui_right")
	sprinting = Input.is_action_pressed("sprint")
	jumping = Input.is_action_just_pressed("ui_up")
	firing = Input.is_action_just_pressed("fire")
	
	match(state):
		State.AIR:
			if is_on_floor():
				state = State.FLOOR
			else:
				$Sprite2D.play("air")
				if direction:
					handle_move_x(delta)
				else:
					handle_stop_x(delta)
				
				if firing:
					fire()
		
		State.FLOOR:
			if not is_on_floor():
				state = State.AIR
			else:
				if direction:
					var speed = RUN_SPEED if sprinting else MOV_SPEED
					$Sprite2D.play("walk", float(speed)/float(MOV_SPEED))
					handle_move_x(delta, speed)
				else:
					$Sprite2D.play("idle")
					handle_stop_x(delta)
				
				if jumping:
					state = State.AIR
					handle_jump()
				
				if firing:
					fire()
					
		State.LADDER:
			pass
		
		State.WALL:
			pass
	
	move_and_fall(delta)

func _on_fall_zone_body_entered(body):
	if body == self:
		get_tree().change_scene_to_file("res://game_over.tscn")
		
func get_direction():
	return -1 if $Sprite2D.is_flipped_h() else 1

func fire():
	var fireball = FIREBALL.instantiate()
	fireball.set_direction(get_direction())
	fireball.position.y = position.y + FIREBALL_OFFSET_Y
	fireball.position.x = position.x + (get_direction() * FIREBALL_OFFSET_X)
	get_parent().add_child(fireball)
		
func move_and_fall(delta):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	velocity.y += gravity * delta
	move_and_slide()

func handle_jump(force = JUMP_FORCE):
	$SoundJump.play()
	velocity.y = force

func handle_move_x(delta, speed = MOV_SPEED):
	var step = 0.1 if velocity.x < speed else 0.03
	if direction == -1:
		$Sprite2D.set_flip_h(true)
	elif direction == 1:
		$Sprite2D.set_flip_h(false)
	velocity.x = lerp(velocity.x, float(speed * direction), step)

func handle_stop_x(delta):
	velocity.x = lerp(velocity.x, 0.0, 0.1)

func bounce(bounce_direction: int = 0):
	velocity.y = JUMP_FORCE * 0.5
	velocity.x = MOV_SPEED * bounce_direction * 3

func ouch(bounce_direction: int):
	$Timer.start()
	$AnimationPlayer.play("flash")
	$SoundOuch.play()
	bounce(bounce_direction)
	Input.action_release("ui_left")
	Input.action_release("ui_right")

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://game_over.tscn")
