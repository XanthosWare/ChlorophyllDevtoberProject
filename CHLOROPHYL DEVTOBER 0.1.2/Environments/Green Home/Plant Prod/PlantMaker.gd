extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Companion = preload("res://Companion/Companion.tscn")

var areas
onready var label = $"Visual Text Debug"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if  areas != null and Input.is_action_just_pressed("use"): 
		if Global.chlorophyl > 0:
			label.set_text("You got companion!")
			var companion = Companion.instance()
			get_parent().add_child(companion)
			companion.global_position = global_position
			Global.chlorophyl -=1
		else:
			label.set_text("Not enough chlorophyl")

func _on_Area2D_area_entered(area):
	areas = area

func _on_Area2D_area_exited(area):
	areas = null
