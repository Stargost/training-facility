extends AnimatableBody2D

## Determine whether the beam we fire as to be fired constantly or not.
## TRUE means it will rest for a bit. FALSE means it fires uninterrupted.
@export var is_not_continuous: bool = false
## Determines for how long the electrical arc will fire for.
@export var firing_time: float = 2.0
## Determines how long it takes for the electrical arc to "recharge"
@export var recharge_time: float = 1.5
## Determine speed and direction of rotation, in degrees.
@export var spinning: float

@onready var timer: Timer = $Timer
@onready var arc: Node2D = $ElectricalArc
@onready var machinima: AnimatedSprite2D = $AnimatedSprite2D
var can_rotate: bool = false

func _ready() -> void:
	if not is_not_continuous:
		# If continuous, just turn it on and leave it on.
		machinima.play("default")
		await machinima.animation_finished
		arc.set_active(true)
		machinima.play("firing")
	else:
		# Start the pulsing cycle.
		timer.timeout.connect(_on_timer_timeout)
		machinima.play("default")
		await machinima.animation_finished
		start_firing()
	start_rotation()

func start_firing() -> void:
	arc.set_active(true)
	machinima.play("firing")
	timer.start(firing_time)

func start_recharging() -> void:
	arc.set_active(false)
	machinima.play_backwards("default")
	await machinima.animation_finished
	timer.start(recharge_time)

func _on_timer_timeout() -> void:
	if arc.is_active:
		start_recharging()
	else:
		machinima.play("default")
		await machinima.animation_finished
		start_firing()

func start_rotation():
	if spinning != 0.0:
		can_rotate = true

func _physics_process(delta: float) -> void:
	if can_rotate == true:
		var rotation_thingy = deg_to_rad(spinning)
		self.rotate(rotation_thingy)
