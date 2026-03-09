extends AudioStreamPlayer


var bpm: float
var beat_length: float
var offset: float

var current_beat: float
var song_position: float:
	set(value):
		song_position = value
		current_beat = value / beat_length


func _physics_process(_delta: float) -> void:
	if not playing:
		return
	song_position = get_playback_position() + AudioServer.get_time_since_last_mix() - offset


func set_song(song: AudioStream, _bpm: float, _offset: float = 0, volume: float = 0) -> void:
	stream = song
	bpm = _bpm
	beat_length = 60 / bpm
	offset = _offset / 1000
	volume_db = volume
