extends Node

var time = 0.                   # days
var time_multi = 1.
var credits = 1000.             # ~ 1k dollars


@onready var count_days = %CountDays
@onready var count_cred = %CountCred

@onready var station = $PanelStation
@onready var tab_bar = %TabBar
@onready var story_box = %StoryBox
@onready var event_box = %EventBox

var button = Button.new()
var matter_crisis = false
var energy_crisis = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if station.cheat:
		print("cheat credits")
		credits = 100000
	update_show()

	entrance_Dialogs()
	
	print('initialized')
	#print(station.starting)
	
func entrance_Dialogs():
	#story_box.start_story()
	#await %Button.button_up
	#print("story done")

	event_box.start_tutorial()
	await $EventBox/Button.button_up
	
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

	if station.matter < 0 && ! matter_crisis:
		matter_crisis = true
		# Put two alternatives
		await event_box.text_scroll("You've run out of matter, your humans are starving!
		
I can send you rapidly some emergency provision, but it's going to cost you 300 credits for 100 kg!", "Accept")
		
		if credits > 300:
			credits -= 300
			station.matter += 0.1
		else:
			story_box.game_over()
		matter_crisis = false
		
	if station.energy < 0 && ! energy_crisis:
		energy_crisis = true
		
		if station.humans > 0:
			await event_box.text_scroll("You've run out of energy, your life support system is off!
		
Your humans need to evacuate immediately for their safety.
I hope you have enough credits to financially recover from this", "Accept")
		
			credits -= 300
			station.humans = 0
		
			if credits < $LaunchBuild.cost_to_launch_humans:
				story_box.game_over()
			

