extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.load_companions("/root/Dungeon")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Teleporter_Area2D_area_entered(area):
	Global.save_game()
	var debugtext = get_node("Visual Text Debug")
	debugtext.set_text("teleported")
	get_tree().change_scene("res://Environments/Green Home/Home/GreenHome.tscn")
