extends SceneTree

var failures:=0
var checks:=0

func check(condition:bool,message:String)->void:
	checks+=1
	if not condition:failures+=1;push_error(message)

func _initialize()->void:call_deferred("run")

func run()->void:
	var game=load("res://main.tscn").instantiate();root.add_child(game);await process_frame
	# Resources explains why Cooking cannot be changed while a stew is underway.
	game.pending_stew={"expeditions_remaining":2};game.show_resources();await process_frame
	var cooking:Button=game.content.find_child("GoToCooking",true,false)
	check(cooking!=null,"Resources needs a working Go to Cooking button")
	cooking.pressed.emit();await process_frame
	var active_notice:Label=game.content.find_child("SmallNoticeText",true,false)
	check(game.screen=="inventory" and active_notice!=null and active_notice.text=="A stew is already in progress!","Go to Cooking should explain an active stew and remain on Resources")
	# Cooking and the Spice Workshop form a reversible shortcut without losing pot state.
	game.pending_stew.clear();cooking.pressed.emit();await process_frame
	check(game.screen=="cooking","Go to Cooking should open the pot when no stew is underway")
	game.pot_slots.assign(["Bumbleberry","","","",""]);game.rebuild_pot_from_slots();game.show_cooking();await process_frame
	var spices:Button=game.content.find_child("OpenSpiceWorkshopFromCooking",true,false)
	check(spices!=null,"Cooking needs a Spice Workshop shortcut")
	spices.pressed.emit();await process_frame
	check(game.screen=="spice_workshop" and game.pot_slots[0]=="Bumbleberry","The Spice Workshop shortcut should preserve the cooking pot")
	game.leave_spice_workshop();await process_frame
	check(game.screen=="cooking" and game.pot_slots[0]=="Bumbleberry","Leaving the Spice Workshop should return to the preserved Cooking screen")
	# The result screen can open the exact newly arrived Quiblet.
	var arrival:=GameData.make_quiblet(5,12,"New Bloomie",true);game.roster.append(arrival)
	game.completed_stew_result={"recipe":"Plain Stew","quality":"Decent","arrivals":["New Bloomie Lv.12"],"arrival_species":[5],"arrival_uids":[arrival.uid],"leftovers":0}
	game.show_cook_result();await process_frame
	var inspect:Button=game.content.find_child("InspectCookedQuiblet",true,false)
	check(inspect!=null and game.content.find_child("CookAgain",true,false)!=null,"The cooking result needs both Cook Again and Inspect Quiblet")
	inspect.pressed.emit();await process_frame
	check(game.screen=="edit_quiblet" and game.roster[game.selected_roster].uid==arrival.uid and game.completed_stew_result.is_empty(),"Inspect Quiblet should open the exact arrival's stats and moves")
	print("QUIBLETS_NAVIGATION_FLOWS_OK checks=%d failures=%d"%[checks,failures])
	quit(0 if failures==0 else 1)
