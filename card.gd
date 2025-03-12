extends Node2D
class_name Card

signal move(card: Card)

var max_rotation: float = 0.05
var rest_position: Vector2 = Vector2.ZERO
var mouse_offset: Vector2 = Vector2.ZERO

var number: int = 1
var red: bool = false
var shape: int = 0
var shown: bool = false

var location: Main.Location = Main.Location.Stack
var tab: int = -1
var row: int = -1

var ColorRed: Color = Color.CRIMSON
var ColorBlack: Color = Color.from_hsv(0, 0, 0.08)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate(randf_range(-max_rotation, max_rotation))
	$Letter.text = Main.letters[number - 1] + " " + Main.shapes[shape]

	if self.red:
		$Letter.add_theme_color_override("font_color", ColorRed)
	else:
		$Letter.add_theme_color_override("font_color", ColorBlack)
		
	if shown:
		$Letter.show()
		$Backside.hide()
		$Button.disabled = false
	else:
		$Letter.hide()
		$Backside.show()
		$Button.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Button.button_pressed:
		global_position = get_global_mouse_position() - mouse_offset
		grabbed = true
	else:
		return_to_rest(delta)
		grabbed = false

func return_to_rest(delta: float) -> void:
	if (rest_position.distance_squared_to(position) < 2):
		position = rest_position
	else:
		position -= (position - rest_position) * 15 * delta

func reveal():
	if shown:
		return
	shown = true
	$AnimationPlayer.play("reveal")

func unreveal():
	if !shown:
		return
	shown = false
	disable_grab()
	$AnimationPlayer.play_backwards("reveal")

func enable_grab():
	if $Button.disabled:
		$Button.disabled = false
		#print("Card " + str(self) + " enabled grab")

func disable_grab():
	if not $Button.disabled:
		$Button.disabled = true
		#print("Card " + str(self) + " disabled grab")

func format(simple: bool = true) -> String:
	var nam = Main.letters[number - 1] + Main.shapes[shape]
	if simple:
		return nam
	else:
		return nam + " [" + str(tab) + ", " + str(row) + "]"

func _to_string() -> String:
	return format(false)

func _on_button_down() -> void:
	mouse_offset = get_local_mouse_position()

func _on_button_up() -> void:
	move.emit(self)
