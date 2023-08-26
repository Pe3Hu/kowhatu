extends MarginContainer


@onready var bg = $BG
@onready var index = $Index
@onready var duress = $Duress


var field = null
var zone = null
var grid = Vector2()
var border = false
var fit = false
var zones = []
var neighbors = {}


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	grid = input_.grid
	border = input_.border


func _ready() -> void:
	index.text = str(Global.num.index.quadrant)
	Global.num.index.quadrant += 1
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	
	custom_minimum_size = Vector2(Global.vec.size.letter2)


func reset_fit() -> void:
	fit = false
	update_color()


func update_color() -> void:
	var color = null
	
	match fit:
		true:
			color = Color.DEEP_PINK
		false:
			color = Color.REBECCA_PURPLE
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color
