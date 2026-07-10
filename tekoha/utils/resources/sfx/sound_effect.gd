class_name SoundEffect 
extends Resource
# Recurso de efeito sonoro. Guarda os dados de um SFX específico.

# Registre os tipos de sons aqui para facilitar a chamada no código.
enum SOUND_EFFECT_TYPE {
	# Adicionar os tipos de SFXs
	CURUPIRA_WALK,
	CURUPIRA_ATTACK_1,
	CURUPIRA_ATTACK_2,
	CURUPIRA_ROLL,
	CURUPIRA_STUN,
	CURUPIRA_DEATH,
	BREAKING_POT,
	BUSH,
	PICKUP_ITEM,
	BUTTON_FOCUS,
	OPEN_MENU,
	CLOSE_MENU,
	SAVE,
	BOAT_MOTOR_START,
	BOAT_MOTOR_LOOP,
	BUTTON_CLICK,
	UI_ERROR,
	SACOLA_ATTACK,
	TYPING,
	LOW_HEALTH,
}

@export_range(0, 10) var limit: int = 5 # Limite de reproduções simultâneas deste som.
@export var type: SOUND_EFFECT_TYPE # O identificador único deste som.
@export var sound_effect: AudioStream # O arquivo de áudio (.wav, .ogg, etc).
@export_range(-40, 20) var volume: float = 0.0 # O volume base do efeito.
@export_range(0.0, 4.0, 0.01) var pitch_scale: float = 1.0 # A velocidade/tom base.
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0 # Variação aleatória do tom.

var audio_count: int = 0 # Quantas instâncias desse som estão tocando agora.

func change_audio_count(amount: int) -> void:
	audio_count = max(0, audio_count + amount)

func has_open_limit() -> bool:
	return audio_count < limit

func on_audio_finished() -> void:
	change_audio_count(-1)
