extends Node

class_name Station

var time = 0.

var energy = 0.                 # KWh
var matter = 0.                 # ton
var humans = 0

var battery_cap                 # KWh
var power                       # KW
var pow_consumption
var solar_power_installed       # kW
var modules_upkeep              # KW
var power_construction=0.       # KW

var matter_transf = 0.
var matter_change
var humans_cap

var humans_matter_upkeep = 10   # Kg
var humans_energy_upkeep = 5    # KW
var humans_rent = 20            # cred

#enum ModuleNames {STARTING, SOLAR_PANEL, basic_living}

const STARTING = {
	"name": "Starting Module",
	"description": "The starting module is the core of your space station, built with the best materials designed to stand the test of time and already equipped with everything necessary to host humans and keep them warm and fed. It has beds for 3 humans, but not enough energy. Careful!",
	"power": 15.,                # KW
	"battery": 50.,              # KWh
	"living_space": 3.,          # Capacity for Humans
	"upkeep_power": 3.,          # KW
	"upkeep_matter": 0.,         # Kg/d
	"build_matter": 5.,          # ton
	"build_energy": 100.,        # KWh
	"build_credits": 3000,
	"build_time": 30.
}

const SOLAR = {
	"name": "Solar Array Wing", # Specs from ISS
	"description": "The solar array wing is a module of solar panels, that can be extended and orientated to face the Sun as efficiently as possible and collect precious energy. Some battery included.",
	"power": 30.,                # KW
	"battery": 5.,               # KWh
	"living_space": 0.,          # Capacity for Humans
	"upkeep_power": 0.,          # KW
	"upkeep_matter": 0.,         # Kg/d
	"build_matter": 1.,          # ton
	"build_energy": 20.,         # KWh
	"build_credits": 500,
	"build_time": 3.
}

const BATTERY = {
	"name": "Battery Storage",  # 
	"description": "The battery storage module will provide all your energy storage needs at the most convenient price, it needs some power and batteries need to be replaced from time to time.",
	"power": 0,                  # KW
	"battery": 50.,              # KWh
	"living_space": 0.,          # Capacity for Humans
	"upkeep_power": 0.1,         # KW
	"upkeep_matter": 1.,         # Kg/d
	"build_matter": 1.,          # ton
	"build_energy": 30.,         # KWh
	"build_credits": 500,
	"build_time": 5.
}

const BASIC_LIVING = {
	"name": "Basic Living Facilities",
	"description": "Living quarters for 5 humans, with some basic amenities but needs energy and material upkeep.",
	"power": 0.,                 # KW
	"battery": 20.,              # KWh
	"living_space": 5.,          # Capacity for Humans
	"upkeep_power": 3.,         # KW
	"upkeep_matter": 5.,         # Kg/d
	"build_matter": 5.,           # ton
	"build_energy": 50.,          # KWh
	"build_credits": 2000,
	"build_time": 10.
}

const DRONE = {
	"name": "Mining Drone Bay",
	"description": "Living quarters for 5 humans, with some basic amenities but needs energy and material upkeep.",
	"power": 0.,                 # KW
	"battery": 20.,              # KWh
	"living_space": 5.,          # Capacity for Humans
	"upkeep_power": 20.,         # KW
	"upkeep_matter": 5.,         # Kg/d
	"build_matter": 5.,           # ton
	"build_energy": 50.,          # KWh
	"build_credits": 10000,
	"build_time": 10.
}

const COMPUTING = {
	"name": "Computing Center",
	"description": "A computing center to crunch numbers using the refrigeration in the coldness of space.",
	"power": 0.,                 # KW
	"battery": 20.,              # KWh
	"living_space": 5.,          # Capacity for Humans
	"upkeep_power": 20.,         # KW
	"upkeep_matter": 5.,         # Kg/d
	"build_matter": 5.,           # ton
	"build_energy": 50.,          # KWh
	"build_credits": 2000,
	"build_time": 10.
}

var Modules = [STARTING]

@onready var count_power = %CountPower
@onready var count_energy = %CountEnergy
@onready var progress_bar = %ProgressBar

@onready var count_matter = %CountMatter
@onready var count_matter_transf = %CountMatterTransf
@onready var count_humans = %CountHumans
@onready var count_consumption = %CountConsumption

@onready var container_solar_panel = %ContainerSolarPanel
@onready var label_experiments = %LabelExperiments
@onready var label_drones = %LabelDrones


# Called when the node enters the scene tree for the first time.
func _ready():
	print("station ready", Modules)
	station_properties()
	print(battery_cap, " ",power)
	
	container_solar_panel.show()
	container_solar_panel.get_child(0).text = "0"
	
	label_experiments.hide()
	label_experiments.get_child(0).text = "0"
	label_drones.hide()
	label_drones.get_child(0).text = "0"

	#Modules.append(SOLAR)
#
	#station_properties()
	#print(battery_cap, " ", power)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	time += delta
	
	pow_consumption = power_construction + modules_upkeep + humans*humans_energy_upkeep
	power = solar_power(solar_power_installed, time) - pow_consumption
	
	energy += power*delta
	energy = min(energy,battery_cap)
	
	matter_change = matter_transf - humans*humans_matter_upkeep
	matter += matter_change*delta/1000
	
	count_matter.text = str("%10.2f" % matter)
	count_power.text = str("%10.1f" % solar_power_installed)
	count_energy.text = str("%10.1f" % energy) + "/" + str("%10.1f" % battery_cap)
	count_matter_transf.text = str(matter_change)
	count_humans.text = str(humans) + "/" + str(humans_cap)
	count_consumption.text = str(pow_consumption)
	
	progress_bar.max_value = battery_cap
	progress_bar.value = energy
	pass

func station_properties():
	humans_cap = 0
	
	battery_cap = 0.
	solar_power_installed = 0.
	modules_upkeep = 0.
	for module in Modules:
		solar_power_installed += module["power"]
		modules_upkeep += module["upkeep_power"]
		battery_cap += module["battery"]
		humans_cap += module["living_space"]
	

func print_state():
	print('--- Printing State ---')
	print('humans ', humans)
	print('energy ', energy)
	print('matter ', matter)

func solar_power(p,t):
	return p*abs(sin(t*3.141))
