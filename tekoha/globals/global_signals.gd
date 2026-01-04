extends Node

# Este script armazena sinais globais

# Sinais para a UI ser atualizada
signal wallet_updated(new_amout: int)
signal muiraquita_updated(id: int)

# Sinal para avisar que uma moeda foi coletada
signal coin_collected(value: int)
# Sinal para avisar que um muiraquita foi encontrado
signal new_muiraquita_found(id: int)
