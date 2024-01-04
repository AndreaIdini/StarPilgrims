extends HBoxContainer

var moduleType
var progress_bar
var labelCounter


@onready var control = $"../../.."
@onready var station = $"../.."
@onready var module_build = $".."
const ModuleBuild = preload("res://ModuleBuild.gd")

var Building_Event: ModuleBuild

var pressed = false

var description
	#"power": 15.,                # KW
	#"battery": 50.,              # KWh
	#"living_space": 3.,          # Capacity for Humans
	#"drone_bays": 0.,            # Capacity for Drones
	#"upkeep_power": 3.,          # KW
	#"upkeep_matter": 0.,         # Kg/d
	#"earning_credits": 0.,      # Credits/d
	#"build_matter": 5.,          # ton
	#"build_energy": 100.,        # KWh
	#"build_credits": 3000,
	#"build_time": 30.
# Called when the node enters the scene tree for the first time.
func _ready():
	moduleType = station.SOLAR

	description = moduleType["description"] + "\n \n" + \
	"power:             " + str(moduleType["power"]) + " kW \n" + \
	"building material: " + str(moduleType["build_matter"]) + " ton \n" + \
	"build energy:      " + str(moduleType["build_energy"]) + " kWh \n" + \
	"build credits:     " + str(moduleType["build_credits"])

	progress_bar = get_child(1).get_child(1)
	labelCounter = get_child(0)

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Building_Event != null:
		Building_Event._physics_process(delta)
	pass
	
	
func _on_build_pressed():
	
	if station.energy > moduleType["build_energy"] && station.matter > moduleType["build_matter"] && control.credits > moduleType["build_credits"]:
		Building_Event = Module_Build.new(moduleType, progress_bar, labelCounter, station, control)
		pressed = true
		
		
