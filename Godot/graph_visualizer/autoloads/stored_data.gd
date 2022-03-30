extends Node2D
# class_name StoredData

enum mov_status {SELECT = 0, DRAG = 1}
var status : int = mov_status.DRAG;

const status_map = {
	"DRAG": mov_status.DRAG,
	"SELECT": mov_status.SELECT
}

func get_status():
	return status

func set_status(incoming_state: String):
	self.status = status_map[incoming_state]
