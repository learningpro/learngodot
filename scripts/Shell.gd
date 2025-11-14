extends Area3D

const SPEED := 45.0
@export var life_time := 3.0

var _direction := Vector3.FORWARD
var _alive_time := 0.0

func _ready() -> void:
    _direction = -global_transform.basis.z
    connect("body_entered", Callable(self, "_on_hit"))
    connect("area_entered", Callable(self, "_on_hit"))

func _physics_process(delta: float) -> void:
    global_position += _direction * SPEED * delta
    _alive_time += delta
    if _alive_time >= life_time:
        queue_free()

func _on_hit(_other: Node) -> void:
    queue_free()

