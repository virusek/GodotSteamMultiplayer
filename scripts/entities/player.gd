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

func rotatePlayer():
	var mouse_pos = get_viewport().get_mouse_position()
	var view_size = get_viewport().size
	var center = Vector2(view_size.x / 2, view_size.y / 2)
	var relative = mouse_pos - center
	var rad_to_deg = 57.2957795131
	var angle = Vector2.RIGHT.angle_to_point(relative)
	
	var degrees = angle * rad_to_deg
	
	if -150 < degrees and degrees < -30:
		change_direction(Direction.UP)
	elif -30 < degrees and degrees < 30:
		change_direction(Direction.RIGHT)
	elif 30 < degrees and degrees < 150:
		change_direction(Direction.DOWN)
	else:
		change_direction(Direction.LEFT)

func _ready() -> void:
	cam.enabled = is_multiplayer_authority()
	print(get_parent())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	
	var velocity: Vector2 = Vector2(0.0, 0.0)
	
	if Input.is_action_pressed("MoveUp"):
		velocity.y -= 1
	if Input.is_action_pressed("MoveDown"):
		velocity.y += 1
	if Input.is_action_pressed("MoveRight"):
		velocity.x += 1
	if Input.is_action_pressed("MoveLeft"):
		velocity.x -= 1
		
	rotatePlayer()
	
	if velocity.length() > 0.0:
		velocity = velocity.normalized()
	
	position += velocity * SPEED * delta
	move_and_slide()
