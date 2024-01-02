extends HBoxContainer

var time = 0.
var build_in_progress = false
var build_counter = 0.
var build_time
var counter = 0.

var moduleType
var progress_bar 
var labelCounter

@onready var station = $".."
@onready var control = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	moduleType = station.SOLAR

	progress_bar = get_child(1).get_child(1)
	labelCounter = get_child(0)
	
	build_time = moduleType["build_time"]

	control.credits = 10000
	station.matter = 10000
	station.energy = 50

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if build_in_progress:
		build_counter +=delta
		progress_bar.value = build_counter

		if build_counter > build_time:
			control.credits += - moduleType["build_credits"]
			
			counter += 1
			station.Modules.append(moduleType)
			station.station_properties()
			
			labelCounter.text = str(counter)
			progress_bar.value = 0
			build_in_progress = false
			return
			
		station.energy += - moduleType["build_energy"]/build_time*delta
		station.matter += - moduleType["build_matter"]/build_time*delta

func _on_build_pressed():
	
	progress_bar.max_value = build_time # Set the maximum value of the progress bar
	if station.energy > moduleType["build_energy"] && station.matter > moduleType["build_matter"] && control.credits > moduleType["build_credits"]:
		build_in_progress = true
		build_counter = 0
		#station.power_construction += moduleType["build_energy"]/build_time
