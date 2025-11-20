# 🚀 Projeto Tekohá

### 📄 Sobre o Projeto
Este projeto é um jogo sobre preservação ambiental, que aborda também sobre o folclore paraense em sua narrativa.

### 🛠️ Como Contribuir
Para manter a organização e garantir a qualidade do código, siga as diretrizes abaixo ao contribuir com este projeto.

## 🌱 Criação de Novas Branches
Crie branches a partir da branch da release atual para desenvolver novas funcionalidades, corrigir bugs ou realizar melhorias. Utilize a seguinte convenção de nomenclatura para suas branches:

**1. Funcionalidades (features): feature/nome-da-feature**  
*Exemplo:* `feature/CARD-123-adicionar-algo`

**2. Correções de Bugs (fixes): fix/descricao-do-bug**  
*Exemplo:* `fix/CARD-234-erro-de-algo`

**3. Melhorias/Refatorações (refactor): refactor/descricao-da-melhoria**  
*Exemplo:* `refactor/CARD-345-otimizar-performance-de-algo`

**4. Documentação (docs): docs/descricao-da-doc**  
*Exemplo:* `docs/CARD-234-atualizar-readme-contribuicao`

### Para criar uma nova branch e alternar para ela:
```bash
git checkout main
```
``` bash
git pull origin main
```
``` bash
git checkout -b action/CARD-DO-TRELLO-titulo-da-task
```
## 📝 Padronização de nomenclaturas

### Arquivos

Usar **snake_case** para nomear arquivos.

*Exemplo:* `health_component.gd` (script) e `health_component.tscn`(cena)

### Classes e nodes

Usar **PascalCase** para nomear classes e nodes.

*Exemplo:* `class_name HealthComponent` e `HealthComponent`

### Métodos e variáveis

Usar **snakeCase** para nomear métodos e variáveis.

*Exemplo:* `func take_damage()` e `var current_health`

Adicione um _ para métodos que serão sobrescritos, métodos privados e variáveis privadas.

*Exemplo:* `var _player_speed` e `func _redraw_path()`

### Sinais

Usar **snakeCase** para nomear sinais.
Usar verbos no passado.

*Exemplo:* `signal health_changed`

### Constantes

Usar **CONSTANT_CASE para nomear constantes.**

*Exemplo:* `const MAX_HEALTH = 100`

### Enums

Usar **PascalCase** para nomear enums.

*Exemplo:* `enum PlayerState`

Usar **CONSTANT_CASE** para nomear elementos do enum.

*Exemplo:* `enum PlayerState {`
        `IDLE, `
        `WALKING, `
        `ATTACKING,`
`}`

## 🖥️ Organização do código

Definição da ordem em que as partes do código são declaradas, seguindo o padrão da documentação do Godot.
Essa ordem de código segue 4 regras básicas:

1. Sinais, enums, constantes e variáveis vêm primeiro, seguidos por métodos.
2. `public` vem antes de `private`.
3. Métodos da própria engine (virtual methods) vêm antes dos que serão criados.
4. Os métodos `_init` e `_ready` vêm antes dos métodos que modificam o node em tempo de execução.

```
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
	1. _init()
	2. _enter_tree()
	3. _ready()
	4. _process()
	5. _physics_process()
	6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses
```

# 💬 Mensagens de Commit

Escreva mensagens de commit claras e concisas, seguindo a convenção [Conventional Commits](https://www.conventionalcommits.org/). Esta convenção ajuda a gerar changelogs automaticamente e a entender o histórico do projeto.

### Formato básico
< tipo > : < descrição do commit >

[Corpo opcional do commit]


### Tipos comuns

| Tipo     | Descrição |
|----------|-----------|
| `feat`   | Uma nova funcionalidade |
| `fix`    | Uma correção de bug |
| `docs`   | Alterações na documentação |
| `style`  | Alterações que não afetam o significado do código (espaços em branco, formatação, etc.) |
| `refactor` | Uma mudança de código que não adiciona uma funcionalidade nem corrige um bug |
| `test`   | Adição ou correção de testes |
| `build`  | Alterações que afetam o sistema de build ou dependências externas (npm, yarn, gulp, etc.) |
| `ci`     | Alterações nos arquivos e scripts de CI |
| `perf`   | Uma mudança de código que melhora a performance |
| `chore`  | Outras mudanças que não modificam o código fonte ou testes |

### Exemplos

```plaintext
feat: Adiciona funcionalidade
```
``` plaintext
fix: Corrige erro de renderização do componente de lista

Este commit corrige um problema onde a lista de itens não estava sendo exibida corretamente em navegadores específicos.
```

### ⬆️ Pull Requests (PRs)

Ao finalizar suas alterações em uma branch, crie um Pull Request (PR) para a branch `release`.

**Ao criar um PR, certifique-se de:**

1.  **Revisar seu código:** Verifique se não há erros, código comentado desnecessariamente ou violações das diretrizes de codificação.
2.  **Testar suas alterações:** Garanta que suas modificações não quebraram funcionalidades existentes e que a nova funcionalidade ou correção funciona conforme o esperado.
3.  **Descrever o PR:** Forneça um título claro e uma descrição detalhada das alterações. Inclua:
    * **O que foi feito?**
    * **Por que foi feito?**
4.  **Solicitar revisão:** Marque os revisores.

---

### ⚙️ Instalação

1.  **Clone o repositório:**

    ```bash
    git clone https://github.com/DmNiv/Tekoha.git
    ```
    ```bash
    cd Tekoha
    ```

### 🤝 Stakeholders
Devs: Pedro, Carol, Maurício e Marcelo para consultas técnicas e aprovação de PRs.

📝 Notas de Execução para Futuras Releases
Antes de cada release, garantir que todas as features planejadas para a versão estejam mescladas na main.

Verificar a compatibilidade com ambientes de produção.
