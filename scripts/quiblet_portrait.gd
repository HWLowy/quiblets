class_name QuibletPortrait
extends Control

var species_index := 0
var mood := "happy"
var scale_factor := 1.0
var selected := false
var hp_ratio := 1.0
var facing := 1.0

func setup(index: int, new_scale: float = 1.0) -> void:
	species_index = index
	scale_factor = new_scale
	queue_redraw()

func _draw() -> void:
	var s := GameData.species(species_index)
	var c: Color = s.color
	var a: Color = s.accent
	var center := size * 0.5
	var r: float = min(size.x, size.y) * 0.31 * scale_factor
	if selected:
		draw_circle(center, r * 1.34, Color(1, 0.78, 0.25, 0.24))
		draw_arc(center, r * 1.34, 0, TAU, 40, GameData.COLORS.gold, 3.0)
	# Soft shadow.
	draw_ellipse(center + Vector2(0, r * 0.78), r * 0.82, r * 0.27, Color(0.15,0.2,0.22,0.16))
	var species_name := str(s.name)
	# Arms and flame peaks sit behind the body so their joins read as one smooth
	# silhouette, matching the maintained 3D models.
	if species_name in ["Spriggle", "Frondle"]:
		draw_vine_arms(center, r, c, a, 1.0)
	if species_name in ["Sparko", "Scorchit"]:
		draw_flame_crown(center, r, c, 0.95 if species_name == "Sparko" else 1.18)
	# Species silhouettes.
	var custom_shape_replaces_standard := species_name in ["Spriggle", "Frondle", "Bloomie", "Scorchit"]
	match s.shape if not custom_shape_replaces_standard else "custom":
		"ears":
			draw_colored_polygon(PackedVector2Array([center+Vector2(-r*.7,-r*.45),center+Vector2(-r*.52,-r*1.25),center+Vector2(-r*.12,-r*.62)]), c)
			draw_colored_polygon(PackedVector2Array([center+Vector2(r*.7,-r*.45),center+Vector2(r*.52,-r*1.25),center+Vector2(r*.12,-r*.62)]), c)
		"fins":
			draw_colored_polygon(PackedVector2Array([center+Vector2(-r*.72,-r*.15),center+Vector2(-r*1.28,-r*.65),center+Vector2(-r*1.05,r*.2)]), a)
			draw_colored_polygon(PackedVector2Array([center+Vector2(r*.72,-r*.15),center+Vector2(r*1.28,-r*.65),center+Vector2(r*1.05,r*.2)]), a)
		"horn":
			draw_colored_polygon(PackedVector2Array([center+Vector2(-r*.25,-r*.72),center+Vector2(0,-r*1.35),center+Vector2(r*.25,-r*.72)]), a)
		"tuft", "crest":
			var pts := PackedVector2Array([center+Vector2(-r*.55,-r*.62),center+Vector2(-r*.2,-r*1.2),center+Vector2(0,-r*.72),center+Vector2(r*.35,-r*1.3),center+Vector2(r*.55,-r*.58)])
			draw_colored_polygon(pts, a)
		"fists":
			for fx in [-1.0, 1.0]:
				var fist := center + Vector2(fx*r*1.12, -r*.1)
				draw_circle(fist, r*.34, a)
				draw_arc(fist, r*.34, 0, TAU, 20, c, 2.0)
				for knuckle in range(3):
					draw_circle(fist+Vector2(fx*r*.24,(knuckle-1)*r*.18), r*.06, c)
		"puff":
			for i in 7:
				var ang := TAU*i/7.0 - PI*.5
				draw_circle(center+Vector2(cos(ang),sin(ang))*r*1.02, r*.32, Color(a,.9))
		"boulder":
			for off in [Vector2(-r*.5,-r*.55),Vector2(r*.1,-r*.85),Vector2(r*.55,-r*.5)]:
				draw_circle(center+off, r*.4, a)
		"web":
			for fx in [-1.0,1.0]:
				for k in 3:
					draw_line(center, center+Vector2(fx*r*(.9+k*.15),-r*.3+k*r*.45), a, 2.5)
		"gloop":
			for off in [Vector2(-r*.5,-r*.5),Vector2(r*.2,-r*.75),Vector2(r*.55,-r*.4)]:
				draw_circle(center+off, r*.3, a)
				draw_circle(center+off+Vector2(0,r*.34), r*.14, a)
		"balloon":
			for i in 8:
				var ang := TAU*i/8.0
				var base := center+Vector2(cos(ang),sin(ang))*r*.98
				draw_colored_polygon(PackedVector2Array([base-Vector2(cos(ang+.4),sin(ang+.4))*r*.12,base-Vector2(cos(ang-.4),sin(ang-.4))*r*.12,center+Vector2(cos(ang),sin(ang))*r*1.32]), a)
		"spikes":
			for i in 5:
				var sx := (i-2)*r*.42
				draw_colored_polygon(PackedVector2Array([center+Vector2(sx-r*.16,-r*.5),center+Vector2(sx,-r*1.25),center+Vector2(sx+r*.16,-r*.5)]), a)
		"beak":
			draw_colored_polygon(PackedVector2Array([center+Vector2(-r*.5,-r*.35),center+Vector2(-r*.35,-r*1.15),center+Vector2(r*.05,-r*.55)]), c)
			draw_colored_polygon(PackedVector2Array([center+Vector2(-r*.32,-r*.72),center+Vector2(r*.28,-r*.72),center+Vector2(-r*.02,-r*.4)]), a)
		"twinbeak":
			for fx in [-1.0,1.0]:
				draw_colored_polygon(PackedVector2Array([center+Vector2(fx*r*.24,-r*.4),center+Vector2(fx*r*.5,-r*1.2),center+Vector2(fx*r*.62,-r*.5)]), c)
				draw_colored_polygon(PackedVector2Array([center+Vector2(fx*r*.34,-r*.78),center+Vector2(fx*r*.72,-r*.7),center+Vector2(fx*r*.5,-r*.5)]), a)
		"moon":
			draw_circle(center+Vector2(r*.28,-r*.62),r*.46,a)
			draw_circle(center+Vector2(r*.43,-r*.72),r*.37,c)
		"shell":
			draw_circle(center+Vector2(-r*.4,-r*.05),r*.72,a)
			draw_arc(center+Vector2(-r*.4,-r*.05),r*.4,0,TAU,24,c,3.0)
	# Body and belly. Plip and Swellit share the approved water-drop outline.
	if str(s.get("family", "")) == "plip":
		draw_colored_polygon(water_drop_outline(center, r), c)
	else:
		draw_circle(center, r, c)
	draw_circle(center+Vector2(0,r*.22), r*.64, c.lightened(.08))
	if s.shape == "tail":
		draw_circle(center+Vector2(r*.88,r*.18),r*.34,a)
		draw_circle(center+Vector2(r*1.05,r*.02),r*.18,GameData.COLORS.gold)
	match species_name:
		"Spriggle": draw_leaf_hat(center, r, c.darkened(.18), 1.0)
		"Frondle": draw_leaf_hat(center, r, c.darkened(.20), 1.0)
		"Bloomie": draw_flower_hat(center, r)
	# Face.
	var eye_y: float = center.y-r*.18
	var eye_dx: float = r*.32
	for ex in [-eye_dx, eye_dx]:
		if mood == "hurt":
			draw_line(Vector2(center.x+ex-r*.09,eye_y-r*.05),Vector2(center.x+ex+r*.09,eye_y+r*.05),GameData.COLORS.ink,2.5)
		else:
			draw_circle(Vector2(center.x+ex,eye_y),r*.085,GameData.COLORS.ink)
			draw_circle(Vector2(center.x+ex-r*.025,eye_y-r*.03),r*.026,Color.WHITE)
	if mood == "happy":
		draw_arc(center+Vector2(0,r*.04),r*.2,0.18,PI-0.18,14,GameData.COLORS.ink,2.5)
	elif mood == "determined":
		draw_line(center+Vector2(-r*.16,r*.12),center+Vector2(r*.16,r*.12),GameData.COLORS.ink,2.5)
	else:
		draw_arc(center+Vector2(0,r*.28),r*.16,PI+0.2,TAU-0.2,10,GameData.COLORS.ink,2.5)
	# Tiny cheek marks.
	draw_circle(center+Vector2(-r*.55,r*.06),r*.1,Color(a,0.55))
	draw_circle(center+Vector2(r*.55,r*.06),r*.1,Color(a,0.55))

func cubic_point(a:Vector2,b:Vector2,c:Vector2,d:Vector2,t:float)->Vector2:
	var inverse:=1.0-t
	return a*inverse*inverse*inverse+b*3.0*inverse*inverse*t+c*3.0*inverse*t*t+d*t*t*t

func water_drop_outline(center:Vector2,r:float)->PackedVector2Array:
	var points:=PackedVector2Array()
	var top:=center+Vector2(0,-r*1.24)
	var left_mid:=center+Vector2(-r,r*.12)
	var bottom:=center+Vector2(0,r)
	for step in 13:
		var t:=float(step)/12.0
		points.append(cubic_point(top,center+Vector2(-r*.10,-r*.92),center+Vector2(-r*1.08,-r*.66),left_mid,t))
	for step in range(1,13):
		var t:=float(step)/12.0
		points.append(cubic_point(left_mid,center+Vector2(-r*.94,r*.70),center+Vector2(-r*.46,r),bottom,t))
	for step in range(1,13):
		var t:=float(step)/12.0
		points.append(cubic_point(bottom,center+Vector2(r*.46,r),center+Vector2(r*.94,r*.70),center+Vector2(r,r*.12),t))
	for step in range(1,13):
		var t:=float(step)/12.0
		points.append(cubic_point(center+Vector2(r,r*.12),center+Vector2(r*1.08,-r*.66),center+Vector2(r*.10,-r*.92),top,t))
	return points

func ellipse_polygon(center:Vector2,radius_x:float,radius_y:float,rotation:float)->PackedVector2Array:
	var points:=PackedVector2Array()
	for step in 20:
		var angle:=TAU*float(step)/20.0
		points.append(center+Vector2(cos(angle)*radius_x,sin(angle)*radius_y).rotated(rotation))
	return points

func draw_leaf(center:Vector2,radius_x:float,radius_y:float,rotation:float,color:Color)->void:
	draw_colored_polygon(ellipse_polygon(center,radius_x,radius_y,rotation),color)

func draw_vine_arms(center:Vector2,r:float,body_color:Color,leaf_color:Color,feature_scale:float)->void:
	var vine_color:=body_color.darkened(.20)
	for side in [-1.0,1.0]:
		var points:=PackedVector2Array()
		var start:=center+Vector2(side*r*.62,-r*.02)
		var one:=center+Vector2(side*r*(.76+.10*feature_scale),-r*.20)
		var two:=center+Vector2(side*r*(1.00+.18*feature_scale),r*.30)
		var finish:=center+Vector2(side*r*(1.05+.25*feature_scale),r*.10)
		for step in 13:points.append(cubic_point(start,one,two,finish,float(step)/12.0))
		draw_polyline(points,vine_color,r*.13*feature_scale,true)
		draw_leaf(finish+Vector2(side*r*.08,0),r*.25*feature_scale,r*.12*feature_scale,side*.45,leaf_color)

func draw_leaf_hat(center:Vector2,r:float,color:Color,feature_scale:float)->void:
	var crown:=center+Vector2(0,-r*.80)
	for angle in [-2.75,-2.15,-1.57,-.95,-.38]:
		var direction:=Vector2(cos(angle),sin(angle))
		var leaf_center:=crown+Vector2(direction.x*r*.18,direction.y*r*.08)*feature_scale
		draw_leaf(leaf_center,r*.32*feature_scale,r*.105*feature_scale,angle,color)
	var stem_start:=crown+Vector2(r*.02,-r*.03)
	var stem_end:=crown+Vector2(r*.10,-r*.43*feature_scale)
	draw_line(stem_start,stem_end,color,r*.11*feature_scale,true)
	draw_circle(stem_end,r*.055*feature_scale,color)

func draw_flower_hat(center:Vector2,r:float)->void:
	var flower_center:=center+Vector2(0,-r*.88)
	var petal_color:=Color("f2a5c6")
	for petal_index in 6:
		var angle:=TAU*float(petal_index)/6.0
		var direction:=Vector2(cos(angle),sin(angle))
		var petal_center:=flower_center+Vector2(direction.x*r*.22,direction.y*r*.09)
		draw_leaf(petal_center,r*.25,r*.095,angle,petal_color)
	draw_ellipse(flower_center,r*.15,r*.09,Color("ffd94f"))

func flame_peak_outline(base:Vector2,height:float,width:float,tilt:float)->PackedVector2Array:
	var points:=PackedVector2Array()
	var left:=Vector2(-width,0)
	var tip:=Vector2(0,-height)
	var right:=Vector2(width,0)
	for step in 9:
		var t:=float(step)/8.0
		points.append(base+cubic_point(left,Vector2(-width*1.02,-height*.34),Vector2(-width*.30,-height*.78),tip,t).rotated(tilt))
	for step in range(1,9):
		var t:=float(step)/8.0
		points.append(base+cubic_point(tip,Vector2(width*.28,-height*.76),Vector2(width*1.02,-height*.34),right,t).rotated(tilt))
	return points

func draw_flame_crown(center:Vector2,r:float,color:Color,feature_scale:float)->void:
	var peaks:=[
		{"x":-.31,"height":.50,"width":.22,"tilt":.18},
		{"x":0.0,"height":.78,"width":.27,"tilt":-.03},
		{"x":.31,"height":.62,"width":.23,"tilt":-.16},
	]
	for peak in peaks:
		var base:=center+Vector2(float(peak.x)*r*feature_scale,-r*.62)
		draw_colored_polygon(flame_peak_outline(base,float(peak.height)*r*feature_scale,float(peak.width)*r*feature_scale,float(peak.tilt)),color)
