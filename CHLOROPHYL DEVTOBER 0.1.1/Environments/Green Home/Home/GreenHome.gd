extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var label = $"Visual Text Debug"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Global.get_child_count())
	if Global.get_child_count() != 0:
		for child in Global.get_children():
			print(child)
		label.set_text("Global has children")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	get_tree().change_scene("res://Environments/Dungeon Crawler/Dungeon.tscn")
