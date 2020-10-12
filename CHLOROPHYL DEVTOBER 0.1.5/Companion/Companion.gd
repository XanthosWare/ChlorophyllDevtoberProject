extends KinematicBody2D

enum {FOLLOW, ATTACK, IDLE}

onready var player = get_parent().get_node("Player")
onready var enemyDetectionZone = $EnemyDetectionZone
onready var playerDetectionZone = $PlayerDetectionZone
onready var nameLabel = $Name
onready var softCollisions = $SoftCollision
onready var commandLabel = $Command
onready var sprite = $Sprite
onready var hurtbox = $HurtBox
onready var stats = $Stats

export var MAX_SPEED = 100
export var ACCELERATION = 500
export var FRICTION = 500
export var MAX_DISTANCE_FROM_PLAYER = 500


var velocity = Vector2.ZERO

var names = ["Richard", "Robert", "Rachel", "Ryan"]
var rng = RandomNumberGenerator.new()
var companionName = ""

var state = FOLLOW
var is_player_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("no_health", self, "player_dead")

var is_asked_follow = true
var is_asked_attack = false

func player_dead():
	state = IDLE
	is_player_dead = true
	is_asked_follow = false
	is_asked_attack = false
	print("Player dead")

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
					if is_player_dead == false:
						global_position = player.global_position
						state = IDLE
			else:
				state = IDLE
		ATTACK:
			if is_asked_attack == true:
				var enemy = enemyDetectionZone.target
				if enemy != null:
					acceleration_towards_point(enemy.global_position, delta)
				else:
					state = IDLE
			else:
				state = FOLLOW
		IDLE:
			seek_target()
			seek_player()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	if softCollisions.is_colliding():
		velocity += softCollisions.get_push_vector() * delta * ACCELERATION
	velocity = move_and_slide(velocity)
	var commandline = ""
	if Input.is_action_just_pressed("attack"): 
		if is_asked_attack == false:
			is_asked_attack = true
		else:
			is_asked_attack = false

	if Input.is_action_just_pressed("follow"): 
		if is_asked_follow == false:
			is_asked_follow = true
		else:
			is_asked_follow = false
	if is_asked_attack == true:
		commandline += " attacking"
	else:
		commandline += " not attacking"
	if is_asked_follow == true:
		commandline += " following"
	else:
		commandline += " not following"
	commandLabel.set_text(commandline)
	

func acceleration_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_target():
	if enemyDetectionZone.can_see_target() && is_asked_attack == true:
		state = ATTACK
		
func seek_player():
	if playerDetectionZone.can_see_target() && is_asked_follow == true:
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
	


func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)


func _on_Stats_no_health():
	queue_free()
