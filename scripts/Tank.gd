extends CharacterBody3D

const MOVE_SPEED := 9.0
const ACCELERATION := 6.0
const MOUSE_SENSITIVITY := 0.0025
const PITCH_SENSITIVITY := 0.002
const PITCH_LIMIT := deg_to_rad(35)
const FIRE_COOLDOWN := 0.4
const SHELL_SCENE := preload("res://scenes/Shell.tscn")

@onready var turret: Node3D = $Turret
@onready var camera_rig: Node3D = $Turret/CameraRig
@onready var camera: Camera3D = $Turret/CameraRig/Camera3D
@onready var muzzle: Marker3D = $Turret/Muzzle

var _yaw := 0.0
var _pitch := 0.0
var _fire_timer := 0.0

func _ready() -> void:
    _yaw = rotation.y
    _pitch = turret.rotation.x
    camera.current = true
    _configure_input()

func _configure_input() -> void:
    var move_actions := {
        "move_forward": [KEY_W, KEY_UP],
        "move_back": [KEY_S, KEY_DOWN],
        "move_left": [KEY_A, KEY_LEFT],
        "move_right": [KEY_D, KEY_RIGHT]
    }
    for action in move_actions.keys():
        if not InputMap.has_action(action):
            InputMap.add_action(action)
        for keycode in move_actions[action]:
            var event := InputEventKey.new()
            event.physical_keycode = keycode
            if not _action_has_event(action, event):
                InputMap.action_add_event(action, event)
    if not InputMap.has_action("fire"):
        InputMap.add_action("fire")
    var mouse_event := InputEventMouseButton.new()
    mouse_event.button_index = MOUSE_BUTTON_LEFT
    mouse_event.pressed = true
    if not _action_has_event("fire", mouse_event):
        InputMap.action_add_event("fire", mouse_event)

func _action_has_event(action: String, event: InputEvent) -> bool:
    for existing in InputMap.action_get_events(action):
        if existing.as_text() == event.as_text():
            return true
    return false

func _physics_process(delta: float) -> void:
    _fire_timer = max(_fire_timer - delta, 0.0)
    var input_vector := Vector2.ZERO
    input_vector.y = Input.get_action_strength("move_forward") - Input.get_action_strength("move_back")
    input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
    var target_velocity := Vector3.ZERO
    if input_vector.length() > 0.01:
        input_vector = input_vector.normalized()
        var forward := -global_transform.basis.z
        forward.y = 0
        forward = forward.normalized()
        var right := global_transform.basis.x
        right.y = 0
        right = right.normalized()
        var direction := (forward * input_vector.y + right * input_vector.x).normalized()
        target_velocity = direction * MOVE_SPEED
    var horizontal_velocity := Vector3(velocity.x, 0, velocity.z)
    horizontal_velocity = horizontal_velocity.lerp(target_velocity, delta * ACCELERATION)
    velocity.x = horizontal_velocity.x
    velocity.z = horizontal_velocity.z
    velocity.y = 0
    move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
    if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
        return
    if event is InputEventMouseMotion:
        _yaw -= event.relative.x * MOUSE_SENSITIVITY
        _pitch = clamp(_pitch - event.relative.y * PITCH_SENSITIVITY, -PITCH_LIMIT, PITCH_LIMIT)
        rotation.y = _yaw
        turret.rotation.x = _pitch

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("fire"):
        _fire_shell()

func _fire_shell() -> void:
    if _fire_timer > 0.0 or Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
        return
    var shell := SHELL_SCENE.instantiate()
    shell.global_transform = muzzle.global_transform
    get_tree().current_scene.add_child(shell)
    _fire_timer = FIRE_COOLDOWN

