extends StaticBody

# ID of the chunk
export var id = 0
var structureChunk = false
var hasFireflies = false
var isRingChunk = false # Spawn chunk only

# preloads
var treeScene = preload("res://environment/Tree.tscn")
var trailScene = preload("res://environment/Trail.tscn")
var rockScene = preload("res://environment/Rock.tscn")
var firefliesScene = preload("res://environment/Fireflies.tscn")

# ID handling... spawn chunk is id 0
func setID(id):
	self.id = id
	
func getID() -> int:
	return self.id
	
func _ready():
	# Determine if we should spawn a structure here
	var die = round(rand_range(0, 10))
	if die == 7:
		structureChunk = true
		
	# Determine if we should have fireflies
	die = round(rand_range(0, 4))
	if die == 1:
		hasFireflies = true

# Adds the ring structure 
func addRing():
	pass
	
# Populates the chunk with objects like trees
func populate():
	# Determine forest thickness (unused for now...)
	var die = round(rand_range(0, 1))
	var thick = false
	if die == 1:
		thick = true
	
	if structureChunk:
		addStruct()
	else:
		plantTrees(thick)
	
	if hasFireflies:
		addFireflies()
		
# Plants trees on the chunk
func plantTrees(thick):
	# We'll create a random grid of rows and cols, thus having row*col trees.
	# Plant a tree in each cell, then apply a random offset to each tree so it isn't a neat grid of trees
	# ...unless this was planted by the US Forest Service... 
	var numRows = 0
	var numCols = 0
	var OFFSET = 2.0
	numRows = round(rand_range(3, 6))
	numCols = round(rand_range(3, 6))
	
	# Generate a bunch of coordinates. The chunk is 100x100 units, and the origin is local to the middle of the chunk.
	# Thus we can plant a tree from -10 to 10, in relation to the chunk.
	var coords = []
	var currentX = -10
	var currentZ = -10
	var TRAIL_SIZE = rand_range(4, 6)
	
	for i in range(numRows):
		for j in range(numCols):
			currentZ += (20 / numCols)
			# Leave room in the middle for a trail, if applicable
			#if not thick and (currentX < (-1 * TRAIL_SIZE) or currentX > TRAIL_SIZE):
			if not thick:
				coords.append([currentX, currentZ])
			elif thick:
				coords.append([currentX, currentZ])
		currentX += (20 / numRows)
		currentZ = -10
	
	# Now apply a random offset to each coordinate pair
	for coord in coords:
		coord[0] += rand_range(-1 * OFFSET, OFFSET)
		coord[1] += rand_range(-1 * OFFSET, OFFSET)
		
		coord[0] = clamp(coord[0], -10, 10)
		coord[1] = clamp(coord[1], -10, 10)
	
	# Plant trees
	for n in range(coords.size()):
		var tree = treeScene.instance()
		tree.translate(Vector3(coords[n][0], 0, coords[n][1]))
		add_child(tree)
		
# Add a trail, if applicable
func addTrail():
	# Unlike the trees, we can just directly plop down a trail without creating a 2d array of coords.
	var currentX = -10
	var currentZ = -11
	var amount = round(rand_range(5, 9))
	for i in range(13):
		for j in range(amount):
			var trailPiece = trailScene.instance()
			trailPiece.translate(Vector3(currentX, 1.50, currentZ))
			
			# Random rotation
			var rotation = round(rand_range(1, 4))
			trailPiece.rotate_y(rotation * (PI/2))
			
			add_child(trailPiece)
			currentX += 2
		amount = round(rand_range(5, 9))
		currentZ += 2
		currentX = rand_range(-10, -8)

# Summon some firefly particles
func addFireflies():
	var fireflies = firefliesScene.instance()
	fireflies.transform.origin = Vector3(self.transform.origin.x, 3, self.transform.origin.z)
	add_child(fireflies)
	
# Generates structures
func addStruct():
	
	# Choose a structure
	var pick = round(rand_range(1, 1))
	
	# 1 = rocks
	if pick == 1:
		addRocks()
	else:
		addRocks()


func addRocks():
	# How many rocks?
	var num = round(rand_range(5, 10))
	
	# Eh, looks cool underneath
	addTrail()
	
	for i in range(num):
		var x = rand_range(-20, 20)
		var z = rand_range(-20, 20)
		var rock = rockScene.instance()
		rock.translate(Vector3(x, 0, z))
		add_child(rock)
