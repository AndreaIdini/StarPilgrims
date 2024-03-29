extends Control

class_name Module_Build

var time = 0.
var build_in_progress = false
var build_counter = 0.
var build_time
var counter = 0.

var moduleType
var progress_bar 
var labelCounter
var station
var control

# Called when the node enters the scene tree for the first time.
# What follows is the same for each Module Building Container, only the moduleType definition is different 
func _init(type, bar, label, stat, ctrl):
	moduleType = type
	progress_bar = bar
	labelCounter = label
	station = stat
	control = ctrl
	
	counter = int(labelCounter.text)
	
	build_time = moduleType["build_time"]/log(station.humans+1.)*log(2)
	if station.Hotel == false and station.Modules.count(station.LUXURY_LIVING) > 0:
		build_time = build_time/1.5
	
	progress_bar.max_value = build_time # Set the maximum value of the progress bar
	build_in_progress = true
	build_counter = 0.


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var time_multi = station.tab_bar.current_tab*station.tab_bar.current_tab
	delta = delta*time_multi
	if build_in_progress:
		build_counter +=delta
		progress_bar.value = build_counter

		if build_counter > build_time:
			control.credits += - moduleType["build_credits"]/log(station.Modules.count(station.FACTORY)+2.)*log(2.)
			
			counter += 1
			station.Modules.append(moduleType)
			station.station_properties()
			
			labelCounter.text = str("%3d" % counter)
			progress_bar.value = 0
			build_in_progress = false

			queue_free() # Destroys this instance
			return
			
		station.energy += - moduleType["build_energy"]/build_time*delta
		station.matter += - moduleType["build_matter"]/build_time*delta


		#station.power_construction += moduleType["build_energy"]/build_time
