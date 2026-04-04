extends Node2D
# Autoload Global para gerenciar Efeitos Sonoros Dinâmicos e Música de Fundo.

# CONFIGURAÇÕES DE SFX
var sound_effect_dict: Dictionary = {}
@export var sound_effects: Array[SoundEffect]

# CONFIGURAÇÕES DE BGM
var bgm_player: AudioStreamPlayer

func _ready() -> void:
	# 1. Inicia o sistema de Música (BGM)
	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music" # Envia para o bus de Música
	add_child(bgm_player)
	
	# 2. Prepara o dicionário de Efeitos Sonoros (SFX)
	for sound_effect: SoundEffect in sound_effects:
		sound_effect_dict[sound_effect.type] = sound_effect


# FUNÇÕES DE BGM
# Toca uma música de fundo. Se já houver uma tocando, faz um fade out antes.
func play_background_sound(new_sound: AudioStream, fade_time: float = 1.0) -> void:
	if bgm_player.stream == new_sound and bgm_player.playing:
		return
		
	if bgm_player.playing:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", -80.0, fade_time)
		tween.tween_callback(func():
			bgm_player.stream = new_sound
			bgm_player.play()
			bgm_player.volume_db = 0.0
		)
	else:
		bgm_player.stream = new_sound
		bgm_player.volume_db = 0.0
		bgm_player.play()

# Para a música imediatamente.
# Precisa ser chamado se a próxima sala não iniciar uma nova música.
func stop_background_sound(fade_time: float = 1.0) -> void:
	if bgm_player.playing:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", -80.0, fade_time)
		tween.tween_callback(func():
			bgm_player.stop()
			bgm_player.volume_db = 0.0
		)


# FUNÇÕES DE SFX (Efeitos Sonoros)
# Cria um som espacial 2D em uma localização específica (ex: passos, impacto).
func create_2d_audio_at_location(location: Vector2, type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			
			new_2D_audio.position = location
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.bus = "SFX" # Envia para o bus de SFX
			
			# Calcula a variação de tom
			var variacao = randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_2D_audio.pitch_scale = sound_effect.pitch_scale + variacao
			
			# Limpeza automática ao terminar
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()
	else:
		push_error("AudioManager: Tipo de som não registrado - ", type)

# Cria um som global que toca igual independente da câmera (ex: UI, level up).
func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE) -> void:
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_audio)
			
			new_audio.stream = sound_effect.sound_effect
			new_audio.volume_db = sound_effect.volume
			new_audio.bus = "SFX" # Envia para o bus de SFX
			
			var variacao = randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_audio.pitch_scale = sound_effect.pitch_scale + variacao
			
			new_audio.finished.connect(sound_effect.on_audio_finished)
			new_audio.finished.connect(new_audio.queue_free)
			new_audio.play()
	else:
		push_error("AudioManager: Tipo de som não registrado - ", type)
