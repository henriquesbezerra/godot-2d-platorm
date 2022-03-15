extends Label


func _process(delta):
	self.text = "000" + String(Global.fruits)
	if Global.fruits >= 10:
		self.text = "00" + String(Global.fruits)
	if Global.fruits >= 100:
		self.text = "0" + String(Global.fruits)

