extends Button

var tape = Array()
var tapePos = 0
var tLength = 31

func _ready() -> void:
	tape.resize(tLength)
	for i in range(tLength):
		tape[i] = 0
	tapePos = 15
	tape[tapePos] = 1 #initialze middle for testing
	updateArrowLoc(15)
	CreateTapeTex()
	
	#temp arrow draw
	var ArrImg = Image.create(4, 3, false, Image.FORMAT_RGBA8)
	ArrImg.set_pixel(0,0,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(0,1,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(1,1,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(1,2,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(2,1,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(2,2,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(3,0,Color.from_string("#fe5a8f",Color.BLACK))
	ArrImg.set_pixel(3,1,Color.from_string("#fe5a8f",Color.BLACK))
	var ArrowTex = ImageTexture.create_from_image(ArrImg)
	$Arrow.texture = ArrowTex

func CreateTapeTex() -> void:
	var tapeImg = Image.create(tLength*3-1, 3, false, Image.FORMAT_RGB8)
	
	var color = GetStateColor(tape[0])
	tapeImg.set_pixel(0,0,color)
	tapeImg.set_pixel(0,1,color)
	tapeImg.set_pixel(0,2,color)
	tapeImg.set_pixel(1,0,color)
	tapeImg.set_pixel(1,1,color)
	tapeImg.set_pixel(1,2,color)
	for i in range(1,tLength):
		color = GetStateColor(tape[i])
		tapeImg.set_pixel(i*3-1,0,Color.BLACK)
		tapeImg.set_pixel(i*3-1,1,Color.BLACK)
		tapeImg.set_pixel(i*3-1,2,Color.BLACK)
		tapeImg.set_pixel(i*3,0,color)
		tapeImg.set_pixel(i*3,1,color)
		tapeImg.set_pixel(i*3,2,color)
		tapeImg.set_pixel(i*3+1,0,color)
		tapeImg.set_pixel(i*3+1,1,color)
		tapeImg.set_pixel(i*3+1,2,color)
	
	var tex = ImageTexture.create_from_image(tapeImg)
	$tapeTex.texture = tex

func GetStateColor(state) -> Color:
	if state == 2:
		return Color.from_string("#8c0013",Color.BLACK)
	elif state == 1:
		return Color.from_string("#fe5a8f",Color.BLACK)
	else:
		return Color.from_string("#f8e5d7",Color.BLACK)

func updateArrowLoc(tapeIdx) -> void:
	var newPos = 3*tapeIdx-20
	$Arrow.position.x = newPos

func moveTapeLeft() -> void:
	tape[tapePos] = tape[tapePos] + 1
	if tape[tapePos] > 2:
		tape[tapePos] = 0
	CreateTapeTex()
	tapePos = tapePos - 1
	if tapePos < 0:
		tapePos = 30
	updateArrowLoc(tapePos)

func moveTapeRight() -> void:
	tape[tapePos] = tape[tapePos] + 1
	if tape[tapePos] > 2:
		tape[tapePos] = 0
	CreateTapeTex()
	tapePos = tapePos + 1
	if tapePos > tLength - 1:
		tapePos = 0
	updateArrowLoc(tapePos)

func _on_pressed() -> void:
	#print("Looking for Node %d and state %d" % [ Global.curNode,tape[tapePos] ] )
	for p in Global.plugs:
		var nodeCheck = p.linkNode == Global.curNode
		var stateCheck = p.state == tape[tapePos]
		if nodeCheck and stateCheck:
			var dragPlug = p.get_node("DragPlug")
			#print("found DragPull: %s" % dragPlug)
			#print("The drag plug lock state is %s" % dragPlug.isLocked)
			if dragPlug.isLocked:
				var nextNode = dragPlug.conNode
				var isRight = dragPlug.conRight
				Global.curNode = nextNode
				if isRight:
					moveTapeRight()
				else:
					moveTapeLeft()
			else:
				#This is where we need to implement the plug light system
				pass
			break
