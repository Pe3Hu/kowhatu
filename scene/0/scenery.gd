extends MarginContainer


@onready var field = $VBox/Field
@onready var shop = $VBox/Shop


func _ready() -> void:
	field.scenery = self
	shop.scenery = self
	
	shop.shift_current_mould(0)
