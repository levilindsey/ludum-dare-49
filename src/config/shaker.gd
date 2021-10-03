class_name Shaker
extends Node2D


const _DEFAULT_SHAKE_STRENGTH := 0.8

var decay := 0.8
var max_offset := Vector2(100.0, 50.0)
var max_roll := 0.1

var strength := 0.0
var strength_exponent := 2.0
var noise: OpenSimplexNoise
var noise_y := 0.0

var target: Node2D


func _ready() -> void:
    randomize()
    noise = OpenSimplexNoise.new()
    noise.seed = Sc.metadata.rng_seed
    noise.period = 4.0
    noise.octaves = 2.0


func _process(delta_sec: float) -> void:
    if strength > 0.0:
        # This should end up calling _update_shake exactly once with a strength
        # of zero, which is important for resetting the target.
        strength = max(strength - decay * delta_sec, 0)
        _update_shake()


func _update_shake() -> void:
    var amount := pow(strength, strength_exponent)
    noise_y += 1.0
    target.rotation = \
            max_roll * amount * \
            noise.get_noise_2d(noise.seed, noise_y)
    target.position.x = \
            max_offset.x * amount * \
            noise.get_noise_2d(noise.seed * 2.0, noise_y)
    target.position.y = \
            max_offset.y * amount * \
            noise.get_noise_2d(noise.seed * 3.0, noise_y)


func shake(
        target: Node2D,
        strength := _DEFAULT_SHAKE_STRENGTH) -> void:
    self.target = target
    self.strength = min(self.strength + strength, 1.0)
