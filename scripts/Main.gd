extends Node3D

@onready var overlay := $CanvasLayer/Overlay
@onready var crosshair := $CanvasLayer/Crosshair

func _ready() -> void:
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    _update_ui()

func _process(_delta: float) -> void:
    _update_ui()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    elif event.is_action_pressed("ui_cancel"):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _update_ui() -> void:
    var captured := Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
    overlay.visible = not captured
    crosshair.visible = captured

