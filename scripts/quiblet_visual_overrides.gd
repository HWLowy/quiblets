class_name QuibletVisualOverrides
extends RefCounted

# Family-owned visual layer for the iPad edition. Keeping these procedural
# models separate from the base builder makes upstream gameplay merges much
# less likely to disturb an approved silhouette.

static func build_custom_body(model, species: Dictionary) -> bool:
	if str(species.get("family", "")) != "plip":
		return false
	water_drop_body(model, model.body_material)
	mark(model, "plip_water_drop_body")
	return true

static func apply_species_features(model, species: Dictionary) -> bool:
	var species_name := str(species.get("name", ""))
	match species_name:
		"Spriggle":
			var spriggle_leaf: StandardMaterial3D = model.material(species.color.darkened(0.18))
			leaf_stem_hat(model, spriggle_leaf, 0.78)
			vine_arms(model, spriggle_leaf, model.accent_material, 0.78)
			mark(model, "spriggle_leaf_crown_and_vines")
			return false # Keep its original ears too.
		"Frondle":
			var frondle_leaf: StandardMaterial3D = model.material(species.color.darkened(0.20))
			leaf_stem_hat(model, frondle_leaf, 1.0)
			vine_arms(model, frondle_leaf, model.accent_material, 1.0)
			mark(model, "frondle_leaf_crown_and_vines")
			return true
		"Bloomie":
			flower_hat(model)
			mark(model, "bloomie_healing_bloom_hat")
			return true
		"Sparko":
			flame_peaks(model, 0.78)
			mark(model, "sparko_flame_crown")
			return false # Keep its original tail too.
		"Scorchit":
			flame_peaks(model, 1.0)
			mark(model, "scorchit_flame_crown")
			return true
	return false

static func mark(model, feature_name: String) -> void:
	var applied: Array = model.get_meta("visual_overrides", [])
	applied.append(feature_name)
	model.set_meta("visual_overrides", applied)

static func water_drop_body(model, mat: Material) -> void:
	var profile := PackedVector2Array([
		Vector2(0.00, 0.05),
		Vector2(0.08, 0.25),
		Vector2(0.18, 0.40),
		Vector2(0.32, 0.54),
		Vector2(0.50, 0.62),
		Vector2(0.68, 0.64),
		Vector2(0.84, 0.61),
		Vector2(0.98, 0.55),
		Vector2(1.12, 0.45),
		Vector2(1.24, 0.32),
		Vector2(1.34, 0.20),
		Vector2(1.42, 0.09),
		Vector2(1.47, 0.01),
	])
	var surface := revolved_surface(profile, 16, 0.86)
	var part: MeshInstance3D = model.mesh_part(surface, Vector3.ZERO, mat)
	part.name = "VisualOverrideWaterDropBody"

static func flower_hat(model) -> void:
	# The Healing Bloom's six pink petals and yellow center, laid flat like a hat.
	var stem := CylinderMesh.new()
	stem.top_radius = 0.055
	stem.bottom_radius = 0.075
	stem.height = 0.20
	stem.radial_segments = 10
	var stem_part = model.mesh_part(stem, Vector3(0.0, 1.29, -0.02), model.material(Color("5f9f57")))
	stem_part.name = "VisualOverrideBloomieStem"
	stem_part.rotation.z = -0.12
	var center := Vector3(-0.01, 1.39, 0.02)
	for petal_index in 6:
		var angle := TAU * float(petal_index) / 6.0
		var offset := Vector3(cos(angle) * 0.23, 0.0, sin(angle) * 0.23)
		var petal = model.sphere(center + offset, Vector3(0.34, 0.10, 0.18), model.accent_material)
		petal.rotation.y = -angle
		petal.name = "VisualOverrideBloomiePetal%d" % petal_index
	var flower_center = model.sphere(center + Vector3(0.0, 0.055, 0.0), Vector3(0.25, 0.14, 0.25), model.material(Color("ffd94f"), 0.7))
	flower_center.name = "VisualOverrideBloomieCenter"

static func leaf_stem_hat(model, leaf_mat: Material, crown_scale: float) -> void:
	for leaf_index in 5:
		var angle := TAU * float(leaf_index) / 5.0 + 0.3
		var offset := Vector3(cos(angle) * 0.23 * crown_scale, 0.0, sin(angle) * 0.18 * crown_scale)
		var leaf = model.sphere(Vector3(0.0, 1.29, 0.0) + offset, Vector3(0.48, 0.13, 0.24) * crown_scale, leaf_mat)
		leaf.rotation.y = -angle
		leaf.rotation.z = cos(angle) * 0.12
		leaf.name = "VisualOverrideLeafCrown%d" % leaf_index
	var stem_height := 0.36 * crown_scale
	var stem := CylinderMesh.new()
	stem.top_radius = 0.055 * crown_scale
	stem.bottom_radius = 0.085 * crown_scale
	stem.height = stem_height
	stem.radial_segments = 10
	var stem_part = model.mesh_part(stem, Vector3(0.04 * crown_scale, 1.28 + stem_height * 0.5, -0.02), leaf_mat)
	stem_part.rotation.z = -0.18
	stem_part.name = "VisualOverrideLeafStem"

static func vine_arms(model, vine_mat: Material, leaf_mat: Material, arm_scale: float) -> void:
	for side in [-1.0, 1.0]:
		var controls := PackedVector3Array([
			Vector3(side * 0.55, 0.78, 0.02),
			Vector3(side * (0.55 + 0.16 * arm_scale), 0.78 + 0.16 * arm_scale, 0.08 * arm_scale),
			Vector3(side * (0.55 + 0.36 * arm_scale), 0.78 - 0.15 * arm_scale, 0.16 * arm_scale),
			Vector3(side * (0.55 + 0.49 * arm_scale), 0.78 + 0.01 * arm_scale, 0.23 * arm_scale),
		])
		var vine = curved_vine(model, controls, 0.060 * (0.82 + 0.18 * arm_scale), vine_mat)
		vine.name = "VisualOverrideVineArmLeft" if side < 0.0 else "VisualOverrideVineArmRight"
		var tip_scale := 0.78 + 0.22 * arm_scale
		var tip_leaf = model.sphere(controls[-1] + Vector3(side * 0.06 * arm_scale, 0.03, 0.0), Vector3(0.30, 0.15, 0.20) * tip_scale, leaf_mat)
		tip_leaf.rotation.z = side * 0.45
		tip_leaf.name = "VisualOverrideVineTipLeft" if side < 0.0 else "VisualOverrideVineTipRight"

static func curved_vine(model, controls: PackedVector3Array, radius: float, mat: Material) -> MeshInstance3D:
	var curve_steps := 12
	var radial_segments := 10
	var rings: Array = []
	for step in curve_steps + 1:
		var t := float(step) / float(curve_steps)
		var inverse := 1.0 - t
		var point := controls[0] * inverse * inverse * inverse + controls[1] * 3.0 * inverse * inverse * t + controls[2] * 3.0 * inverse * t * t + controls[3] * t * t * t
		var tangent := (controls[1] - controls[0]) * 3.0 * inverse * inverse + (controls[2] - controls[1]) * 6.0 * inverse * t + (controls[3] - controls[2]) * 3.0 * t * t
		tangent = tangent.normalized()
		var side_axis := tangent.cross(Vector3.UP)
		if side_axis.length_squared() < 0.001:
			side_axis = Vector3.FORWARD
		side_axis = side_axis.normalized()
		var up_axis := side_axis.cross(tangent).normalized()
		var organic_radius := radius * (0.94 + sin(t * PI) * 0.16)
		var ring := PackedVector3Array()
		for segment in radial_segments:
			var angle := TAU * float(segment) / float(radial_segments)
			ring.append(point + (side_axis * cos(angle) + up_axis * sin(angle)) * organic_radius)
		rings.append(ring)
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_smooth_group(0)
	for step in curve_steps:
		for segment in radial_segments:
			var next_segment := (segment + 1) % radial_segments
			var lower_a: Vector3 = rings[step][segment]
			var lower_b: Vector3 = rings[step][next_segment]
			var upper_a: Vector3 = rings[step + 1][segment]
			var upper_b: Vector3 = rings[step + 1][next_segment]
			for vertex in [lower_a, upper_b, upper_a, lower_a, lower_b, upper_b]:
				surface.add_vertex(vertex)
	surface.generate_normals()
	return model.mesh_part(surface.commit(), Vector3.ZERO, mat)

static func rounded_flame_peak(model, height: float, radius: float, base: Vector3, tilt: float) -> void:
	var profile := PackedVector2Array([
		Vector2(0.00, radius * 0.68),
		Vector2(height * 0.12, radius * 0.92),
		Vector2(height * 0.28, radius),
		Vector2(height * 0.48, radius * 0.88),
		Vector2(height * 0.68, radius * 0.62),
		Vector2(height * 0.84, radius * 0.34),
		Vector2(height, 0.01),
	])
	var peak = model.mesh_part(revolved_surface(profile, 16, 0.88), base, model.body_material)
	peak.rotation.z = tilt
	peak.name = "VisualOverrideFlamePeak"

static func flame_peaks(model, crown_scale: float) -> void:
	var peaks := [
		{"x": -0.30, "height": 0.50, "radius": 0.20, "tilt": 0.20},
		{"x": 0.00, "height": 0.78, "radius": 0.25, "tilt": -0.03},
		{"x": 0.30, "height": 0.62, "radius": 0.21, "tilt": -0.18},
	]
	for peak in peaks:
		rounded_flame_peak(model, float(peak.height) * crown_scale, float(peak.radius) * crown_scale, Vector3(float(peak.x) * crown_scale, 1.07, 0.0), float(peak.tilt))

static func revolved_surface(profile: PackedVector2Array, radial_segments: int, depth_scale: float) -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface.set_smooth_group(0)
	for ring_index in profile.size() - 1:
		var lower := profile[ring_index]
		var upper := profile[ring_index + 1]
		for segment in radial_segments:
			var angle_a := TAU * float(segment) / float(radial_segments)
			var angle_b := TAU * float(segment + 1) / float(radial_segments)
			var lower_a := Vector3(cos(angle_a) * lower.y, lower.x, sin(angle_a) * lower.y * depth_scale)
			var upper_a := Vector3(cos(angle_a) * upper.y, upper.x, sin(angle_a) * upper.y * depth_scale)
			var upper_b := Vector3(cos(angle_b) * upper.y, upper.x, sin(angle_b) * upper.y * depth_scale)
			var lower_b := Vector3(cos(angle_b) * lower.y, lower.x, sin(angle_b) * lower.y * depth_scale)
			# Godot treats clockwise triangles as front faces.
			for vertex in [lower_a, upper_b, upper_a, lower_a, lower_b, upper_b]:
				surface.add_vertex(vertex)
	surface.generate_normals()
	return surface.commit()
