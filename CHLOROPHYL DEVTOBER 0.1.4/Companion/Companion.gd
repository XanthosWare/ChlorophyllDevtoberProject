extends KinematicBody2D

enum {FOLLOW, ATTACK, IDLE}

onready var player = get_parent().get_node("Player")
onready var enemyDetectionZone = $EnemyDetectionZone
onready var playerDetectionZone = $PlayerDetectionZone
onready var nameLabel = $Name
onready var softCollisions = $SoftCollision
onready var commandLabel = $Command

export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
export var MAX_DISTANCE_FROM_PLAYER = 500


var velocity = Vector2.ZERO

var names = ["Richard", "Robert", "Rachel", "Ryan"]
var rng = RandomNumberGenerator.new()
var companionName = ""

var state = FOLLOW

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

var is_asked_follow = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if companionName != "":
		nameLabel.set_text(companionName)
	else:
		rng.randomize()
		var randomName = rng.randi_range(0, 3)
		companionName = names[randomName]
	match state:
		FOLLOW:
			if is_asked_follow == true:
				seek_target()
				var follow_player = playerDetectionZone.target
				if follow_player != null:
					acceleration_towards_point(follow_player.global_position, delta)
				else:
					state = IDLE
					global_position = player.global_position
			else:
				state = IDLE
		ATTACK:
			var enemy = enemyDetectionZone.target
			if enemy != null:
				acceleration_towards_point(enemy.global_position, delta)
			else:
				state = IDLE
		IDLE:
			seek_target()
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)
	if Input.is_action_just_pressed("follow"): 
		if state == IDLE:
			state = FOLLOW
			is_asked_follow = true
		else:
			state = IDLE
			is_asked_follow = false

func acceleration_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func seek_target():
	if enemyDetectionZone.can_see_target():
		state = ATTACK
		
func seek_player():
	if playerDetectionZone.can_see_target():
		state = FOLLOW

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : "",#get_parent().get_path(),
		"pos_x" : player.position.x, # Vector2 is not supported by JSON
		"pos_y" : player.position.y,
		"companionName" : companionName,
#        "attack" : attack,
#        "defense" : defense,
#        "current_health" : current_health,
#        "max_health" : max_health,
#        "damage" : damage,
#        "regen" : regen,
#        "experience" : experience,
#        "tnl" : tnl,
#        "level" : level,
#        "attack_growth" : attack_growth,
#        "defense_growth" : defense_growth,
#        "health_growth" : health_growth,
#        "is_alive" : is_alive,
#        "last_attack" : last_attack
	}
	return save_dict
	
