extends VBoxContainer

var moduleType
var progress_bar
var button

@onready var control = $"../../.."
@onready var station = $"../.."
@onready var launch_build = $"../../../LaunchBuild"

var pressed = false
var travel_in_progress = false
var travel_counter = 0.
var travel_tot_time = 9999999.

var mass_cost
var energy_cost

# Called when the node enters the scene tree for the first time.
func _ready():	
	button = get_child(0)
	progress_bar = get_child(1)

func _physics_process(delta):
	
	var time_multi = station.tab_bar.current_tab*station.tab_bar.current_tab
	delta = delta*time_multi
	
	if travel_in_progress:
		travel_counter +=delta
		progress_bar.value = travel_counter

		if travel_counter > travel_tot_time:
			station.orbit_Asteroid = true
			launch_build.cost_to_launch_humans = 3000
			launch_build.matter_cost = 5000
			launch_build.time_to_launch_matter = 180.
			launch_build.time_to_launch_humans = 100.
			launch_build.humans_transported = 6
			
			station.station_properties()
			
			travel_in_progress = false
			launch_build.travelling = false
			
			self.hide()
			return
			
		station.energy += - energy_cost/travel_tot_time/24*delta
		station.matter += - mass_cost/travel_tot_time*delta
		
		if station.energy < 0 || station.matter < 0:
			travel_in_progress = false
			%StoryBox.game_over()
			self.hide()
			return

		

func _on_travel_button_pressed():
	var travel_cost = calculate_travel_cost()
	travel_tot_time = travel_cost[2]
	progress_bar.max_value = travel_tot_time
	
	print(station.matter > travel_cost[1] && station.power, " ", station.solar_power_installed > travel_cost[0]/travel_tot_time/24.)
	if station.matter > travel_cost[1] && station.solar_power_installed > travel_cost[0]/travel_tot_time/24.:
		print("here")
		if ! travel_in_progress:
			print("departure")
			pressed = true
			travel_in_progress = true
			launch_build.travelling = true
			station.drones_matter_mining = 0.
			station.drones_energy_upkeep = 0.

# TODO: check this orbital mechanics and make this function more realistic, especially with respect to the number of engines
func calculate_travel_cost():

	var station_mass = station.station_mass()
	var engines = station.Modules.count(station.ENGINE)
	
	mass_cost = station_mass/5. * min(4, sqrt(engines))
	energy_cost = station_mass*2./3. * 20 * engines # E = DeltaV*m. 1J = 0.27*10^-3 Wh => ton * km/s = 10^6J approx kWh 
	
	var time = 600/engines
	return [energy_cost,mass_cost, time]
