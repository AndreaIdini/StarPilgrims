extends Node

class_name Station

var time = 0.

var energy = 0.                 # KWh
var battery_cap = 50.           # KWh
var power = 0.                  # KW
var pow_consumption = 0.
var solar_power_installed = 15. # kW
var module_upkeep = 3.          # KW
var matter = 0.                 # ton
var matter_transf = 0.
var humans = 0
var humans_matter_upkeep = 10   # Kg
var humans_energy_upkeep = 5    # KW
var humans_rent = 20            # cred

var starting = 1
var Modules = [starting]

@onready var count_power = %CountPower
@onready var count_energy = %CountEnergy
@onready var progress_bar = %ProgressBar

@onready var count_matter = %CountMatter
@onready var count_matter_transf = %CountMatterTransf
@onready var count_humans = %CountHumans
@onready var count_consumption = %CountConsumption

# Called when the node enters the scene tree for the first time.
func _ready():
	print("station ready", Modules)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time += delta
	
	pow_consumption = module_upkeep + humans*humans_energy_upkeep
	power = solar_power(solar_power_installed, time) - pow_consumption
	
	energy += power*delta
	energy = min(energy,battery_cap)
	
	matter_transf = - humans*humans_matter_upkeep
	matter += matter_transf*delta/1000
	
	count_matter.text = str("%10.2f" % matter)
	count_power.text = str("%10.1f" % solar_power_installed)
	count_energy.text = str("%10.1f" % energy) + "/" + str("%10.1f" % battery_cap)
	count_matter_transf.text = str(matter_transf)
	count_humans.text = str(humans)
	count_consumption.text = str(pow_consumption)
	
	progress_bar.max_value = battery_cap
	progress_bar.value = energy
	pass

func print_state():
	print('--- Printing State ---')
	print('humans ', humans)
	print('energy ', energy)
	print('matter ', matter)


func solar_power(p,t):
	return p*abs(sin(t*3.141))
