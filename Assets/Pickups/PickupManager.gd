extends Area3D

signal got_pickup

var max_player_health = 0
var cur_player_health = 0

func update_player_health(amount):
	cur_player_health = amount

func _ready():
	area_entered.connect(on_area_enter)
	max_player_health = $"../HealthManager".max_health
	
func on_area_enter(pickup: Pickup):
	print('current health: ', cur_player_health, " max health: ", max_player_health)
	if pickup.pickup_type == Pickup.PICKUP_TYPE.HEALTH and cur_player_health == max_player_health:
		return
	emit_signal('got_pickup', pickup.pickup_type, pickup.ammo)
	print('got_pickup', pickup.pickup_type, pickup.ammo)
	pickup.queue_free()
	

