extends Label

var ammo = 0
var health = 0

func _ready():
	pass

func update_ammo(amount):
	ammo = amount
	update_display()

func update_health(amount):
	health = amount
	update_display()

func update_display():
	$HealthHUD.text = 'Health: ' + str(health)
	if ammo < 0:
		$AmmoHUD.text = ''
		return
	$AmmoHUD.text = 'Ammo: ' + str(ammo)
	
