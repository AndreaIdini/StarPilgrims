extends Line2D

var num_points = 100
var length = 20
var freq = 200.

var time = 0.

# Called when the node enters the scene tree for the first time.
func _ready():
	var array = []
		
	points = array


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var array = []
	var time_multi = %TabBar.current_tab*%TabBar.current_tab
	delta = delta*time_multi
	time += delta
	
	for i in range(num_points):
		var x = length*float(i)/float(num_points)
		array.append(Vector2(
				x,
				25. - 10.*$"../../..".solar_power(1.,x/10.+time)
				)) 
		
	points = array
