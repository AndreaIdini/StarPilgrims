extends Control

class_name Launch

var time = 0.

var launch_in_progress = false
var launching_matter = false
var launching_humans = false
var launch_counter = 0.
var time_to_launch_matter = 1.
var time_to_launch_humans = 2.
var matter_cost = 1000.         # cred/ton

@onready var progress_launch_m = %ProgressLaunchM
@onready var progress_launch_h = %ProgressLaunchH
@onready var box_launch_m = %BoxLaunchM
@onready var station = $"../PanelStation"
@onready var control = $".."
@onready var tab_bar = %TabBar

# Called when the node enters the scene tree for the first time.
func _ready():
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
				station.humans += 1
		


func _on_launch_humans_pressed():
	if station.humans_cap > station.humans:
		launch_in_progress = true
		launch_counter = 0
		launching_matter = false
		launching_humans = true
		
		progress_launch_h.max_value = time_to_launch_humans
	


func _on_launch_matter_pressed():
	launch_in_progress = true
	launch_counter = 0
	launching_matter = true
	launching_humans = false
	
	progress_launch_m.max_value = time_to_launch_matter

