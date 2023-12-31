extends Node

var time = 0.                   # days
var energy = 0.                 # KWh
var battery_cap = 50.           # KWh
var power = 0.                  # KW
var pow_consumption = 0.
var solar_power_installed = 15. # kW
var module_upkeep = 3.          # KW
var matter = 0.                 # ton
var matter_transf = 0.
var matter_cost = 1000.         # cred/ton
var humans = 0
var humans_matter_upkeep = 10   # Kg
var humans_energy_upkeep = 5    # KW
var humans_rent = 20            # cred

var credits = 1000.             # ~ 1k dollars

var launch_in_progress = false
var launching_matter = false
var launching_humans = false
var launch_counter = 0.
var time_to_launch_matter = 7.
var time_to_launch_humans = 14.

@onready var count_days = %CountDays
@onready var count_power = %CountPower
@onready var count_energy = %CountEnergy
@onready var progress_bar = %ProgressBar
@onready var count_cred = %CountCred
@onready var count_matter = %CountMatter
@onready var count_matter_transf = %CountMatterTransf
@onready var count_humans = %CountHumans
@onready var progress_launch_m = %ProgressLaunchM
@onready var progress_launch_h = %ProgressLaunchH
@onready var box_launch_m = %BoxLaunchM
@onready var count_consumption = %CountConsumption

func solar_power(p,t):
	return p*abs(sin(t*3.141))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_show()
	
	print('initialized')
	pass # Replace with function body.

func update_show():
	count_days.text = str(floor(time))
	
	count_matter.text = str("%10.2f" % matter)
	count_power.text = str("%10.1f" % solar_power_installed)
	count_energy.text = str("%10.1f" % energy) + "/" + str("%10.1f" % battery_cap)
	count_matter_transf.text = str(matter_transf)
	count_cred.text = str("%10.1f" % credits)
	count_humans.text = str(humans)
	count_consumption.text = str(pow_consumption)
	
	progress_bar.max_value = battery_cap
	progress_bar.value = energy
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _physics_process(delta):

	time += delta
	
	pow_consumption = module_upkeep + humans*humans_energy_upkeep
	power = solar_power(solar_power_installed, time) - pow_consumption
	
	energy += power*delta
	energy = min(energy,battery_cap)
	
	matter_transf = - humans*humans_matter_upkeep
	matter += matter_transf*delta/1000
	
	credits += humans * humans_rent * delta
	
	if launch_in_progress:
		launch_counter +=delta
		if launching_matter:
			progress_launch_m.value = launch_counter
			if launch_counter > time_to_launch_matter:
				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				matter += box_launch_m.value
				credits -= matter*matter_cost
				
		if launching_humans:
			progress_launch_h.value = launch_counter
			if launching_humans && launch_counter > time_to_launch_humans:
				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				humans += 1
			
	update_show()
	pass

func _on_launchMatter_pressed():
	launch_in_progress = true
	launch_counter = 0
	launching_matter = true
	launching_humans = false
	
	progress_launch_m.max_value = time_to_launch_matter
	
	pass
	
func _on_launchHumans_pressed():
	launch_in_progress = true
	launch_counter = 0
	launching_matter = false
	launching_humans = true
	
	progress_launch_h.max_value = time_to_launch_humans

	pass

