extends Node2D

# Open the paired scene with F6 to compare the maintained portrait silhouettes.
func _ready()->void:
	var canvas:=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
	var background:=ColorRect.new();background.color=Color("eaf5f3");background.size=canvas.size;background.mouse_filter=Control.MOUSE_FILTER_IGNORE;canvas.add_child(background)
	var heading:=Label.new();heading.text="QUIBLETS — UPDATED PORTRAITS";heading.position=Vector2(0,54);heading.size=Vector2(1280,42);heading.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;heading.add_theme_font_size_override("font_size",28);heading.add_theme_color_override("font_color",GameData.COLORS.ink);canvas.add_child(heading)
	var species_indices:=[0,1,2,3,5,6,7]
	for display_index in species_indices.size():
		var species_index:int=species_indices[display_index];var info:Dictionary=GameData.species(species_index)
		var card:=Panel.new();card.position=Vector2(28+display_index*178,150);card.size=Vector2(158,390);canvas.add_child(card)
		var style:=StyleBoxFlat.new();style.bg_color=Color.WHITE;style.border_color=Color(info.color).lightened(.2);style.set_border_width_all(3);style.set_corner_radius_all(24);card.add_theme_stylebox_override("panel",style)
		var portrait:=QuibletPortrait.new();portrait.position=Vector2(9,70);portrait.size=Vector2(140,210);portrait.setup(species_index,.93);card.add_child(portrait)
		var name_label:=Label.new();name_label.text=str(info.name);name_label.position=Vector2(4,302);name_label.size=Vector2(150,32);name_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;name_label.add_theme_font_size_override("font_size",20);name_label.add_theme_color_override("font_color",GameData.COLORS.ink);card.add_child(name_label)
		var type_label:=Label.new();type_label.text=str(info.element);type_label.position=Vector2(4,338);type_label.size=Vector2(150,24);type_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;type_label.add_theme_font_size_override("font_size",14);type_label.add_theme_color_override("font_color",GameData.COLORS.muted);card.add_child(type_label)
