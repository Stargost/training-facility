extends AnimatableBody2D

## Determine whether the beam we fire as to be fired constantly or not.
## TRUE means it will rest for a bit. FALSE means it fires uninterrupted.
@export var is_not_continuous: bool = false
## Determines for how long the electrical arc will fire for.
@export var firing_time: float = 2.0
## Determines how long it takes for the electrical arc to "recharge"
@export var recharge_time: float = 1.5
## Check TRUE for it to start OFF.
@export var start_off: bool = false
## How long it will take for it to activate for the first time. Does not work with the parameter
## "Start Off"
@export var activation_delay: float = 0.0

@onready var timer: Timer = $Timer
@onready var arc: Node2D = $ElectricalArc
@onready var machinima: AnimatedSprite2D = $AnimatedSprite2D
@onready var delaying_timer: Timer = $Timer2
var is_active: bool = true
var associated_trigger

func _ready() -> void:
	if activation_delay <= 0.0:
		set_start()
	else:
		delaying_timer.start(activation_delay)
		delaying_timer.timeout.connect(delay_timer)
	if associated_trigger:
		var trigerino = get_node(associated_trigger)
		if "check_actuation" in trigerino:
			trigerino.connect("check_actuation", checkers)


func start_firing() -> void:
	arc.set_active(true)
	machinima.play("firing")
	timer.start(firing_time)

func start_recharging() -> void:
	arc.set_active(false)
	machinima.play_backwards("default")
	if is_active != true:
		return
	await machinima.animation_finished
	timer.start(recharge_time)

func _on_timer_timeout() -> void:
	if arc.is_active:
		start_recharging()
	else:
		machinima.play("default")
		await machinima.animation_finished
		start_firing()

func checkers():
	#print("test")
	if start_off == true:
		#print("test_2")
		if is_active == true:
			#print("test_3")
			start_firing()
			return
	if is_active != true:
		_on_timer_timeout()
		timer.paused = true
	else:
		_on_timer_timeout()
		timer.paused = false

func delay_timer():
	set_start()

func set_start():
	if not is_not_continuous and start_off == false:
		# If continuous, just turn it on and leave it on.
		machinima.play("default")
		await machinima.animation_finished
		arc.set_active(true)
		machinima.play("firing")
	elif start_off == false:
		# Start the pulsing cycle.
		timer.timeout.connect(_on_timer_timeout)
		machinima.play("default")
		await machinima.animation_finished
		start_firing()
	if start_off:
		is_active = false
