extends Node

var time = 0.                   # days
var credits = 1000.             # ~ 1k dollars
var cheat = true

@onready var count_days = %CountDays
@onready var count_cred = %CountCred

@onready var station = $PanelStation
@onready var launch = $Launch

# Called when the node enters the scene tree for the first time.
func _ready():
	update_show()
	
	if cheat:
		credits = 10000
		station.matter = 10000
		station.energy = 50
	
	print('initialized')
	#print(station.starting)
	

func update_show():
	count_days.text = str(floor(time))
	count_cred.text = str("%10.1f" % credits)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _physics_process(delta):
	time += delta
		
	credits += station.humans * station.humans_rent * delta
	
	update_show()

