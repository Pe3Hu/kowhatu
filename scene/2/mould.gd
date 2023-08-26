extends MarginContainer


@onready var bg = $BG
@onready var restrictions = $VBox/Restrictions
@onready var figure = $VBox/Figure

var shop = null
var active = false


func _ready() -> void:
	custom_minimum_size = Global.vec.size.mould
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	update_color()


func set_attributes(input_: Dictionary) -> void:
	shop = input_.shop
	figure.text = input_.figure
	
	for text in input_.restrictions:
		var restriction = figure.duplicate()
		restrictions.add_child(restriction)
		restriction.text = text
		restriction.visible = true


func switch_active() -> void:
	active = !active
	update_color()


func update_color() -> void:
	var color = null
	
	match active:
		true:
			color = Color.DODGER_BLUE
		false:
			color = Color.SKY_BLUE
	
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = color
