extends SceneTree

# Graphical no-save preview for Zippet's maintained iPad silhouette.
func _initialize()->void:call_deferred("run")

func run()->void:
	var stage:=Node3D.new();root.add_child(stage)
	var environment:=WorldEnvironment.new();var env:=Environment.new();env.background_mode=Environment.BG_COLOR;env.background_color=Color("#e8f1df");env.ambient_light_source=Environment.AMBIENT_SOURCE_COLOR;env.ambient_light_color=Color.WHITE;env.ambient_light_energy=.95;environment.environment=env;stage.add_child(environment)
	var light:=DirectionalLight3D.new();light.rotation_degrees=Vector3(-50,-30,0);light.light_energy=1.25;light.shadow_enabled=true;stage.add_child(light)
	var floor:=MeshInstance3D.new();var floor_mesh:=CylinderMesh.new();floor_mesh.top_radius=3.4;floor_mesh.bottom_radius=3.4;floor_mesh.height=.12;floor_mesh.radial_segments=48;floor.mesh=floor_mesh;floor.position.y=-.08;var floor_material:=StandardMaterial3D.new();floor_material.albedo_color=Color("#b8d69c");floor.material_override=floor_material;stage.add_child(floor)
	var front:=QuibletModel3D.new();front.setup(25,false,1.25);front.position=Vector3(-1.25,0,0);stage.add_child(front)
	var turn:=QuibletModel3D.new();turn.setup(25,false,1.25);turn.position=Vector3(1.25,0,0);turn.rotation.y=-.75;stage.add_child(turn)
	var heading:=Label3D.new();heading.text="ZIPPET — A LIVING SPARK";heading.font_size=52;heading.pixel_size=.009;heading.position=Vector3(0,2.6,0);heading.modulate=Color("#273747");heading.outline_size=8;heading.outline_modulate=Color("#f7fbef");heading.billboard=BaseMaterial3D.BILLBOARD_ENABLED;stage.add_child(heading)
	var moves:=Label3D.new();moves.text="ZAP  •  ZIP  •  FLASHSTEP  •  ZIGZAG";moves.font_size=34;moves.pixel_size=.009;moves.position=Vector3(0,-.02,1.9);moves.modulate=Color("#5f4d19");moves.outline_size=6;moves.outline_modulate=Color("#fff8db");moves.billboard=BaseMaterial3D.BILLBOARD_ENABLED;stage.add_child(moves)
	var camera:=Camera3D.new();stage.add_child(camera);camera.position=Vector3(0,3.0,8.0);camera.look_at(Vector3(0,.9,0),Vector3.UP);camera.projection=Camera3D.PROJECTION_ORTHOGONAL;camera.size=5.6;camera.current=true
	for frame in 24:await physics_frame
	await RenderingServer.frame_post_draw
	var result:=root.get_texture().get_image().save_png("/private/tmp/quiblets-zippet-spark.png")
	print("QUIBLETS_ZIPPET_VISUAL result=",result)
	quit(0 if result==OK else 1)
