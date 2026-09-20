class_name CookingItemCard
extends Panel

var drag_payload:Dictionary={}
var enabled:=false

func setup(icon_text:String,title:String,subtitle:String,count:int,color:Color,payload:Dictionary)->void:
	drag_payload=payload;enabled=count>0
	tooltip_text=title+"\n"+subtitle
	var style:=StyleBoxFlat.new();style.bg_color=Color.WHITE if enabled else Color("#ededed");style.border_color=color;style.set_border_width_all(2);style.set_corner_radius_all(12);add_theme_stylebox_override("panel",style)
	if str(payload.get("kind",""))=="spice":
		var detailed:=custom_minimum_size.x>=120.0
		var texture_path:=str(payload.get("texture",""))
		if not texture_path.is_empty() and ResourceLoader.exists(texture_path):
			var texture_icon:=TextureRect.new();texture_icon.name="SpiceTexture";texture_icon.texture=load(texture_path);texture_icon.position=Vector2(5,7) if detailed else Vector2(12,4);texture_icon.size=Vector2(38,38) if detailed else Vector2(43,43);texture_icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;texture_icon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;texture_icon.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(texture_icon)
		else:
			var fallback:=Label.new();fallback.text=icon_text;fallback.position=Vector2(5,7) if detailed else Vector2(12,4);fallback.size=Vector2(38,38) if detailed else Vector2(43,43);fallback.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;fallback.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;fallback.add_theme_font_size_override("font_size",17);fallback.add_theme_color_override("font_color",color.darkened(.2));fallback.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(fallback)
		if detailed:
			var name_label:=Label.new();name_label.name="SpiceName";name_label.text=title;name_label.position=Vector2(45,5);name_label.size=Vector2(88,22);name_label.add_theme_font_size_override("font_size",11);name_label.add_theme_color_override("font_color",GameData.COLORS.ink);name_label.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(name_label)
			var quality_label:=Label.new();quality_label.name="SpiceQuality";quality_label.text="("+subtitle+")";quality_label.position=Vector2(45,25);quality_label.size=Vector2(88,20);quality_label.add_theme_font_size_override("font_size",10);quality_label.add_theme_color_override("font_color",color.darkened(.18));quality_label.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(quality_label)
		var count_label:=Label.new();count_label.text="×"+str(count);count_label.position=Vector2(45,46) if detailed else Vector2(0,45);count_label.size=Vector2(86,20) if detailed else Vector2(67,18);count_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_RIGHT if detailed else HORIZONTAL_ALIGNMENT_CENTER;count_label.add_theme_font_size_override("font_size",12);count_label.add_theme_color_override("font_color",GameData.COLORS.ink);count_label.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(count_label)
		mouse_default_cursor_shape=Control.CURSOR_DRAG if enabled else Control.CURSOR_POINTING_HAND
		return
	var icon:=Label.new();icon.text=icon_text;icon.position=Vector2(0,3);icon.size=Vector2(67,38);icon.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;icon.vertical_alignment=VERTICAL_ALIGNMENT_CENTER;icon.add_theme_font_size_override("font_size",26);icon.add_theme_color_override("font_color",color.darkened(.2));icon.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(icon)
	var count_label:=Label.new();count_label.text=str(count);count_label.position=Vector2(0,42);count_label.size=Vector2(67,20);count_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;count_label.add_theme_font_size_override("font_size",14);count_label.add_theme_color_override("font_color",GameData.COLORS.ink);count_label.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(count_label)
	mouse_default_cursor_shape=Control.CURSOR_DRAG if enabled else Control.CURSOR_POINTING_HAND

signal chosen(data:Dictionary)

func _gui_input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and not event.pressed:chosen.emit(drag_payload)

func _get_drag_data(_position:Vector2)->Variant:
	if not enabled:return null
	var preview:=Label.new();preview.text="  "+drag_payload.get("label","")+"  ";preview.add_theme_font_size_override("font_size",16);preview.add_theme_color_override("font_color",Color.WHITE);preview.add_theme_stylebox_override("normal",StyleBoxEmpty.new());set_drag_preview(preview);return drag_payload
