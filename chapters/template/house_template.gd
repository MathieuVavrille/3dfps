extends Node3D


# Called when téhe node enters the scene tree for the first time.
func _ready():
	set_process(false)
	$Fogs.visible=false
	for fog in $Fogs.get_children():
		fog.disable(true)
	for child in $Fish.get_children():
		child.collected.connect(fish_collected)


var FADEOUT_TIME = 2
func _process(delta):
	$CanvasLayer/ColorRect.color.a = move_toward($CanvasLayer/ColorRect.color.a, 1., delta / FADEOUT_TIME)
	if $CanvasLayer/ColorRect.color.a == 1.:
		get_tree().quit()

func fish_collected():
	$ObjectivesTemplate.objective_got("fish")


func _on_objectives_template_can_sleep():
	$Fogs.visible=true
	for fog in $Fogs.get_children():
		fog.disable(false)

func end_chapter():
	set_process(true)
	$Player.set_physics_process(false)
