class_name JumpyLabel extends Label


@onready var animator: AnimationPlayer = $Animator


func set_label(new_text: String) -> void:
	text = new_text
	animator.play("jump")