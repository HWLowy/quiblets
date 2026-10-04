extends SceneTree

const STORIES:=preload("res://scripts/expedition_stories.gd")

func _initialize()->void:
	assert(STORIES.STORIES.size()==GameData.EXPEDITION_AREAS.size(),"Every region needs a story arc")
	for area_index in STORIES.STORIES.size():
		var arc:Array=STORIES.STORIES[area_index]
		assert(arc.size()==8,"%s needs one journal sentence for every route node"%GameData.EXPEDITION_AREAS[area_index])
		for node_index in arc.size():
			var sentence:String=arc[node_index]
			assert(not sentence.contains("\n") and sentence.ends_with("."),"Story beat must be one finished line: %s %d"%[GameData.EXPEDITION_AREAS[area_index],node_index])
			assert(sentence.count(".")==1 and sentence.count("!")==0 and sentence.count("?")==0,"Story beat must remain a single gentle sentence: %s"%sentence)
	assert(STORIES.story(0,0).contains("Camp Almanac") and STORIES.story(15,7).contains("one more wonder"),"The main journey must open and close the Camp Almanac arc")
	print("QUIBLETS_EXPEDITION_STORIES_OK regions=%d beats=%d"%[STORIES.STORIES.size(),STORIES.STORIES.size()*8])
	quit()
