extends CharacterBody2D

enum Direction {LEFT=-1, RIGHT=1}

const SPEED: int = 800
const ROT_SPEED: int = 25
const BOUNCE: int = -300

var direction: Direction = Direction.RIGHT
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.x = SPEED * direction

func _physics_process(delta):
	$Sprite2D.set_rotation($Sprite2D.get_rotation() + deg_to_rad(ROT_SPEED * direction))
	velocity.y += gravity * delta
	
	if move_and_slide():
		velocity = Vector2(0,0)
	
	if is_on_wall():
		queue_free()
	
	if is_on_floor():
		velocity.y = BOUNCE
		velocity.x = SPEED * direction

func set_direction(d: Direction):
		direction = d

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_timer_timeout():
	$SoundFireball.play()
