extends MarginContainer


@onready var label = $Label


var field = null
var quadrant = null
var grid = Vector2()
var neighbors = {}
var gates = []


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	grid = input_.grid
	quadrant = input_.quadrant
	quadrant.zone = self
	
	set_gates()
	roll_duress()


func set_gates() -> void:
	for direction in Global.dict.neighbor.linear2:
		var neighbor_grid = quadrant.grid + direction
		
		if field.grids.has(neighbor_grid):
			var gate = field.grids[neighbor_grid]
			gate.zones.append(self) 
			gates.append(gate)


func roll_duress() -> void:
	var duress = 1
	
	for gate in gates:
		duress *= Global.arr.duress.pick_random()
	
	quadrant.duress.text = str(duress)
	quadrant.duress.visible = true
