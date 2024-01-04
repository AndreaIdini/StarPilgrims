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
# Called when the node enters the scene tree for the first time.
func _ready():
	moduleType = station.FACTORY
	
	description = moduleType["description"] + "\n \n" + \
	"credits earning:   " + str(moduleType["earning_credits"]) + " per day \n" + \
	"building material: " + str(moduleType["build_matter"]) + " ton \n" + \
	"build energy:      " + str(moduleType["build_energy"]) + " kWh \n" + \
	"build credits:     " + str(moduleType["build_credits"]) + "\n" + \
	"upkeep:            " + str(moduleType["upkeep_matter"]) + " kg/d +" + str(moduleType["upkeep_power"]) + " kW"
	
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
		
		
