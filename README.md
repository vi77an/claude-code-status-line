# Claude Code Status Line

Script personalizado para exibir dados reais do contexto na barra de status do Claude Code.

## O que exibe

- Modelo da IA
- Diretório atual e branch do git
- Barra de progresso do contexto (verde/amarelo/vermelho conforme uso)
- Tokens de entrada/saída
- Custo da sessão
- Duração da sessão
<img width="1026" height="725" alt="Captura de tela de 2026-03-23 23-14-30" src="https://github.com/user-attachments/assets/e8b46e04-cf5b-4d5d-a74c-74ad2be4b10f" />

## Instalação

1. Copie `statusline.sh` para `~/.claude/statusline.sh`
2. Adicione ao `settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "~/.claude/statusline.sh"
  }
}
```

3. Reinicie o Claude Code

## Configuração de cores

O script usa cores Catppuccin Mocha. Edite as variáveis no topo do arquivo se preferir outras cores.

## Uso no terminal CLI

Este status line funciona apenas no modo CLI do Claude Code, não no VS Code/Desktop.

Para terminal normal, use o comando `/context` dentro do Claude Code para ver dados de tokens.

---

**Feito com 🩷 por [@vi77an](https://t.me/vi77an)**
