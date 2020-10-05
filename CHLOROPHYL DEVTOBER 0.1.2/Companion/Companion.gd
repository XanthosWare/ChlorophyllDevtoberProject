extends KinematicBody2D

onready var player = get_parent().get_node("Player")
onready var enemyDetectionZone = $TargetDetectionZone
onready var nameLabel = $Name

export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500

var velocity = Vector2.ZERO

var names = ["Richard", "Robert", "Rachel", "Ryan"]
var rng = RandomNumberGenerator.new()
var companionName = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if companionName == "":
		rng.randomize()
		var randomName = rng.randi_range(0, 3)
		nameLabel.set_text(names[randomName])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var enemy = enemyDetectionZone.target
	if enemyDetectionZone.can_see_target():
		if enemy != null:
			acceleration_towards_point(enemy.global_position, delta)
	else:
		acceleration_towards_point(player.global_position, delta)
	velocity = move_and_slide(velocity)

func acceleration_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"parent" : "",#get_parent().get_path(),
		"pos_x" : position.x, # Vector2 is not supported by JSON
		"pos_y" : position.y,
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
	
