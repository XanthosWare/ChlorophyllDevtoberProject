extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = $"Visual Text Debug"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_companions("/root/GreenHome")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	Global.save_companions()
	get_tree().change_scene("res://Environments/Dungeon Crawler/Dungeon.tscn")
