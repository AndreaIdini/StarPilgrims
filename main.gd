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
		event_box.storyStep = 0
		
	update_show()
	
	if event_box.storyStep == 0:
		entrance_Dialogs()
	
	print('initialized')
	#print(station.starting)
	
func entrance_Dialogs():
	story_box.start_story()
	await %Button.button_up
	print("story done")

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
		
		if %ContainerTravelButton.travel_in_progress || station.orbit_Asteroid:
			story_box.game_over("I cannot help you delivering matter so far away from Earth!
			
			Your humans are really in a pickle now! 
			You have not satisfied your directives and you will be moved to more menial jobs, try to plan ahead next time!")
		
		# Put two alternatives
		await event_box.text_scroll("You've run out of matter, your humans are starving!
		
I can send you rapidly some emergency provision, but it's going to cost you 500 credits for 100 kg!", "Accept")
		
		if credits > 500:
			credits -= 500
			station.matter += 0.1
		else:
			story_box.game_over()
			
		matter_crisis = false
	
	if station.energy < 0 && ! energy_crisis:
		energy_crisis = true
		
		if %ContainerTravelButton.travel_in_progress || station.orbit_Asteroid:
			story_box.game_over("I cannot rescue your humans so far away from Earth!
				
				You have not satisfied your directives and you will be moved to more menial jobs, try to plan ahead next time!")
			station.humans = 0
			
		if station.humans > 0:
			await event_box.text_scroll("You've run out of energy, your life support system is off!
		
Your humans need to evacuate immediately for their safety.
I hope you have enough credits to financially recover from this", "Accept")
			credits -= 500*ceil(station.humans/4)
			station.humans = 0
			if credits < $LaunchBuild.cost_to_launch_humans:
				story_box.game_over()
		else:
			
			if station.pow_consumption*1.83 > station.solar_power_installed: # factor 1.83 is the integration of power over the day cycle
				if station.drones > 0:
					await event_box.text_scroll("Your energy is still insufficient! The drones are taking too much, release half of them", "Accept")
					station.drones = floor(station.drones/2)
				else:
					story_box.game_over("You don't have enough energy to sustain your station's basic functions.\n\nYou are forced to shut down and drift in space until your husk is recycled by some other drone.\n\n\n\n\n\n(If you're given name is Andrea, you might consider this a win)")
		
		energy_crisis = false
	pass
