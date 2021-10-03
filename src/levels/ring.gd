class_name Ring
extends Node2D


const CATCH_DISTANCE_SQUARED_THRESHOLD := 8.0 * 8.0

const TOSS_ANGLE_OFFSET := PI / 4.0

const TOSS_STRENGTH := 600.0
const GRAVITY_STRENGTH := 1.0
const PULL_STRENGTH := 2000.0

var GRAVITY := Vector2.DOWN * GRAVITY_STRENGTH

var velocity := Vector2.ZERO
var origin: Vector2
var hero: Hero
var static_target: Vector2
var current_target: Vector2


func toss(
        from: Vector2,
        hero_or_static_target) -> void:
    if hero_or_static_target is Hero:
        self.hero = hero_or_static_target
        self.static_target = Vector2.INF
        current_target = hero.position
    else:
        self.hero = null
        self.static_target = hero_or_static_target
        current_target = static_target
    
    self.origin = from
    self.position = from
    
    Sc.time.tween_method(
            self,
            "_interpolate_position",
            0.0,
            1.0,
            0.8,
            "ease_out",
            0.0,
            TimeType.PLAY_PHYSICS_SCALED,
            funcref(Sc.level, "on_ring_caught"),
            [hero, self])
    
    Sc.audio.play_sound("ring")


func _interpolate_position(progress: float) -> void:
    current_target = \
            static_target if \
            static_target != Vector2.INF else \
            hero.position if \
            is_instance_valid(hero) else \
            current_target
    current_target.y -= 4.0
    
    self.position = (current_target - origin) * progress + origin


# FIXME: ---------- Use a nice physicsy parabola instead.
#func toss(
#        from: Vector2,
#        hero_or_static_target) -> void:
#    if hero_or_static_target is Hero:
#        self.hero = hero_or_static_target
#        self.static_target = Vector2.INF
#        current_target = hero.position
#    else:
#        self.hero = null
#        self.static_target = hero_or_static_target
#        current_target = static_target
#
#    var angle_to_hero := from.angle_to_point(current_target)
#    var angle_offset: float
#    if angle_to_hero > -PI / 2.0 and \
#            angle_to_hero < PI / 2.0:
#        angle_offset = -TOSS_ANGLE_OFFSET
#    else:
#        angle_offset = TOSS_ANGLE_OFFSET
#    var toss_angle := angle_to_hero + angle_offset
#
#    var toss_normal := Vector2.RIGHT.rotated(toss_angle)
#
#    var toss_boost := toss_normal * TOSS_STRENGTH
#
#    self.position = from
#    self.velocity = toss_boost


#func _physics_process(delta: float) -> void:
#    if Su.is_precomputing_platform_graphs or \
#            Sc.level_session._is_destroyed:
#        return
#
#    current_target = \
#            static_target if \
#            static_target != Vector2.INF else \
#            hero.position if \
#            is_instance_valid(hero) else \
#            current_target
#    var pull := position.direction_to(current_target) * PULL_STRENGTH
#    self.velocity += pull * delta
#    self.velocity += GRAVITY * delta
#    self.position += velocity * delta
#
#    if position.distance_squared_to(current_target) < \
#            CATCH_DISTANCE_SQUARED_THRESHOLD:
#        Sc.level.on_ring_caught(hero, self)
