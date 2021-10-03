tool
class_name ControlButtons
extends ScaffolderPanelContainer


const _SEPARATION := 4.0

var button_count := 0


func _ready() -> void:
    Sc.gui.add_gui_to_scale(self)
    _on_gui_scale_changed()


func on_schedule_ready() -> void:
    $HBoxContainer/BoulderButton.visible = false
    $HBoxContainer/BaldrockButton.visible = false
    $HBoxContainer/OrcButton.visible = false
    
    button_count = 1
    
    if Sc.level_session.get_is_boulder_in_level():
        $HBoxContainer/BoulderButton.visible = true
        button_count += 1
    if Sc.level_session.get_is_baldrock_in_level():
        $HBoxContainer/BaldrockButton.visible = true
        button_count += 1
    if Sc.level_session.get_is_orc_in_level():
        $HBoxContainer/OrcButton.visible = true
        button_count += 1
    
    _on_gui_scale_changed()


func _destroy() -> void:
    Sc.gui.remove_gui_to_scale(self)
    if !is_queued_for_deletion():
        queue_free()


func _on_gui_scale_changed() -> bool:
    for child in Sc.utils.get_children_by_type(self, Control):
        Sc.gui.scale_gui_recursively(child)
    
    var button_size: Vector2 = $HBoxContainer/TremorButton.rect_size
    
    rect_size.x = \
            button_size.x * button_count + \
            _SEPARATION * (button_count + 1)
    rect_size.y = button_size.y
    
    rect_position.x = \
            Sc.device.get_viewport_size().x - \
            rect_size.x - \
            HudKeyValueBox.SEPARATION * Sc.gui.scale * 2.0
    rect_position.y = \
            Sc.device.get_viewport_size().y - \
            rect_size.y - \
            HudKeyValueBox.SEPARATION * Sc.gui.scale * 2.0
    
    return true


func set_button_enabled(
        button_name: String,
        is_enabled: bool) -> void:
    var button := get_button(button_name)
    button.disabled = !is_enabled


# FIXME: ----------------------- Fix this to actually work.
func set_button_hard_pressed(
        button_name: String,
        is_pressed: bool) -> void:
    var button := get_button(button_name)
    button.get_node("TextureButton").pressed = is_pressed


func get_button(button_name: String) -> ScaffolderTextureButton:
    match button_name:
        "tremor":
            return $HBoxContainer/TremorButton as ScaffolderTextureButton
        "boulder":
            return $HBoxContainer/BoulderButton as ScaffolderTextureButton
        "orc":
            return $HBoxContainer/OrcButton as ScaffolderTextureButton
        "baldrock":
            return $HBoxContainer/BaldrockButton as ScaffolderTextureButton
        _:
            Sc.logger.error()
            return null


func _on_TremorButton_pressed() -> void:
    Sc.level.trigger_tremor()


func _on_BoulderButton_pressed() -> void:
    Sc.level.trigger_boulder_selection_mode()


func _on_BaldrockButton_pressed() -> void:
    Sc.level.trigger_baldrock_selection_mode()


func _on_OrcButton_pressed() -> void:
    Sc.level.trigger_orc_selection_mode()
