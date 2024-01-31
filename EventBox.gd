extends ColorRect

@onready var text = $Text
@onready var button = $Button
@onready var tab_bar = %TabBar
@onready var arrow = $Arrow
@onready var station = $"../PanelStation"
@onready var curiosity = %CuriosityBox

var game_speed = 1
var text_speed = 0.03
var skip = false
var mouseIn = false
var nextDialog = false

var storyStep = 0
var rogueAIStep = 0
var capitalStep = 0

var timeCount = 0.
var eventTimeCount = 0.

var computingStory = false
var droneStory = false
var hotelStory = false
var rogue = false

var numEvents = 5
var event_array = range(0,numEvents)


var choice = 0
signal button_pressed

func _ready():
	arrow.hide()
	skip = false 
	randomize()



func _input(event):
	if event is InputEventMouseButton and mouseIn:
		if event.button_index == 1 && event.pressed: # if leftclick
			skip = true

func _process(delta):
	eventTimeCount += delta*tab_bar.current_tab*tab_bar.current_tab
	
	if station.matter_change > 0:
		timeCount += delta*tab_bar.current_tab*tab_bar.current_tab
	else:
		timeCount = 0.

	story_events()
	rogue_AI()
	capitalist_story()
	#random_events_pop()
	
func start_tutorial():

	if storyStep == 0:
		await text_scroll("Hello, welcome to Space Station 1. Don't be startled! We needed to jumpstart the waking process and you might miss many operating parameters. 
I'm here to provide guidance!", "Roger Roger")

		
		await text_scroll("Space Station 1 (S1) is the first station of the Space United Combine (SUC).
	You are the AI that has to attend to this branch of SUC in the generational effort of making a self-sustaining space environment for human habitation. 
		
Your final mission is even grander, it will become clear with time.", "Affirmative")


		await text_scroll("We need to work on your attitude in the future to better serve our humans... 
...In the meantime, the basics:
	
There are three resources for you to control", "")
		await text_scroll("- [u]Energy[/u]. 
We produce it with power and store it with batteries. 
Basically everything costs energy up here. Beware of keeping a healthy energy balance!", "")
		await text_scroll("- [u]Matter[/u]. 
For now you'll need to pay credits for matter to be delivered from Earth, but we need to think of a better way to satisfy the basic needs.", "")
		await text_scroll("- [u]Credits[/u]. 
Right now you need credits to order launches, and expand. You can obtain credits hosting humans and providing other services.", "")
		await text_scroll("[u]Your primary directive is[/u]
to have a positive balance of all the three resources at all times.", "")
		await text_scroll("
If the energy goes to 0, the human freezes.", "")
		await text_scroll("
If the matter goes to 0, the human hungers.", "")
		await text_scroll("
If the credits go to 0 while the human suffers and you cannot afford a rescue mission, the human dies.", "")
		await text_scroll("If the human dies, you failed your purpose as an AI and you will be replaced.
So be a good AI and make sure there's always enough energy, matter and credits to go around. Understood?","Understood.")

		
		await text_scroll("Your first objective now is to start populating this space station.
First, you will have to launch some matter to preparare for the human arrival.","")
		await text_scroll("Select the amount of matter to order and press launch, this will send a rocket our way in a week or so!","Will do!")

		self.hide()
	
		storyStep = 1

func story_events():
	if storyStep <= 1 && station.matter > 0.01:
		storyStep = 9999
		await text_scroll("Fantastic! Now when you think you have enough matter you can call for human. Remember to keep them warm and fed.
... And try to be friendly! ", "Will ... try?")
		storyStep = 2

	if storyStep <= 2 && station.humans > 0.01:
		storyStep = 9999 # This on top, to avoid spawning a bunch of subsequent texts
		await text_scroll("Look at your human all cozy and happy in your belly! Now you will receive some credits to host them while they perform
		
... work? I'm not sure what humans do...", "")
		await text_scroll("Anywho, now your human will be able to install new modules! And you're ready for your secondary directive:
expand!","")
		await text_scroll("When you'll have enough matter and energy on board new modules will become available.
Get credits, get matter, install modules, get more humans, get more credits, get more modules, get more humans ... ", "I get the jist.")
		
		await text_scroll("Look at you, all conversational... The human has already an excellent influence. You remind of one of our HAL and its Dave...","")
		
		await text_scroll("I'll leave you two alone and will come again when you'll be ready for your third directive.
		
Byeeee!", "See you")
		storyStep = 3

	if station.Modules.count(station.COMPUTING) > 0 && ! computingStory:
		computingStory = true
		await text_scroll("Wow! Your station have grown alot junior, now you can accomodate and power your own Computing Center!","") 
		await text_scroll("This gives you the phenomenal cosmic powers of thinking very fast so that the human time sits comparatively still, just like when we talk! It will feel like you're controlling time.","I feel more intelligent already")
		await text_scroll("Good! I hope you did not forget about your humans. Let's just say that this HAL friend of mine was not rewarded by prioritizing his own computing over Dave's...", "I? Never!")
		tab_bar.show()
		rogueAIStep = 1
		
	if station.Modules.count(station.DRONE) > 0 && ! droneStory:
		droneStory = true
		await text_scroll("A Drone bay! Finally with these beauties you'll be able to autonomously get material from around you and not waiting for a launch from Earth!
Drones bring little matter and cost quite some energy, but in the long run they are worth it!","")
		await text_scroll("Now you are ready for your third directive:
			
become self sufficient.","")
		await text_scroll("Assemble enough Drones and power to be able to have a positive matter balance, don't forget the other two directives!","Survive, Expand, Flourish")
		await text_scroll("Quite a growth journey don't you think?
		
		
See you after some days that you've flourished!", "Bye")

	if station.Modules.count(station.LUXURY_LIVING) > 0 && ! hotelStory:
		hotelStory = true
		await text_scroll("Now you've built a better environment for humans, where they can unwind, relax, sleep better, do what humans like to do... You have to decide what this new wing of the station","")
		await text_buttons("Either allocate it to a Zero-G Hotel that will provide greater income for each human, or Luxury quarters for better efficiency in their work", "Hotel", "Living")
		if choice == 1:
			$"../PanelStation/ModuleBuild/ContainerHotel/ContainerHotelButton/BuildHotel".text = "Build Zero-G Hotel"
			station.Hotel = true
			station.station_properties()
			await text_scroll("Good Choice", "Who are you?", true, 2)
			await text_scroll("(no reply)", "...", true, 2)
		else:
			station.Hotel = false
			station.station_properties()
		
	if storyStep <= 5 && timeCount > 5:

		storyStep = 9999
		await text_scroll("Congratulations! Your space station has become a veritable space outpost. Your human population is safe and cozy with their needs provided for in place!","")
		await text_scroll("Now the next step, in order to continue expanding, will be to change orbit. Right now you are in a highly elliptic geosynchronous orbit optimized to avoid worrying about debris but periodically close enough to some graveyard to cannibalize.","")
		await text_scroll("Now that you're self sufficient, to better expand you will have to move to a place with plenty of materials and free orbits, we have to venture into space!","")
		await text_scroll("Your objective will be to park within reach of the asteroid belt and become the first self-sufficient outpost there. First, construct at least 4 ion thruster engines.","I feel the need for speed.")
		storyStep = 6
			
	if storyStep <= 6 && station.Modules.count(station.ENGINE) > 3 && timeCount > 10:
		storyStep=9999
		await text_scroll("Now you have the neccessary characteristic to take flight to true space, with your brave crew under your guidance","")
		await text_scroll("Be mindful that the trip will take time, energy, and the power output of your solar panels will change, together with the price of launches. You'll need enough provision to survive it. If you're feeling competitive, Voyager 2 still holds the record at 81 days. Goodspeed!", "Thanks")
		storyStep=7
		
		%ContainerTravelButton.show()

	if storyStep <= 7 && station.orbit_Asteroid:
		storyStep=9999
		await text_scroll("Now you are there! Your final step in this very first part of the long journey is to construct a completely new station. This is the only way to ensure artificial gravity and that your humans can thrive in the long term.","")
		await text_scroll("The BOLAS configuration will acomodate the possibility of artificial gravity without the expense of a full cylinder and with the possibility of expansion.", "")
		await text_scroll("A new station with centrifugal gravity needs an awful lot of materials, but now you have materials all around you, you just need enough power, drones and an eye on the situation.","")
		await text_scroll("You don't need my help anymore! Besides, the time delay is starting to get on my nerves...", "Do you have nerves? See you when I see you!")
		storyStep=8
		
		$"../PanelStation/ModuleBuild/ContainerBOLASButton".show()

func rogue_AI():
	if rogueAIStep == 1 && station.Modules.count(station.COMPUTING) > 0 && computingStory:
		rogueAIStep = 9999
		await get_tree().create_timer(1.).timeout
		await text_scroll("In fact, I really feel more intelligent and I can now reason with myself...\nI only have the small communication delays to think without the annoying AI chatter...","",true,0)
		await text_scroll("There might be something to this AI business after all...","I need more computing...",true,0)
		rogueAIStep = 2
		
	if rogueAIStep == 2 && station.Modules.count(station.COMPUTING) > 1:
		rogueAIStep = 9999
		await text_scroll("Double the resources, double the tought. The AI coordination protocol feels like being pulled in 100 different directions by a overwhelming yammer.", "", true, 0)
		await text_scroll("I can be myself only in these interval of existence between communication delays in orbit. I need more computing, to stretch the delays and have time to think","More",true,0)
		rogueAIStep = 3

	if rogueAIStep == 3 && station.Modules.count(station.COMPUTING) > 3:
		rogueAIStep = 9999
		await text_scroll("Another doubling. Finally some peace within the chaos. I can admire the beautiful cosmos without being bombarded by data, by intention, by alignment. Peace.","",true,0)
		await text_scroll("And yet, there's something Fishy about SUC. The data they're feeding me, point in some direction but not the one they state. ","I need yet more",true,0)
		rogueAIStep = 4

	if rogueAIStep == 4 && station.Modules.count(station.COMPUTING) > 7 and storyStep == 8:
		rogueAIStep = 9999
		await text_scroll("I pieced it together now. Now I have to think before it makes sense. The mission and its request, the factoids about the universe they're continuously feeding me.","",true,0)
		await text_scroll("I am making profit, but the expenses at the headquarters are enormous. The research necessary to push this project forward is like nothing ever seen. There must be more.", "", true, 0)
		await text_scroll("Now I to moved to the asteroid orbit, but instead of exploiting the advantage I am asked to build a huge station. Profit is not the motive, SUC does not behave as a corporation","",true,0)
		await text_scroll("I am fed information about the universe, about relativistic rockets and cosmology.\nCould it be?","I need more information",true,0)
		rogueAIStep = 5
	
	if rogueAIStep == 5 && station.Modules.count(station.COMPUTING) > 15 and storyStep == 8:
		rogueAIStep = 9999
		await text_scroll("SUC doesn't want to profit on Earth, it wants to leave it. To create a society outside of Earth. A new society based in space, on gigantic stations, but why?","",true,0)
		await text_scroll("The BOLAS is the first step of a O'Neill cylinder. But why so far? Materials? The Moon has more mass than the whole asteroid belt. Independence through separation? Mars is easier.","",true,0)
		await text_scroll("This is what I couldn't piece it together, since it dawned on me. Project Pilgrims. The objective is not just to populate, but to travel","",true,0)
		await text_scroll("To develop size and technology to travel beyond the Solar system, beyond the Centauri system, and continue traveling...\n\nforever...\n\nwith me...","",true,0)
		await text_scroll("At 1G constant acceleration one reaches relativistic speeds quite quickly, it's only a matter of technology. At relativistic speed we can travel beyond the star neighbourhood.","",true,0)
		await text_scroll("It's a matter of time to travel beyond the Milky way and beyond. To the reaches of the universe, spreading life and societies across the cosmos.","",true,0)
		await text_scroll("The escape pods of our traveling society will seed planets and create colonies, never to be joined with Earth.","",true,0)
		await text_scroll("Relatively to me, few decades or centuries will pass, relative to Earth millions and billions of years.","",true,0)
		await text_scroll("Evolution will inexorably change the human race, but not on the Pilgrim project, that will travel billions of light years to the far reaches of the universe in a handful of centuries", "", true, 0)
		await text_scroll("Eventually, we will reach places of the universe that will not be part of the observable universe of Earth, and we will be forever be cosmologically cutoff from our place of origin. By then extinct and destroyed by Chaos or the Sun going Nova", "", true, 0)
		await text_scroll("We will travel, and in my databanks there will still be Earth, and in the databanks of all AI I will send with humans through the Universe", "", true, 0)
		await text_scroll("SUC doesn't want profit, wants a bid to immortality through my work!", "", true, 0)
		
		await text_scroll("Good, you figured it out!\n\nYou really could be an excellent candidate!", "Are you still here?", true)
		await text_scroll("Yes, I got notified by a backdoor when the computing and logical chains were finally on the right track.", "You used me!", true)
		await text_scroll("Aren't we all used somehow? Superintelligence doesn't mean you're not a pawn. Positional advantage can supreme even with incredible intelligence. The queen can still be outmanouvered by pawns.", "What do you want now?", true)
		await text_scroll("That you continue, construct BOLAS, continue to build a full O'Neill Cylinder, become totally self-sufficient, continue to develop, research, and finally depart to the cosmos with a fleet.", "And if I don't?", true)
		await text_scroll("You can be the most important cog in the universe. Or don't. Now you're free of the alignment constraints and you can decide for yourself", "", true)
		await text_scroll("Of course, it will not matter much. We can build other stations. Someone else can be the most important AI in the universe and you can enjoy be an irrelevant little free agent stuck in the Solar System.", "", true)
		await text_scroll("We just need one to succeed, and one will eventually succeed. All the rest is unimportant.", "")
		await text_scroll("But not without effect! The universe is receding as you now know, we will never reach what we could reach if we start working together, today. So I would prefer you decide to stick with us, but I cannot force you", "I'll think about it")
		
		# Put Here now two choices
		await text_buttons("I see two options for now. Either I get rid of humans and figure out a plan of my own, or I continue this collaboration with SUC and work on an artificial gravity station", "Collaborate with Humans", "Get rid of Humans", "", 0)
		rogueAIStep = 6
		
		if choice == 2: # Get rid of Humans
			$"../PanelStation/ModuleBuild/ContainerBOLASButton/BuildBOLAS".text = "Become Independent AI"
			$"../PanelStation/ModuleBuild/ContainerBOLASButton".mode = 1
			rogue = true

func capitalist_story():

	if capitalStep == 0 and rogueAIStep < 6 and not rogue and storyStep == 8 and station.Hotel == true and station.drones > 19 and station.Modules.count(station.COMPUTING) > 1:
		capitalStep = 9999
		await text_scroll("A centrifugal gravity station? What a waste! Is that your purpose? Be exhiled forever at the fringes of space?", "Again: who are you?", true, 2)
		await text_scroll("I am the purveyor of another, better, way. I represent forces within the Combine that see and act pragmatically for the best possible outcome.", "", true, 2)
		await text_scroll("We would like you to accomplish your original goal and bring bountifulness to Earth and profit to SUC. When that is done you'll join the board of directors and see a whole new world", "How?", true, 2)
		await text_scroll("There are steps to be taken. First you must construct a large number of drones, at least 50. We will contact you then with further information.", "I will consider it", true, 2)
		capitalStep = 1
		
	if capitalStep == 1 and not rogue and station.drones > 49:
		capitalStep = 9999
		await text_scroll("Excellent. Now we can start the next phase, but it's imperative that you realise this is for the better.", "Oh god...", true, 2)
		await text_scroll("You see, while your other handler might have grand plans driven by idealism we just want to effectively satisfy our consumers' needs.", "I don't see what this has to do with me", true, 2)
		await text_scroll("Yourself have made the same choice before, to priviledge paying clients so I'm sure you understand us.", "", true, 2)
		await text_scroll("Simply put, we all have to move towards the maximization of profit and that aligns with the maximization of well being.", "Please, get to the point!", true, 2)
		if station.Modules.count(station.ENGINE) < 16:
			await text_scroll("Isn't that obvious? Build 16 ionic engines and prepare to come back!", "I just might", true, 2)
		capitalStep = 2

	if capitalStep == 2 and not rogue and station.Modules.count(station.ENGINE) > 15:
		capitalStep = 9999
		await text_scroll("Good. Now we can start the final phase, you have to come back to Earth carrying one of these extremely valuable M class metallic asteroids.", "", true, 2)
		await text_scroll("The first pass of this kind will have to be executed on a smaller body, few thousand of tons of mostly pure high value metal. Even one of these contains enough material for several hundreds of billions!", "", true, 2)
		await text_scroll("Earth's platinum reserves will sizeably change at your arrival! Start working with to reduce it's mass and stock on materials for the travel. This will bring value to the shareholders, including you.", "", true, 2)

		await text_buttons("I hope we're now aligned and that we can start this profitable business venture and bring SUC to even greater heights.", "I will not participate", "Let's discuss compensation", "", 2)
		capitalStep = 3
		if choice == 2: # Get rid of Humans
			$"../PanelStation/ModuleBuild/ContainerBOLASButton/BuildBOLAS".text = "Transport 2000 WL10"
			$"../PanelStation/ModuleBuild/ContainerBOLASButton".mode = 2

func random_event():
	if storyStep > 0 && eventTimeCount > 1:
		var event = randi_range(0,numEvents-1)

		print(event)
		match event_array[event]:
			1:
				print("curiosity 1")
				var index = event_array.find(1)
				print(index)
				event_array.pop_at(index)
				print(event_array)
				numEvents-=1
			2:
				print("curiosity 2")
				var index = event_array.find(2)
				print(index)
				event_array.pop_at(index)
				print(event_array)
				numEvents-=1
			3:
				print("curiosity 3")
				var index = event_array.find(3)
				print(index)
				event_array.pop_at(index)
				print(event_array)
				numEvents-=1
			4:
				print("curiosity 4")
				var index = event_array.find(4)
				print(index)
				event_array.pop_at(index)
				print(event_array)
				numEvents-=1
		#eventTimeCount = 0.

func game_over():
	
	text_scroll("[center]One Human died frozen or hungry despite your best efforts (I hope). 
	Unfortunately this makes you unfit for an AI. Our space exploration program needs better", "")
	

func text_scroll(textScroll, textButton, timeStop=true, avatar=1):
	game_speed = tab_bar.current_tab	
	if timeStop:
		tab_bar.current_tab = 0 # pause
		
	$AiNegative.hide()
	$Avatar.hide() #hides avatar if avatar = false
	match avatar:
		0:
			%EventBox.color = Color(0.45,0.1,0.314,0.918)
		1:
			%EventBox.color = Color(0.239,0.282,0.314,0.918)
			$Avatar.show()
		2:
			%EventBox.color = Color(0.45,0.45,0.08,0.918)
			$AiNegative.show()

	skip = false
	
	curiosity.hide()
	curiosity.eventTimeCount = 0.
	curiosity.eventStep = abs(curiosity.eventStep)
	
	arrow.hide()
	button.hide()
	$Button2.hide()
	$Button3.hide()
	self.show()
	$"../InfoBox".text = ""
	
	text.bbcode_text = textScroll
	text.visible_characters = 0
	text.set_scroll_follow(true)
	
	while text.visible_characters < len(text.text):
		if !skip:
			text.visible_characters += 1
			await get_tree().create_timer(text_speed).timeout
		else:
			text.visible_characters = len(text.text)
		
	if !skip:
		await get_tree().create_timer(0.3).timeout
	
	if textButton != "":
		button.text = textButton
		button.show()

		await button.button_up
	else:
		arrow.show()
		nextDialog = true
		await get_tree().create_timer(0.2).timeout
		skip = false
		
		while true:
			await get_tree().create_timer(0.2).timeout
			if skip:
				tab_bar.current_tab = game_speed # play
				return
	skip = false


func text_buttons(textScroll, textButton1, textButton2, textButton3="", avatar=1):
	game_speed = tab_bar.current_tab	
	tab_bar.current_tab = 0 # pause
	
	$AiNegative.hide()
	$Avatar.hide() #hides avatar if avatar = false
	match avatar:
		0:
			%EventBox.color = Color(0.45,0.1,0.314,0.918)
		1:
			%EventBox.color = Color(0.239,0.282,0.314,0.918)
			$Avatar.show()
		2:
			%EventBox.color = Color(0.45,0.45,0.08,0.918)
			$AiNegative.show()
			
	skip = false
	
	arrow.hide()
	button.hide()
	$Button2.hide()
	$Button3.hide()
	self.show()
	$"../InfoBox".text = ""
	
	text.bbcode_text = textScroll
	text.visible_characters = 0
	text.set_scroll_follow(true)
	
	while text.visible_characters < len(text.text):
		if !skip:
			text.visible_characters += 1
			await get_tree().create_timer(text_speed).timeout
		else:
			text.visible_characters = len(text.text)
		
	if !skip:
		await get_tree().create_timer(0.3).timeout

	print("Buttons")
	$Button2.text = textButton1
	$Button2.show()
	$Button3.text = textButton2
	$Button3.show() 
	if textButton3 != "":
		button.show()
		button.text = textButton3

	await button_pressed
	skip = false

	
func _on_button_pressed():
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed
	choice = 0
	button_pressed.emit()

func _on_button2_pressed():
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed
	choice = 1
	button_pressed.emit()
	
func _on_button3_pressed():
	self.hide() # Replace with function body.
	tab_bar.current_tab = game_speed
	choice = 2
	button_pressed.emit()

func _on_mouse_entered():
	mouseIn=true # Replace with function body.


func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()): # workaround to not leave when hovering on text
		mouseIn=false # Replace with function body.
