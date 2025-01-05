extends CharacterBody2D

@export var SPEED: float = 150.0

@onready var cam = $MainCamera

var curr_dir: Direction = Direction.DOWN
var is_flipped: bool = false

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT
}

func flip():
	%Sprite.flip_h = !is_flipped
	is_flipped = !is_flipped

func change_direction(nextdir):
	if nextdir == curr_dir:
		return
	if nextdir == Direction.UP:
		if !is_flipped:
			flip()
		%Sprite.animation = "back"
	if nextdir == Direction.DOWN:
		if is_flipped:
			flip()
		%Sprite.animation = "front"
	if nextdir == Direction.RIGHT:
		if is_flipped:
			flip()
		%Sprite.animation = "side"
	if nextdir == Direction.LEFT:
		if !is_flipped:
			flip()
		%Sprite.animation = "side"
	curr_dir = nextdir

func _ready() -> void:
	cam.enabled = is_multiplayer_authority()

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	var velocity: Vector2 = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("MoveRight"):
		change_direction(Direction.RIGHT)
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		change_direction(Direction.LEFT)
		velocity.x -= 1
	if Input.is_action_pressed("MoveUp"):
		change_direction(Direction.UP)
		velocity.y -= 1
	if Input.is_action_pressed("MoveDown"):
		change_direction(Direction.DOWN)
		velocity.y += 1
	
	if velocity.length() > 0.0:
		velocity = velocity.normalized()
	
	position += velocity * SPEED * delta
	move_and_slide()
