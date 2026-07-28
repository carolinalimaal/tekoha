class_name MusicTrack
extends Resource
# Recurso de música de fundo. Guarda os dados de uma BGM específica.

@export var track: AudioStream # O arquivo de áudio (.wav, .mp3, etc).
@export_range(-40, 20) var volume: float = 0.0 # O volume base da faixa.
