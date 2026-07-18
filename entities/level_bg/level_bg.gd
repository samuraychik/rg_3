class_name LevelBg extends ColorRect


@export var animation_speed: float = 0.1:
  set(value):
    animation_speed = value
    material.set_shader_parameter("speed", animation_speed)
