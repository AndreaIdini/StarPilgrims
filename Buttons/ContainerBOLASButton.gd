extends VBoxContainer

@onready var station = $"../.."
@onready var story_box = %StoryBox

var required_matter = 5000.
var required_power = 2000.
var required_credits = 5000
var description
# Called when the node enters the scene tree for the first time.
func _ready():
	description = "The BOLAS station is arranged as two modules tethered with a partially flexible connection. While these module orbit each other, they generate an artificial gravity through their relative motion. 

building material: " + str(required_matter) + " ton \n" + \
"required power output: " + str(required_power) + " kW\n" +\
"required credits: " + str(required_credits) + "\n
Constructing the BOLAS station wins the game."
#Will enable humans to comfortably live and work and is the first stage of transforming a self-sufficient outpost to an independent colony capable of further greatness.
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#pass

func _on_build_bolas_pressed():
	if station.matter > required_matter && station.solar_power_installed > required_power :
		story_box.BOLAS_built(station.time)
		
	pass # Replace with function body.
