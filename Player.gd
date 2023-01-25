extends KinematicBody2D

const accel = 500
const max_speed = 80
const friction = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func _ready():
	animationtree.active = true

func _physics_process(delta):
	move_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationtree.set("parameters/Idle/blend_position", input_vector)
		animationtree.set("parameters/Run/blend_position", input_vector)
		animationstate.travel("Run")
		velocity = velocity.move_toward(input_vector * max_speed, accel * delta)
	else:
		animationstate.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction*delta)
	
	velocity = move_and_slide(velocity)
