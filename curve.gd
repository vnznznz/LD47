extends Node2D
tool


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var path = $path


# Called when the node enters the scene tree for the first time.
func _ready():
	path.curve = Curve2D.new()
	create_path(path.curve)


func create_path(crv:Curve2D):
	crv.clear_points()
	var next_point = Vector2.ZERO
	crv.add_point(next_point)
	next_point = self.add_straight(crv, next_point, 50)
	next_point = self.add_loop(crv, next_point, 10)
	next_point = self.add_straight(crv, next_point, 50)
	next_point = self.add_loop(crv, next_point, 20)
	next_point = self.add_straight(crv, next_point, 50)

func add_straight(crv:Curve2D, next_point:Vector2, length):
	next_point = next_point + Vector2.RIGHT * length
	crv.add_point(next_point)
	return next_point

func add_loop(crv:Curve2D, next_point:Vector2, s):
	var c = 0.551915024494 * s  # ~MAGIC~ -> https://spencermortensen.com/articles/bezier-circle/
	crv.add_point(next_point + Vector2(2*s, 0), Vector2.ZERO, Vector2(c, 0))
	crv.add_point(next_point + Vector2(3*s, -s), Vector2(0, c), Vector2(0, -c))
	crv.add_point(next_point + Vector2(2*s, -2*s), Vector2(c, 0), Vector2(-c, 0))
	crv.add_point(next_point + Vector2(s, -s), Vector2(0, -c), Vector2(0, c))
	crv.add_point(next_point + Vector2(2*s, 0), Vector2(-c, 0))
	crv.add_point(next_point + Vector2(4*s, 0))
	return next_point + Vector2(4*s, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _draw():
	var points:PoolVector2Array = path.curve.tessellate ()

	var p1 = points[0]
	for idx in range(1, len(points)):
		var p2 = points[idx]
		draw_line(p1, p2, Color.aliceblue, 4, true)
		p1 = p2
