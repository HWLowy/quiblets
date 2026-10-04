extends SceneTree
var failures:=0
func check(ok:bool,message:String)->void:
	if not ok:failures+=1;push_error(message)
func _initialize()->void:call_deferred("run")
func run()->void:
	var fixture_index:=0
	for fixture in [[0,0,"level",Vector2i(52,36)],[4,6,"boss",Vector2i(60,40)],[0,3,"berry_grove",Vector2i(64,36)],[11,7,"optional_berry_grove",Vector2i(64,36)]]:
		var e:=Expedition3D.new();e.stage_area_index=fixture[0];e.stage_node_index=fixture[1];e.stage_kind=fixture[2];e.stage_level=GameData.expedition_area_level(fixture[0]);root.add_child(e);e.set_process(false)
		e.map_seed=9400+fixture_index;fixture_index+=1
		var start:=Time.get_ticks_msec();e.build_level()
		var old:Vector2i=fixture[3]
		var expected_channels:=ceili(float(e.biome.rivers)*float(e.field_rect.size.x+e.field_rect.size.y)/220.0)
		check(e.river_channels==expected_channels,"River count must follow Brighton's current biome-and-map scaling")
		var water_cells:=0
		for cell in e.rivers:
			if e.in_field(cell):water_cells+=1
		check(e.river_channels==0 or water_cells>e.field_rect.size.x*e.field_rect.size.y*.02,"Each configured river must occupy a visible part of the field")
		check(e.field_rect.size.x*e.field_rect.size.y>=old.x*old.y*6,"Playable area must be at least six times larger")
		# Wider, denser rivers occupy more of the expanded area, while dry land
		# should still exceed three and a half entire former maps.
		check(e.walkable.size()>old.x*old.y*3.5,"Expansion must add traversable terrain")
		check(Vector2(e.zones[-1].center).distance_to(Vector2(e.zones[0].center))>mini(e.field_rect.size.x,e.field_rect.size.y)*.55,"Landmark clearings must span the enlarged map in any rotation")
		var first:=e.cell_of(e.zones[0].center);var seen:={first:true};var queue:Array[Vector2i]=[first];var head:=0
		while head<queue.size():
			var cell:Vector2i=queue[head];head+=1
			for step in [Vector2i.LEFT,Vector2i.RIGHT,Vector2i.UP,Vector2i.DOWN]:
				var next:Vector2i=cell+step
				if e.walkable.has(next) and not seen.has(next):seen[next]=true;queue.append(next)
		check(e.zones.all(func(zone):return seen.has(e.cell_of(zone.center))),"All encounters must connect across the expanded field")
		check(e.berry_nodes.size()==int(e.GROVE_PATCHES[e.stage_kind]),"Expanded maps retain every required resource patch")
		check(e.berry_nodes.all(func(patch):return seen.has(e.cell_of(Vector2(patch.position.x,patch.position.z)))),"Every resource patch must be reachable")
		if is_instance_valid(e.cache_node):check(seen.has(e.cell_of(Vector2(e.cache_node.position.x,e.cache_node.position.z))),"Treasure caches must be reachable")
		var from:Vector2=e.zones[0].center;var goal:Vector2=e.zones[-1].center
		var path:=e.find_path(from,goal)
		check(not path.is_empty(),"Long routes must produce a path")
		for waypoint in path:
			var next:=Vector2(waypoint.x,waypoint.z);check(e.line_walkable(from,next),"Long paths must not cross water or props");from=next
		check(from.distance_to(goal)<1.5,"Long routes must reach the last encounter")
		print("LARGE_MAP ",e.stage_kind," size=",e.field_rect.size," walkable=",e.walkable.size()," build_ms=",Time.get_ticks_msec()-start)
		e.free();await process_frame
	print("QUIBLETS_LARGE_MAPS failures=%d"%failures);quit(0 if failures==0 else 1)
