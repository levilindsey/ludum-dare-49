class_name Boulder
extends Node2D


const DURATION := 1.5
const DELAY := 0.5
const START_Y := -280.0
const END_Y := 256.0

var target: Vector2


func _init() -> void:
    visible = false


func trigger(target: Vector2) -> void:
    self.target = target
    
    visible = true
    position.x = target.x
    position.y = START_Y
    
    Sc.time.tween_property(
            self,
            "position:y",
            START_Y,
            END_Y,
            DURATION,
            "ease_in",
            DELAY,
            TimeType.PLAY_PHYSICS_SCALED,
            funcref(self, "_on_landed"))
    
    Sc.audio.play_sound("boulder_launch")


func _on_landed() -> void:
    Sc.audio.play_sound("boulder_land")
    queue_free()


func _on_Area2D_body_entered(body: Node2D) -> void:
    assert(body is Character)
    
    var behavior: EncounterBehavior = body.get_behavior(EncounterBehavior)
    var is_body_to_the_left := body.position.x < position.x
    
    var boost_direction: Vector2 = \
            behavior.BOOST_LEFT_DIRECTION if \
            is_body_to_the_left else \
            behavior.BOOST_RIGHT_DIRECTION
    var boost_magnitude := 300.0
    var boost := boost_direction * boost_magnitude
    body.current_max_horizontal_speed = boost_magnitude
    body.force_boost(boost)
    
    body.on_knock_off()
