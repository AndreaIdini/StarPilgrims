extends VBoxContainer

@onready var station = $"../.."
@onready var story_box = %StoryBox

var required_matter = 5000.
var required_power = 2000.
var original_credits = 5000000
var required_credits = 5000000
var description

var mode = 0 # 0: BOLAS, 1: RogueAI, 2: Capitalist
# Called when the node enters the scene tree for the first time.
func _ready():
	description = "The BOLAS station is arranged as two modules tethered with a partially flexible connection. While these module orbit each other, they generate an artificial gravity through their relative motion. 

building material: " + str(required_matter) + " ton \n" + \
"required power output: " + str(required_power) + " kW\n" +\
"required credits: " + str(original_credits) + "\n
Constructing the BOLAS station wins the game."
#Will enable humans to comfortably live and work and is the first stage of transforming a self-sufficient outpost to an independent colony capable of further greatness.
	pass # Replace with function body.

func update_description():
	match mode:
		0:	#BOLAS
			$BuildBOLAS.text="Build BOLAS Station"
			required_credits = original_credits/log(station.Modules.count(station.FACTORY)+2.)*log(4.)
			return "The BOLAS station is arranged as two modules tethered with a partially flexible connection. While these module orbit each other, they generate an artificial gravity through their relative motion.\n\n" + \
					"building material: " + str(required_matter) + " ton \n" + \
					"required power output: " + str(required_power) + " kW\n" + \
					"required credits: " + str("%10d" % required_credits) + "\nConstructing the BOLAS station wins the game."
		1: #RogueAI
			$BuildBOLAS.text="Become Independent AI"
			required_power = 4000.
			required_matter = 1500.
			return "Time to become independent of these humans. Expand your capabilities with a factory to construct robots and module components so to push and further your expansion without any need for human hands.\n\n" +\
					"building material: " + str(required_matter) + " ton \n" + \
					"required power output: " + str(required_power) + " kW\n" + \
					"required buildings: 8 Zero-G Factories, 16 Data centers\n\nBuilding the robot factory wins the game."
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
	#pass

func _on_build_bolas_pressed():
	var condition = false
	match mode:
		0: 	# BOLAS
			condition = station.matter > required_matter && station.solar_power_installed > required_power && $"../../..".credits > required_credits
		1:	# RogueAI
			condition = station.matter > required_matter && station.solar_power_installed > required_power && station.Modules.count(station.FACTORY) > 7 and station.Modules.count(station.COMPUTING) > 15

	if condition:
		story_box.Endgame(station.time, mode)
		
	pass # Replace with function body.
