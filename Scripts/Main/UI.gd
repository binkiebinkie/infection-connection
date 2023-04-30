extends Control

@onready var evolution_drawer = get_node("/root/Game/UICamera/UI/EvolutionDrawer")
@onready var player = get_node("/root/Game/Player")

func _ready():
	get_node("/root/Game/Player").connect("player_evolved", Callable(self, "update_evolution_count"))

func _process(delta):
	pass

func update_evolution_count(count: int):
	$MarginContainer/VBoxContainer/EvolutionButton/EvolutionCount.text = str(count)
	$MarginContainer/VBoxContainer/EvolutionButton/EvolutionCount.visible = count > 0

func _on_evolution_button_pressed():
	evolution_drawer.show_drawer(player.get_queued_evolutions_count())
	evolution_drawer.update_evolution_options($"/root/Game/Player".queued_evolutions)

