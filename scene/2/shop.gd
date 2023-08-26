extends MarginContainer


@onready var moulds = $Moulds

var scenery = null
var current = {}


func _ready() -> void:
	current.mould = 0
	fill_moulds()


func fill_moulds() -> void:
	for _i in 3:
		var input = {}
		input.shop = self
		input.restrictions = ["gate"]
		var mould = Global.scene.mould.instantiate()
		moulds.add_child(mould)
		mould.set_attributes(input)


func shift_current_mould(shift_: int) -> void:
	var mould = moulds.get_child(current.mould)
	
	if shift_ != 0:
		mould.switch_active()
	
	current.mould = (current.mould + shift_ + moulds.get_child_count()) % moulds.get_child_count()
	mould = moulds.get_child(current.mould)
	mould.switch_active()
	scenery.field.apply_mould_restrictions(mould)
	
