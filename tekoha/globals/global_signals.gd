extends Node

# Este script armazena sinais globais

# Sinais para a UI ser atualizada
signal wallet_updated(new_amout: int)
signal muiraquita_updated(id: int)

# Sinal para avisar que uma moeda foi coletada
signal coin_collected(value: int)
# Sinal para avisar que um muiraquita foi encontrado
signal new_muiraquita_found(id: int)


# Sinal para avisar que o player entrou em uma porta 
signal door_entered()

# Sinal para avisar que a animação de transição está na metade
signal animation_midpoint_reached()

# Sinal para avisar que o carregamento do level terminou
signal level_loading_finished()

## Sinal para avisar que o estado do jogo mudou
#signal game_state_changed(new_state: GameManager.GameState)
