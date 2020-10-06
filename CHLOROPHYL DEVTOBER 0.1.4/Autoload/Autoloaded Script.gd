extends Node2D


var chlorophyl = 99
export var max_health = 1 setget set_max_health
var health = max_health setget set_health

signal no_health 
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
	
	## C:\Users\grimson\AppData\Roaming\Godot\app_userdata\Chlorophyl Devtober
	
func save_game():
	saving("user://savegame.save", "Persist")

func load_game():
	loading("user://savegame.save", "Persist")
	
func save_companions():
	saving("user://companion.save", "PersistCompanion")
	
func load_companions(CompanionParentPath):
	loading("user://companion.save", "PersistCompanion", CompanionParentPath)

func saving(SavePath, Group):
	var save = File.new()
	save.open(SavePath, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group(Group)
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		print("Saving" + String(node.name))
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")

		# Store the save dictionary as a new line in the save file.
		save.store_line(to_json(node_data))
	save.close()
	

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func loading(SavePath, Group, CompanionParentPath = ""):
	var save = File.new()
	if not save.file_exists(SavePath):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group(Group)
	for i in save_nodes:
		i.queue_free()
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save.open(SavePath, File.READ)
	while save.get_position() < save.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		if node_data["parent"] == "":
			get_node(CompanionParentPath).add_child(new_object)
		else:
			get_node(node_data["parent"]).add_child(new_object)
		new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
				continue
			new_object.set(i, node_data[i])
	save.close()
