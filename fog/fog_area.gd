extends FogVolume

func _ready():
	$Area3D/CollisionShape3D.shape.size = size

