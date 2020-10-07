extends KinematicBody2D

enum {IDLE, WANDER, CHASE}

onready var player = get_parent().get_node("Player")
onready var playerDetectionZone = $PlayerDetectionZone
onready var wanderController = $WanderController
onready var sprite = $Sprite
onready var hurtbox = $HurtBox
onready var stats = $Stats

export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500
export var WANDER_TARGET_VARIABLE = 4 

var velocity = Vector2.ZERO

var state = IDLE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match state:
		IDLE:
			seek_target()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_target()
			if wanderController.get_time_left() == 0:
				update_wander()
			acceleration_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_VARIABLE:
				update_wander()
		CHASE:
			var player = playerDetectionZone.target
			if player != null:
				acceleration_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	velocity = move_and_slide(velocity)

func seek_target():
	if playerDetectionZone.can_see_target():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))


func acceleration_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0




func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)


func _on_Stats_no_health():
	Global.chlorophyl += 1
	queue_free()
