extends StaticBody2D

signal robot_entered
signal robot_exited

func enter():
	emit_signal("robot_entered")

func exit():
	emit_signal("robot_exited")
