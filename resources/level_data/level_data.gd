class_name LevelData extends Resource


@export_group("Level")
@export var length: float = 24
@export var windows: WindowsData

@export_group("Song")
@export var song_file: AudioStream
@export var bpm: float = 120
@export var offset: float = 0
@export var db_modifier: float = 0
