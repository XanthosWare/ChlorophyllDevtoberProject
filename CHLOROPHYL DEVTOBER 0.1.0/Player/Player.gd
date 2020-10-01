extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE 
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

export var MAX_SPEED = 100
export var ROLL_SPEED = 150
export var ACCELERATION = 500
export var FRICTION = 500

#onready var animation_player = $AnimationPlayer
#onready var animation_tree = $AnimationTree
#onready var animation_state = animation_tree.get("parameters/playback")
#onready var sword_hitbox = $HitBoxPivot/SwordHitbox
#onready var hurtbox = $HurtBox
#onready var blinkAnimationPlayer = $BlinkAnimationPlayer
#onready var fistHurtBox = $FistHurtBox
#onready var fistHurtBoxCollision = $FistHurtBox/CollisionShape2D

func _ready():
	pass

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			pass

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") -  Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") -  Input.get_action_strength("ui_up") 
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	move()
	if Input.is_action_just_pressed("roll"):
		state = ROLL

func move():
	velocity = move_and_slide(velocity)
