class_name Spacecraft extends RigidBody2D

enum Type {ERRAND, ASSAULT, BATTLESHIP}

var health := 100

var type : Type
var task :=  TaskManager.Task.NONE
