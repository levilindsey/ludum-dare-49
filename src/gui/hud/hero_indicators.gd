tool
class_name HeroIndicators
extends VBoxContainer


const _SEPARATION := 4.0

var cooldown_count := 0


func _ready() -> void:
    Sc.gui.add_gui_to_scale(self)
    _on_gui_scale_changed()


func on_schedule_ready() -> void:
    $WaveCooldown.visible = false
    $BobbitCooldown.visible = false
    $DwarfCooldown.visible = false
    $ElfCooldown.visible = false
    $WizardCooldown.visible = false
    
    cooldown_count = 0
    
    if Sc.level_session.get_wave_count() > 0:
        $WaveCooldown.visible = true
        cooldown_count += 1
    else:
        if Sc.level_session.get_is_hero_in_level("bobbit"):
            $BobbitCooldown.visible = true
            cooldown_count += 1
        if Sc.level_session.get_is_hero_in_level("dwarf"):
            $DwarfCooldown.visible = true
            cooldown_count += 1
        if Sc.level_session.get_is_hero_in_level("elf"):
            $ElfCooldown.visible = true
            cooldown_count += 1
        if Sc.level_session.get_is_hero_in_level("wizard"):
            $WizardCooldown.visible = true
            cooldown_count += 1
    
    _on_gui_scale_changed()


func _destroy() -> void:
    Sc.gui.remove_gui_to_scale(self)
    if !is_queued_for_deletion():
        queue_free()


func _on_gui_scale_changed() -> bool:
    for child in Sc.utils.get_children_by_type(self, Control):
        Sc.gui.scale_gui_recursively(child)
    
    var cooldown_size: Vector2 = $WaveCooldown.rect_size
    
    rect_size.x = cooldown_size.x
    rect_size.y = \
            cooldown_size.y * cooldown_count + \
            _SEPARATION * (cooldown_count + 1)
    
    rect_position.x = \
            HudKeyValueBox.SEPARATION * Sc.gui.scale
    rect_position.y = \
            Sc.device.get_viewport_size().y - \
            rect_size.y - \
            HudKeyValueBox.SEPARATION * Sc.gui.scale
    
    return true


func update_indicator(
        indicator_name: String,
        cooldown_progress: float,
        count: int) -> void:
    var indicator := get_cooldown_indicator(indicator_name)
    indicator.set_progress(cooldown_progress)
    indicator.set_count(count)


func get_cooldown_indicator(indicator_name: String) -> CooldownIndicator:
    match indicator_name:
        "wave":
            return $WaveCooldown as CooldownIndicator
        "bobbit":
            return $BobbitCooldown as CooldownIndicator
        "dwarf":
            return $DwarfCooldown as CooldownIndicator
        "elf":
            return $ElfCooldown as CooldownIndicator
        "wizard":
            return $WizardCooldown as CooldownIndicator
        _:
            Sc.logger.error()
            return null
