extends Node

var time = 0.                   # days
var time_multi = 1.
var credits = 1000.             # ~ 1k dollars

@onready var count_days = %CountDays
@onready var count_cred = %CountCred

@onready var station = $PanelStation
@onready var tab_bar = %TabBar

# Called when the node enters the scene tree for the first time.
func _ready():
	if station.cheat:
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
	var station_earnings = station.Modules.count(station.COMPUTING) * station.COMPUTING["earning_credits"]*delta \
						 + station.Modules.count(station.FACTORY) * station.FACTORY["earning_credits"]*delta*log(station.humans+1)/log(2)
	
	credits += station.humans * station.humans_rent * delta + station_earnings
	
	update_show()

