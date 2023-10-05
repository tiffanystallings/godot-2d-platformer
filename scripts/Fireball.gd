extends CharacterBody2D

enum Direction {LEFT=-1, RIGHT=1}
const SPEED: int = 800

var direction: Direction = Direction.RIGHT

func _ready():
	velocity.x = SPEED * direction

func _physics_process(_delta):
	if move_and_slide():
		velocity = Vector2(0,0)
	
	if is_on_wall():
		queue_free()

func set_direction(d: Direction):
	print(d)
	direction = d
	print(direction)
