extends Node2D  

var clicks = 0  
var vida = 100  
var dinero = 10  
var auto_clicker_enabled = false  
var auto_clicker_count = 0  

@onready var label = $Label  
@onready var vida_label = $VidaLabel  
@onready var compra_aviso = $CompreAviso  
@onready var timer = $Timer  
@onready var game_over_label = $GameOverLabel  
@onready var botiquin_button = $Botiquin  

func _on_clickbut_pressed():
	clicks += 1
	vida -= 0.5
	vida_label.text = "Vida: " + str(vida)

	if vida <= 0:
		game_over_label.text = "Game Over"
		game_over_label.visible = true
		vida_label.visible = false
		auto_clicker_enabled = false
		set_process_input(false)
		set_process(false)

func _process(_delta):
	label.text = str(clicks)

func _on_comprar_btn_pressed():
	var costo = 25
	if clicks >= costo:
		clicks -= costo
		auto_clicker_count += 1
		compra_aviso.text = "¡Compra exitosa! Has comprado " + str(auto_clicker_count) + " auto-clickers."
		compra_aviso.visible = true

		if not auto_clicker_enabled:
			auto_clicker_enabled = true
			timer.start(1)

		timer.wait_time = 1.0
		
		await get_tree().create_timer(2).timeout
		compra_aviso.visible = false  
	else:
		compra_aviso.text = "No tienes suficientes clics."
		compra_aviso.visible = true  
		await get_tree().create_timer(2).timeout  
		compra_aviso.visible = false

func _on_timer_timeout():
	if auto_clicker_enabled:
		clicks += 1
		label.text = str(clicks)

# Función que se ejecuta cuando se presiona el botón de Botiquín
func _on_botiquin_pressed():
	var costo_botiquin = 5
	if clicks >= costo_botiquin:
		clicks -= costo_botiquin
		vida += 5
		vida_label.text = "Vida: " + str(vida)
		compra_aviso.text = "¡Compra exitosa! Has comprado un botiquin "
		compra_aviso.visible = true
		await get_tree().create_timer(2).timeout
		compra_aviso.visible = false  
	else:
		compra_aviso.text = "No tienes suficientes clics."
		compra_aviso.visible = true  
		await get_tree().create_timer(2).timeout  
		compra_aviso.visible = false
