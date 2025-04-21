extends Node2D  

var clicks = 0  
var dinero = 10  
var auto_clicker_enabled = false  

@onready var label = $Label  
@onready var compra_aviso = $CompreAviso  
@onready var timer = $Timer  

func _on_button_pressed():
	clicks += 1
	label.text = "Clics: " + str(clicks)


func _process(_delta):
	label.text = "Clicks: " + str(clicks)


func _on_comprar_btn_pressed():
	var costo = 25
	if clicks >= costo:
		clicks -= costo 
		print("¡Compra exitosa!")  

		
		compra_aviso.text = "¡Compra exitosa!"
		compra_aviso.visible = true 

		
		if not auto_clicker_enabled:
			auto_clicker_enabled = true
			timer.start(1)  
		
		await get_tree().create_timer(2).timeout  
		compra_aviso.visible = false  
	else:
		print("No tienes suficientes clics.") 

		
		compra_aviso.text = "No tienes suficientes clics."
		compra_aviso.visible = true  

		
		await get_tree().create_timer(2).timeout 
		compra_aviso.visible = false
		
func _on_timer_timeout():
	if auto_clicker_enabled:
		clicks += 1  
		label.text = "Clics: " + str(clicks)
		print("Clic automático añadido.") 
