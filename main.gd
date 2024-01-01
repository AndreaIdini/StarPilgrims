extends Node

var time = 0.                   # days

var credits = 1000.             # ~ 1k dollars

var launch_in_progress = false
var launching_matter = false
var launching_humans = false
var launch_counter = 0.
var time_to_launch_matter = 1.
var time_to_launch_humans = 2.
var matter_cost = 1000.         # cred/ton


@onready var count_days = %CountDays
@onready var count_cred = %CountCred
@onready var progress_launch_m = %ProgressLaunchM
@onready var progress_launch_h = %ProgressLaunchH
@onready var box_launch_m = %BoxLaunchM

@onready var station = $PanelStation



func solar_power(p,t):
	return p*abs(sin(t*3.141))

# Called when the node enters the scene tree for the first time.
func _ready():
	update_show()
	
	print('initialized')
	#print(station.starting)
	
	pass # Replace with function body.

func update_show():
	count_days.text = str(floor(time))
	count_cred.text = str("%10.1f" % credits)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _physics_process(delta):

	time += delta
		
	credits += station.humans * station.humans_rent * delta
	
	if launch_in_progress:
		launch_counter +=delta
		if launching_matter:
			progress_launch_m.value = launch_counter

			if launch_counter > time_to_launch_matter:

				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				progress_launch_m.value = launch_counter
				
				station.matter += box_launch_m.value
				credits -= box_launch_m.value*matter_cost

		if launching_humans:
			progress_launch_h.value = launch_counter
			if launching_humans && launch_counter > time_to_launch_humans:
				launch_in_progress = false
				launching_matter = false
				launching_humans = false
				launch_counter = 0.
				station.humans += 1
		
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

