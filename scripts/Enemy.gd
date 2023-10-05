extends CharacterBody2D

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export() var direction: DIRECTION = DIRECTION.LEFT
@export() var detects_cliffs: bool = true

const FALL_SPEED = 30
var speed = 50

func set_raycast_pos():
	$RayCast2D.position.x = direction * ($CollisionShape2D.shape.get_size().x/2)

func change_direction():
	direction *= -1
	velocity.x = speed * direction
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h
	set_raycast_pos()

func _ready():
	if direction == DIRECTION.RIGHT:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("walk")
	$RayCast2D.enabled = detects_cliffs
	set_raycast_pos()
	
	if not detects_cliffs:
		set_modulate(Color(1, 1, 0))

func _physics_process(delta):
	if is_on_wall() or not $RayCast2D.is_colliding() and detects_cliffs and is_on_floor():
		change_direction()
		
	move_and_slide()
	velocity.y += FALL_SPEED
	velocity.x = speed * direction

func _on_fall_zone_body_entered(body):
	if body == self:
		queue_free()

func _on_top_checker_body_entered(body):
	# Stop and set to squashed
	$AnimatedSprite2D.play("squash")
	$SoundSquashed.play()
	speed = 0
	
	# Bounce the player
	body.bounce()
	
	# Disable collision
	set_collision_layer_value(5, false)
	set_collision_mask_value(2, false)
	$top_checker.set_collision_layer_value(5, false)
	$top_checker.set_collision_mask_value(2, false)
	$sides_checker.set_collision_layer_value(5, false)
	$sides_checker.set_collision_mask_value(2, false)

	# Start the countdown to deletion
	$Timer.start()

func _on_sides_checker_body_entered(body):
	if body.get_collision_layer_value(2):
		if body.position.x < position.x:
			body.ouch(DIRECTION.LEFT)
		elif body.position.x > position.x:
			body.ouch(DIRECTION.RIGHT)
	
	elif body.get_collision_layer_value(6):
		body.queue_free()
		queue_free()

func _on_timer_timeout():
	queue_free()
