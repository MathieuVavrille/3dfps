extends Node3D

func bug():
	if $Monitor/Wall.visible:
		$Monitor/Wall.visible = false
		$Monitor/Bug1.visible = true
	elif $Monitor/Bug1.visible:
		$Monitor/Bug1.visible = false
		$Monitor/Bug2.visible = true
	elif $Monitor/Bug2.visible:
		$Monitor/Bug2.visible = false
		$Monitor/Bug3.visible = true
