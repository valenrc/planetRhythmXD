extends Node2D

signal cambiar_tecla(tecla)
signal cambiar_tecla2(tecla)
var scroll_speed = 2000
var skin
var accuracy
var score
var tutorial := false
var velocidad_planeta = 0.05
var Hit_tecla := "f"
var Hit_tecla2 := "j"
var nivel:String

var global_offset:int = 0 # offset visual en milisegundos
