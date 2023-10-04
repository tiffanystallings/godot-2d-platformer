extends CanvasLayer

var coins = 0
var current_level = Node

func set_coin_text():
	$Coins.text = str(coins) + "/" + str(current_level.get_coins())

func _ready():
	current_level = get_parent()
	set_coin_text()
	
func _on_coin_collected():
	coins += 1
	set_coin_text()
	
	if coins == current_level.get_coins():
		$Timer.start()
