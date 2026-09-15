extends SceneTree

var failures:=0
var checks:=0

func check(condition:bool,message:String)->void:
	checks+=1
	if not condition:failures+=1;push_error(message)

func _initialize()->void:call_deferred("run")

func stone(stone_type:String,power:int)->Dictionary:
	return GameData.normalize_power_stone({"type":stone_type,"power":power,"bonuses":[]})

func cards(game)->Array:
	return game.content.find_children("StoneInventoryCard*","",true,false)

func run()->void:
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame
	while game.roster.size()<2:game.roster.append(GameData.make_quiblet(2,5))
	game.roster[0].level=100;game.power_stone_inventory.clear()
	for fixture in [stone("Health",20),stone("Attack",35),stone("Health",50),stone("Attack",80)]:game.power_stone_inventory.append(fixture)
	game.move_stone_inventory.clear();game.move_stone_inventory["echo"]=20
	# A fitted stone remains visible under its own stat tab, with the existing owner badge.
	var fitted_owner:Dictionary=game.roster[1];game.ensure_quiblet_equipment(fitted_owner)
	var fitted_slot:=GameData.first_power_slot_accepting(fitted_owner,"Health");fitted_owner.power_slot_stones[fitted_slot]=stone("Health",120)
	game.selected_roster=0;game.stone_inventory_tab="Health";game.show_quiblet_edit();await process_frame
	check(game.content.find_children("StoneTab*","Button",true,false).size()==3,"The equipment inventory needs exactly three category tabs")
	var tab:Button=game.content.find_child("StoneTabHealth",true,false);var grid:GridContainer=game.content.find_child("StoneIconGrid",true,false);var navigation:Control=game.content.find_child("PageNavigation",true,false);var panel:Panel=game.content.find_child("StoneInventory",true,false)
	check(tab.position.y+tab.size.y<grid.position.y and grid.position.y+grid.size.y<=navigation.position.y and navigation.position.y+navigation.size.y<=panel.size.y,"Tabs, stone cards, and page controls should fit without overlapping")
	var visible:=cards(game)
	check(visible.size()==3 and visible.all(func(card):return game.stone_inventory_category(card.item_data)=="health") and visible[0].item_data.power==120 and visible[1].item_data.power==50,"The Health tab should include fitted Health stones and sort strongest first")
	check(visible[0].item_data.get("fitted",false) and visible[0].find_child("FittedOwnerBadge",true,false)!=null,"A fitted stone should keep its owner badge inside a filtered tab")
	game.select_inventory_stone(visible[1].item_data);await process_frame
	check(game.stone_inventory_tab=="Health" and not game.selected_inventory_item.is_empty(),"Selecting a Health stone should keep the Health tab and its detail")
	game.content.find_child("StoneTabAttack",true,false).pressed.emit();await process_frame;visible=cards(game)
	check(visible.size()==2 and visible.all(func(card):return game.stone_inventory_category(card.item_data)=="attack") and visible[0].item_data.power==80 and game.selected_inventory_item.is_empty(),"The Attack tab should show only Attack stones and clear a hidden Health detail")
	game.content.find_child("StoneTabMoves",true,false).pressed.emit();await process_frame;visible=cards(game)
	check(visible.size()==18 and visible.all(func(card):return card.item_data.kind=="move_stone") and not game.content.find_child("NextPage",true,false).disabled,"The Move tab should show a full first page and offer another page")
	var previous:Button=game.content.find_child("PreviousPage",true,false);var next:Button=game.content.find_child("NextPage",true,false);var screen_back:TextureButton=game.content.find_child("BackButton",true,false)
	check(next.position.x==previous.position.x+previous.size.x+6 and not next.get_global_rect().intersects(screen_back.get_global_rect()),"The right page arrow should sit beside the left arrow and stay clear of the screen Back button")
	game.content.find_child("NextPage",true,false).pressed.emit();await process_frame
	check(game.stone_inventory_page==1 and cards(game).size()==2,"Paging should be calculated independently inside the active tab")
	game.content.find_child("StoneTabHealth",true,false).pressed.emit();await process_frame
	check(game.stone_inventory_page==0 and cards(game).size()==3,"Changing tabs should reset paging to the first page")
	game.select_inventory_stone({"kind":"move_stone","effect":"echo","display_name":"Echo Stone"});await process_frame
	check(game.stone_inventory_tab=="Moves" and game.content.find_child("StoneDetailTitle",true,false).text=="Echo Stone","Inspecting a fitted Move Stone should automatically reveal the Move tab")
	print("QUIBLETS_STONE_INVENTORY_TABS_OK checks=",checks," failures=",failures)
	quit(0 if failures==0 else 1)
