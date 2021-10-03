tool
class_name CooldownIndicator
extends ScaffolderPanelContainer


const _SIZE := Vector2(128.0, 32.0)
const _FRAME_COUNT := 17

export var label := "" setget _set_label

var _count := -1


func _ready() -> void:
    _on_gui_scale_changed()


func _on_gui_scale_changed() -> bool:
    for child in Sc.utils.get_children_by_type(self, Control):
        Sc.gui.scale_gui_recursively(child)
    
    var size: Vector2 = _SIZE * Sc.gui.scale
    rect_min_size = size
    rect_size = size
    $HBoxContainer.rect_min_size = size
    $HBoxContainer.rect_size = size
    
    return true


# -   progress: From 0 to 1.
func set_progress(progress: float) -> void:
    if is_inf(progress):
        progress = 0.0
    progress = clamp(progress, 0.0, 0.99)
    var index := int(_FRAME_COUNT * progress)
    $HBoxContainer/Progress.frame = index


func set_count(count: int) -> void:
    self._count = count
    if self._count == INF or \
            self._count < 0.0:
        # TODO: Add an infinity symbol to the font, and use that (∞).
        $HBoxContainer/Count.text = ""
        $HBoxContainer/Count.visible = false
        $HBoxContainer/Spacer3.visible = false
    else:
        $HBoxContainer/Count.text = "x%d" % self._count
        $HBoxContainer/Count.visible = true
        $HBoxContainer/Spacer3.visible = true


func _set_label(value: String) -> void:
    label = value
    $HBoxContainer/Label.text = value
