extends Panel
var garden
var index:=0
var drag_started:=false
func _can_drop_data(_position:Vector2,data:Variant)->bool:
	return data is Dictionary and data.get("kind","")=="ingredient" and garden.can_drop_slot(data,index)
func _drop_data(_position:Vector2,data:Variant)->void:
	garden.drop_slot(data,index);garden.call_deferred("draw_menu")
func _get_drag_data(_position:Vector2)->Variant:
	var payload:Dictionary=garden.slot_drag_payload(index)
	if payload.is_empty():return null
	drag_started=true
	var preview:=Label.new();preview.text="  "+str(payload.name)+"  ";preview.add_theme_font_size_override("font_size",16);preview.add_theme_color_override("font_color",Color.WHITE);set_drag_preview(preview)
	return payload
func _gui_input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_RIGHT:
		garden.remove_slot(index);garden.call_deferred("draw_menu")
func _notification(what:int)->void:
	if what==NOTIFICATION_DRAG_END and drag_started:
		drag_started=false
		if not is_drag_successful():garden.remove_slot(index)
		garden.call_deferred("draw_menu")
