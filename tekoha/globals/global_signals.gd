extends Node

# Este script armazena sinais globais

# Sinais para a UI ser atualizada
signal wallet_updated(new_amout: int)

# Sinal para avisar que uma moeda foi coletada
signal coin_collected(value: int)
