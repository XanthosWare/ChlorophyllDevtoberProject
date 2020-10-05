extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area2D_area_entered(area):
	set_text("Plant Maker Entered")

func _on_Area2D_area_exited(area):
	set_text("Plant Maker Exited")
