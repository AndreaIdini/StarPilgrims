extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_label_humans_mouse_entered():
	self.text = "Your adorable humans, the source of your primary objectives and joy, not to mention credits! Never forget to keep them warm and fed. \n \n" + \
	"Matter upkeep: " + str($"../PanelStation".humans_matter_upkeep) + " kg/d \n" +\
	"Energy upkeep: " + str($"../PanelStation".humans_energy_upkeep) + " kW\n" +\
	"Credits rent: " + str($"../PanelStation".humans_rent)

func _on_label_drone_mouse_entered():
	self.text = "Your little worker drones, give them energy and they'll fetch matter from your orbital neighbourhood with great care. \n \n" + \
	"Matter harvesting: " + str($"../PanelStation".drones_matter_mining) + " kg/d \n" +\
	"Energy upkeep: " + str($"../PanelStation".drones_energy_upkeep) + " kW"

func _on_mouse_entered():
	self.text = ""
	pass # Replace with function body.

func _on_container_solar_panel_mouse_entered():
	self.text = %ContainerSolarPanel.update_description()

func _on_container_battery_mouse_entered():
	self.text = %ContainerBattery.update_description()

func _on_container_living_mouse_entered():
	self.text = %ContainerLiving.update_description()

func _on_container_computing_mouse_entered():
	self.text = %ContainerComputing.update_description()

func _on_container_drone_bay_mouse_entered():
	self.text = %ContainerDroneBay.update_description()

func _on_container_hotel_mouse_entered():
	self.text = %ContainerHotel.update_description()

func _on_container_engine_mouse_entered():
	self.text = %ContainerEngine.update_description()

func _on_container_factory_mouse_entered():
	self.text = %ContainerFactory.update_description()

func _on_container_bolas_button_mouse_entered():
	self.text = $"../PanelStation/ModuleBuild/ContainerBOLASButton".update_description()

func _on_container_travel_button_mouse_entered():
	self.text = %ContainerTravelButton.description
	
func _on_container_launch_h_mouse_entered():
	self.text = $"../LaunchBuild".description_humans

func _on_container_launch_m_mouse_entered():
	self.text = $"../LaunchBuild".description_matter
	
func _on_container_build_drone_mouse_entered():
	self.text = $"../LaunchBuild".description_drone
