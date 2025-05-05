
extends Node2D  

var clicks = 0  
var vida = 100  
var dinero = 10  
var auto_clicker_enabled = false  
var auto_clicker_count = 0  
var tiempo_restante = 600  # 10 minutos en segundos
var pausa_activa = false

@onready var label = $Label  
@onready var vida_label = $VidaLabel  
@onready var compra_aviso = $CompreAviso  
@onready var timer = $Timer
@onready var game_over_label = $GameOverLabel  
@onready var botiquin_button = $Botiquin  
@onready var pausa_timer = $Timer2 
@onready var actualizar_tiempo_restante = $actutimlef
@onready var tiempo_restante_label = $timelft
@onready var pause_timer_btn = $butsuero
@onready var vidat = $vidat


func _ready():
	pausa_timer.wait_time = 600
	pausa_timer.one_shot = true
	actualizar_tiempo_restante.wait_time = 1.0
	actualizar_tiempo_restante.one_shot = false
	tiempo_restante_label.visible = false


func _on_clickbut_pressed():
	clicks += 1
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
	var costo = 1
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


func _on_vidat_timeout() -> void:
	vida -= 25
	vida_label.text = "Vida: " + str(vida)
	
	if vida <= 0:
		game_over_label.text = "Game Over"
		game_over_label.visible = true
		vida_label.visible = false
		auto_clicker_enabled = false
		set_process_input(false)
		set_process(false)
		
func _on_butsuero_pressed():
	var costo_suero = 300
	if clicks >= costo_suero and not pausa_activa:
		clicks -= costo_suero
		vidat.stop()
		pausa_activa = true
		tiempo_restante = 600
		tiempo_restante_label.visible = true
		pausa_timer.start()
		actualizar_tiempo_restante.start()
		pause_timer_btn.disabled = true
	else:
		compra_aviso.text = "Necesitás 300 clics para usar el suero."
		compra_aviso.visible = true
		await get_tree().create_timer(2).timeout
		compra_aviso.visible = false

func _on_pausa_timer_timeout():
	vidat.start()
	actualizar_tiempo_restante.stop()
	tiempo_restante_label.visible = false
	pause_timer_btn.disabled = false
	pausa_activa = false

func _on_actualizar_tiempo_restante_timeout():
	tiempo_restante -= 1
	var minutos = tiempo_restante / 60
	var segundos = tiempo_restante % 60
	tiempo_restante_label.text = "Timer pausado: %02d:%02d" % [minutos, segundos]
