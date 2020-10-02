extends KinematicBody2D


onready var player = get_parent().get_node("Player")
onready var playerDetectionZone = $PlayerDetectionZone
export var MAX_SPEED = 80
export var ACCELERATION = 500
export var FRICTION = 500

var velocity = Vector2.ZERO



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = playerDetectionZone.target
	if playerDetectionZone.can_see_target():
		if player != null:
			acceleration_towards_point(player.global_position, delta)
	velocity = move_and_slide(velocity)

func acceleration_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)


func _on_Area2D_area_entered(area):
	Global.health -= 1
