extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%FPS.text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)
	%Health.text = "Health: %d" % GameManager.player.health
	%Speed.text = "Speed: %d" % GameManager.player.speed
	
	%Score.text = "Score: %s / %s" % [str(GameManager.score), str(GameManager.high_score)]
	%Multiplier.text = "x%s" % str(GameManager.multiplier)
		
	%KatanaReticle.position = get_window().size / 2
	%KatanaReticle.visible = GameManager.player.equipped_weapon and GameManager.player.equipped_weapon.name == "Katana"
