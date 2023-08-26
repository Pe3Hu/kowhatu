extends Node


func _ready() -> void:
	Global.node.scenery = Global.scene.scenery.instantiate()
	Global.node.game.get_node("Layer0").add_child(Global.node.scenery)
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_A:
				if event.is_pressed() && !event.is_echo():
					Global.node.scenery.shop.shift_current_mould(-1)
			KEY_D:
				if event.is_pressed() && !event.is_echo():
					Global.node.scenery.shop.shift_current_mould(1)
			KEY_Q:
				if event.is_pressed() && !event.is_echo():
					Global.node.scenery.field.shift_current_anchor(-1)
			KEY_E:
				if event.is_pressed() && !event.is_echo():
					Global.node.scenery.field.shift_current_anchor(1)


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
