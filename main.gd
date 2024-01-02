extends Node

var time = 0.                   # days
var time_multi = 1.
var credits = 1000.             # ~ 1k dollars
var cheat = true


@onready var count_days = %CountDays
@onready var count_cred = %CountCred

@onready var station = $PanelStation
@onready var launch = $Launch
@onready var tab_bar = %TabBar

# Called when the node enters the scene tree for the first time.
func _ready():
	if cheat:
		print("cheat credits")
		credits = 100000
	update_show()
	
	print('initialized')
	#print(station.starting)
	

func update_show():
	count_days.text = str(floor(time))
	count_cred.text = str("%10.1f" % credits)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _physics_process(delta):
	 # time multiplier = 0 pause, 1 play, 4 fast forward, 9 super fast
	time_multi = tab_bar.current_tab*tab_bar.current_tab
	delta = delta*time_multi
	
	time += delta 
		
	credits += station.humans * station.humans_rent * delta
	
	update_show()

