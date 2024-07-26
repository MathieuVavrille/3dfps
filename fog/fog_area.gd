extends FogVolume

func _ready():
	$Area3D/CollisionShape3D.shape = BoxShape3D.new()
	$Area3D/CollisionShape3D.shape.size = size

func disable(value):
	$Area3D/CollisionShape3D.disabled = value
