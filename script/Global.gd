extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.duress = [2, 3]
	arr.restriction = ["non-zone","on border","non-border","on gate","on crossroad","non-gate"]


func init_num() -> void:
	num.index = {}
	num.index.quadrant = 0
	
	num.field = {}
	num.field.m = 3
	num.field.n = pow(num.field.m, 2)
	
	num.quadrant = {}
	num.quadrant.duress = 24


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal2 = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	
	dict.neighbor.hybrid2 = []
	
	for _i in dict.neighbor.linear2.size():
		dict.neighbor.hybrid2.append(dict.neighbor.linear2[_i])
		dict.neighbor.hybrid2.append(dict.neighbor.diagonal2[_i])
	
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	init_figures()


func init_figures() -> void:
	var indexs = {}
	indexs["dog"] = [0]
	indexs["cat"] = [1]
	indexs["boar"] = [0,0]
	indexs["horse"] = [0,1]
	indexs["elephant"] = [1,1]
	dict.figure = {}
	
	for figure in indexs:
		dict.figure[figure] = []
		
		for _i in dict.neighbor.linear2.size():
			var grid = Vector2()
			
			for index in indexs[figure]:
				var _j = (index + _i * 2) % dict.neighbor.hybrid2.size()
				grid += dict.neighbor.hybrid2[_j]
			
			dict.figure[figure].append(grid)
	
	indexs["horse"] = [0,7]
	
	for _i in dict.neighbor.linear2.size():
		var grid = Vector2()
		
		for index in indexs["horse"]:
			var _j = (index + _i * 2) % dict.neighbor.hybrid2.size()
			grid += dict.neighbor.hybrid2[_j]
		
		dict.figure["horse"].append(grid)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.scenery = load("res://scene/0/scenery.tscn")
	scene.field = load("res://scene/1/field.tscn")
	scene.quadrant = load("res://scene/1/quadrant.tscn")
	scene.zone = load("res://scene/1/zone.tscn")
	scene.shop = load("res://scene/2/shop.tscn")
	scene.mould = load("res://scene/2/mould.tscn")
	#
	pass


func init_vec():
	vec.size = {}
	
	vec.size.rect = Vector2(25, 25)
	vec.size.letter = Vector2(23, 23)
	vec.size.letter2 = Vector2(31, 31)
	vec.size.letter3 = Vector2(46, 46)
	vec.size.digital2 = Vector2(35, 35)
	
	vec.size.mould = Vector2(50, 50)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()
