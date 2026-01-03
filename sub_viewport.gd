extends SubViewport

@onready var player = $"../../../.."
@onready var minmapCam = $minimpa
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	world_2d = get_tree().root.world_2d


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	minmapCam.position = player.position
