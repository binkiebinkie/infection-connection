extends Node2D


func _ready():
	# Connect the button's "pressed" signal to the "_on_StartGame_pressed" function
	$StartGame.connect("pressed", _on_StartGame_pressed)

func _on_StartGame_pressed():
	print("Hello world!")
	
	# Replace the current scene with the game scene
	get_tree().change_scene_to_file("../../Scenes/Main/game.tscn")

