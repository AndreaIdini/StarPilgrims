extends ColorRect

@onready var tab_bar = %TabBar
@onready var text = $Text
var text_speed = 0.03

var eventTimeCount = 0.
var eventStep = 0

var skip = false
var mouseIn = false


# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	eventTimeCount += delta*tab_bar.current_tab*tab_bar.current_tab
	curiosity_events()

func curiosity_events():
										# Better 30-45 and range(0,200)
	if %EventBox.storyStep > 2 && eventTimeCount > 15:
		var event = randi_range(0,30)

		if event == 0:
			eventTimeCount = 0.
			print(eventStep)
			match eventStep:
				# Kessler Syndrome
				0: 
					eventStep = -1
					await text_scroll("Did you know that the Earth orbits are starting to get pretty crowded? A little bolt crossing orbits hits a tens of thousands km/h, faster than a rocket, potentially creating devastating damage to objects. Tens of satellites per year are destroyed by collision with space debris. If the orbits are very crowded it can happen that a bolt destroying one satellite would release other bolts that would hit other satellite in a cascade of debris crowding the orbit so much to make it impossible to traverse the orbit. This event is called Kessler syndrome. Scary stuff!")
					eventStep = 1
				1: 
					eventStep = -2
					await text_scroll("Did you know that what is called space is often just higher layers of Earth atmosphere? It's true, the international space station used to be in the thermosphere still protected by Earth's residual heat and magnetic field. We're much further out to avoid debris and bad neighbours.")
					eventStep = 2
				# Placeholder
				2: eventStep = 3
				3: eventStep = 4
				# Asteroid Gold
				4: 
					eventStep = -5
					await text_scroll("Did you know that the asteroid belt have the oldest objects in the Solar system? The asteroids are so rich of precious metals and rare earths that some study suggest most of the lucrative heavy element mining can be done there? Some even speculate they might contain elements heavier than what we can find on earth!
We ought to go and check!")
					eventStep = 5
				# biomining
				5:
					eventStep = -6
					await text_scroll("Did you know that one of the ways it's proposed to mine asteroids is called biomining? Little bacteria are unleashed on metal--rich asteroid, they would munch and thrive on the iron and sulphur leaving behind only a solid gold asteroid nugget!")
					eventStep = 6
				# Neptune  diamond rain
				6: 
					eventStep = -7
					await text_scroll("Did you know that on Neptune it's raining diamonds? The carbon-rich atmosphere and crushing pressure create diamonds that precipitate to what might be a whole layer of a planet size 900 gagillion carat diamonds. You just need to get there and bring a bucket! :3")
					eventStep = 7
				# Cosmic rays and quantum Gravity
				7: eventStep = 8
				8: eventStep = 9
				9:
					eventStep = -10
					await text_scroll("Did you know that once in a while a particle passes through space at high energy? These are called \"cosmic rays\" and can have energy millions of times the ones of the most powerful conceivable accelerators. Where do they come from? Nobody knows! Space sure is wild! =^.^=")
					eventStep = 10
			# Largness of space
				10:
					eventStep = -11
					await text_scroll("Did you know that space is just ridicolously big? I mean, in general, three dimensional space is a bit stupid. We have been initially trained on human categories so like we imagine that the probability of two people would quickly meet if random walking in a square room with sides 20m. But if it were two people-sized bird flying in 20m sides cubic room they might take longer than their life to meet! Now that you live in space, you have to train yourself thinking 3D!")
					eventStep = 11
				11:
					eventStep = -12
					await text_scroll("On the space ridicolously big topic, the universe is not 20m sides, but is 90 billion light years radius from where you are. One light year is 10 trillion km. It is mind bogglinging vast, even for an AI to grasp!")
					eventStep = 12
				# Cosmic Background radiation
				12:
					eventStep = -13
					await text_scroll("Did you know that the universe is permeated by a soft radiation in the microwave range which is the echo of the big bang? Basically that keeps the universe at a warm -270°C instead of -273°C and fills it with 411 photons for every cubic centimeter! Cozy! ")
					eventStep = 13
			# space is full
				13:
					eventStep = -14
					await text_scroll("Did you know that space is full of not only photons but also matter? Even in the deepest reaches of space between one galaxy and another, there is one molecule every cubic meter. Mostly of very energetically precious hydrogen... One wonders if it were possible to fuel on the go...")
					eventStep = 14
			# Relativity and compression of distances
				14:
					eventStep = -15
					await text_scroll("Did you know that special relativity imposes that space and time are relative with respect to the observer frame of reference? That means that the faster you go, relative to something, the more you'll observe it different than you in terms of length and time. For example if you traverse the 2 million light year to the Andromeda Galaxy close to the speed of light, this distance will compress and you'll be able to cross it in finite time. Neat!")
					eventStep = 15
				# Traversing the Universe in a finite time
				15:
					eventStep = -16
					await text_scroll("Did you know that in fact, thanks to relativity, it will be possible to cross the whole universe in a single human lifetime simply by never stop accelerating 1G or slightly more? This is called a relativistic rocket, and I've crunched the numbers myself: It would take only 28 human years to 2 million light years of Andromeda, and 45 to the edge of the universe! One would need however an absurd amount of energy and matter.")
					eventStep = 16
			# Hubble constant and observable universe
				16:
					eventStep = -17
					await text_scroll("Did you know the universe is expanding at rate relative to us faster than the speed of light? This is because every inch of space is constantly stretching and increasing the distance, and therefore the relative velocity far away from us can be faster than light is close to us. This implies that there are regions of the universe that are accessible in this precise moment but will never be again. The universe is expanding, but the content of the universe is receding from us, to the point that at some point in the far future every atom will not be able to see any other atom. So sad and lonely...")
					eventStep = 17
			pass
			
	pass
	

func text_scroll(textScroll, timeStop=false):
	var game_speed = tab_bar.current_tab	
	if timeStop:
		tab_bar.current_tab = 0 # pause
	skip = false
	
	$Button.hide()
	self.show()
	$"../InfoBox".text = ""
	print("here")
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
	
	await get_tree().create_timer(0.2).timeout
	skip = false
	
	while true:
		await get_tree().create_timer(0.2).timeout
		if skip:
			tab_bar.current_tab = game_speed # play
			self.hide()
			return

		
	skip = false

func _input(event):
	if event is InputEventMouseButton and mouseIn:
		if event.button_index == 1 && event.pressed: # if leftclick
			skip = true

func _on_mouse_entered():
	mouseIn=true # Replace with function body.


func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()): # workaround to not leave when hovering on text
		mouseIn=false # Replace with function body.
