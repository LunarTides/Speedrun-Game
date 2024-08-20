extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	%FPS.text = "FPS: %d" % Performance.get_monitor(Performance.TIME_FPS)
	%Health.text = "Health: %s" % snapped(GameManager.player.health, 1)
	%Speed.text = "Speed: %s" % snapped(GameManager.player.speed, 1)
	
	%Score.text = "Score: %s / %s" % [snapped(GameManager.score, 0.01), snapped(GameManager.high_score, 0.01)]
	%Multiplier.text = "x%s" % snapped(GameManager.multiplier, 0.01)
		
	%KatanaReticle.position = get_window().size / 2
	%KatanaReticle.visible = GameManager.player.equipped_weapon and GameManager.player.equipped_weapon.name == "Katana"
