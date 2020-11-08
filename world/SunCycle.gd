extends DirectionalLight


func _process(delta):
	testDayNightCycle()
	
func testDayNightCycle():
	transform.basis = transform.basis.rotated(Vector3(0, 0, 1), 0.001)
	transform.basis = transform.basis.rotated(Vector3(0, 1, 0), -0.001)
