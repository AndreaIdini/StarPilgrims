extends Control

class_name Launch

var time = 0.

var launch_in_progress = false
var launching_matter = false
var launching_humans = false
var launch_counter = 0.
var build_in_progress = false
var build_counter = 0.

var time_to_launch_matter = 7.
var time_to_launch_humans = 14.
var cost_to_launch_humans = 100
var humans_transported = 1
var matter_cost = 1000.         # cred/ton

var time_to_build_drone = 5
var drone_matter_cost = 1 # ton
var drone_energy_cost = 100 # kWh

@onready var progress_launch_m = %ProgressLaunchM
@onready var progress_launch_h = %ProgressLaunchH
@onready var box_launch_m = %BoxLaunchM
@onready var progress_build_md = %ProgressBuildMD

@onready var station = $"../PanelStation"
@onready var control = $".."
@onready var tab_bar = %TabBar

var travelling = false

var description_humans = ""
var description_matter = ""
var description_drone = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	update_descriptions()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var time_multi = tab_bar.current_tab*tab_bar.current_tab
	delta = delta*time_multi
	
	time += delta
	if launch_in_progress:
		launch_counter +=delta
		if launching_matter:
			progress_launch_m.value = launch_counter
			if launch_counter > time_to_launch_matter:
				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				progress_launch_m.value = 0.
				
				station.matter += box_launch_m.value
				control.credits -= box_launch_m.value*matter_cost

		if launching_humans:
			progress_launch_h.value = launch_counter
			if launching_humans && launch_counter > time_to_launch_humans:
				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				progress_launch_h.value = 0.
				station.humans += humans_transported
				
	if build_in_progress:
		build_counter += delta
		progress_build_md.value = build_counter
		station.matter -= drone_matter_cost/progress_build_md.max_value*delta
		
		if build_counter > progress_build_md.max_value:
			build_in_progress = false
			build_counter = 0.
			progress_build_md.value = 0.
			station.drones += 1

func _on_launch_humans_pressed():

	if station.humans_cap >= station.humans + humans_transported && control.credits >= cost_to_launch_humans && ! travelling:
		launch_in_progress = true
		launch_counter = 0
		launching_matter = false
		launching_humans = true
		
		control.credits -= cost_to_launch_humans
		progress_launch_h.max_value = time_to_launch_humans

func _on_launch_matter_pressed():

	print("launch ", box_launch_m.value*matter_cost)
	if control.credits >= box_launch_m.value*matter_cost && ! travelling:
		print("ok")
		launch_in_progress = true
		launch_counter = 0
		launching_matter = true
		launching_humans = false
	
	progress_launch_m.max_value = time_to_launch_matter

func _on_build_drone_pressed():
	if station.matter >= drone_matter_cost && station.drones_cap > station.drones:
		build_in_progress = true
		build_counter = 0
		
	progress_build_md.max_value = time_to_build_drone/log(station.humans+1)*log(2)
	
	if station.Hotel == false and station.Modules.count(station.LUXURY_LIVING) > 0:
		progress_build_md.max_value = time_to_build_drone/log(station.humans+1)*log(2)/1.5


func update_descriptions():
	description_humans = "Will launch an astronaut adding them to your station's crew.\nIt takes time to get them ready and you pay in advance.\nYou are allowed to prepare one launch at any given time.\n\ntime to launch: " + str(time_to_launch_humans) + "\ncost to launch: " + str(cost_to_launch_humans) + "\nhumans: " + str(humans_transported)
	description_matter = "Will launch some matter. Specify the amount of matter in the box, you will pay the corresponding amount.\nYou are allowed to prepare one launch at any given time.\n\ntime to launch: " + str(time_to_launch_matter) + "\ncost to launch: " + str(matter_cost) + " credits/ton\nhumans: " + str(humans_transported)
	description_drone = "Will build a faithful little drone that will collect matter for you \n\ntime to build: " + str(time_to_build_drone) + "\nmatter cost: " + str(drone_matter_cost) + " ton\nenergy cost: "+ str(drone_energy_cost) + " kWh"
