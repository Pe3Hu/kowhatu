extends MarginContainer


@onready var quadrants = $HBox/Quadrants
@onready var zones = $HBox/Zones

var scenery = null
var grids = {}
var anchors = []
var current = {}


func _ready() -> void:
	current.anchor = 0
	set_columns()


func set_columns() -> void:
	var n = Global.num.field.n
	quadrants.columns = n
	
	for _i in n:
		for _j in n:
			var input = {}
			input.field = self
			input.grid = Vector2(_j, _i)
			input.border = _i == 0 or _j == 0 or _i == n - 1 or _j == n - 1
			var quadrant = Global.scene.quadrant.instantiate()
			quadrant.set_attributes(input)
			quadrants.add_child(quadrant)
			grids[quadrant.grid] = quadrant
	
	init_neighbors()
	init_zones()


func init_neighbors() -> void:
	for grid in grids:
		var quadrant = grids[grid]
		
		for direction in Global.dict.neighbor.hybrid2:
			var neighbor_grid = direction + grid
			
			if grids.has(neighbor_grid):
				var neighbor = grids[neighbor_grid]
				
				if !quadrant.neighbors.has(neighbor):
					quadrant.neighbors[neighbor] = direction
					neighbor.neighbors[quadrant] = -direction


func init_zones() -> void:
	for _i in Global.num.field.m:
		for _j in Global.num.field.m:
			var input = {}
			input.field = self
			input.grid = Vector2(_j, _i)
			var grid = input.grid * Global.num.field.m + Vector2.ONE
			var quadrant = grids[grid]
			var options = [quadrant]
			
			for neighbor in quadrant.neighbors:
				if !neighbor.border and neighbor.zones.is_empty():
					options.append(neighbor)
			
			input.quadrant = options.pick_random()
			var zone = Global.scene.zone.instantiate()
			zones.add_child(zone)
			zone.set_attributes(input)


func apply_mould_restrictions() -> void:
	var mould = scenery.shop.moulds.get_child(scenery.shop.current.mould)
	reset_quadrants()
	var restrictions = ["non-zone"]
	
	for restriction in mould.restrictions.get_children():
		restrictions.append(restriction.text)
	
	anchors = []
	anchors.append_array(quadrants.get_children())
	
	for _i in range(anchors.size()-1,-1,-1):
		var quadrant = anchors[_i]
		var flag = false
		
		for restriction in restrictions:
			match restriction:
				"non-zone":
					if quadrant.zone != null:
						flag = true
						break
				"on border":
					if !quadrant.border:
						flag = true
						break
				"non-border":
					if quadrant.border:
						flag = true
						break
				"on gate":
					if quadrant.zones.is_empty():
						flag = true
						break
				"on crossroad":
					if quadrant.zones.size() < 2:
						flag = true
						break
				"non-gate":
					if !quadrant.zones.is_empty():
						flag = true
						break
		
		if flag:
			anchors.erase(quadrant)
	
	for quadrant in anchors:
		quadrant.fit = true
		quadrant.update_color()
	
	current.anchor = current.anchor % anchors.size()
	shift_current_anchor(0)


func reset_quadrants() -> void:
	for quadrant in quadrants.get_children():
		quadrant.reset()


func shift_current_anchor(shift_: int) -> void:
	var quadrant = anchors[current.anchor]
	
	if shift_ != 0:
		quadrant.switch_anchor()
		update_reflections()
	
	current.anchor = (current.anchor + shift_ + anchors.size()) % anchors.size()
	quadrant = anchors[current.anchor]
	quadrant.switch_anchor()
	update_reflections()


func update_reflections() -> void:
	var mould = scenery.shop.moulds.get_child(scenery.shop.current.mould)
	var figure = mould.figure.text
	var quadrant = anchors[current.anchor]
	
	for vec in Global.dict.figure[figure]:
		var grid = quadrant.grid + vec
		#print(grid)
		
		if grids.has(grid):
			if grids[grid].zone == null:
				grids[grid].reflection = quadrant.anchor
				grids[grid].update_color()
