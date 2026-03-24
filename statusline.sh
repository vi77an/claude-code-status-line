#!/bin/bash
#
# Status Line para Claude Code
# Tema: Catppuccin Mocha
# Dados reais do contexto via statusLine hook
#

# Cores Catppuccin Mocha
CYAN="\033[38;2;148;226;213m"
MAUVE="\033[38;2;203;166;247m"
PEACH="\033[38;2;250;179;135m"
GREEN="\033[38;2;166;227;161m"
YELLOW="\033[38;2;249;226;175m"
RED="\033[38;2;243;139;168m"
SURFACE="\033[38;2;49;50;57m"
OVERLAY="\033[38;2;103;103;120m"
RESET="\033[0m"

# Lê JSON do stdin
input=$(cat)

# Extrai dados com fallbacks
MODEL=$(echo "$input" | jq -r '.model.display_name // "unknown"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
DIR=$(echo "$input" | jq -r '.workspace.current_dir' | xargs -I{} basename {})
DURATION_MS=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')

# Cor da barra baseada na porcentagem
if [ "$PCT" -ge 90 ]; then
    BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ]; then
    BAR_COLOR="$YELLOW"
else
    BAR_COLOR="$GREEN"
fi

# Construir barra de progresso
BAR_WIDTH=10
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
[ "$FILLED" -gt 0 ] && printf -v FILL "%${FILLED}s" && BAR="${FILL// /█}"
[ "$EMPTY" -gt 0 ] && printf -v PAD "%${EMPTY}s" && BAR="${BAR}${PAD// /░}"

# Git branch
BRANCH=""
if git rev-parse --git-dir > /dev/null 2>&1; then
    BRANCH_STR=$(git branch --show-current 2>/dev/null)
    [ -n "$BRANCH_STR" ] && BRANCH=" $SURFACE·$RESET $MAUVE$BRANCH_STR$RESET"
fi

# Formatar duração
MINS=$((DURATION_MS / 60000))
SECS=$(((DURATION_MS % 60000) / 1000))

# Custo formatado
COST_FMT=$(printf '$%.2f' "$COST")

# Linha 1: modelo + dir + git
echo -e "${CYAN}[$MODEL]$RESET $SURFACE@$RESET $PEACH$DIR$RESET$BRANCH"

# Linha 2: barra de contexto + tokens + custo + duração
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
OUTPUT_TOKENS=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
TOTAL_TOKENS=$((INPUT_TOKENS + OUTPUT_TOKENS))

format_k() {
    local num=$1
    if [ $num -ge 1000 ]; then
        printf "%.1fk" "$(echo "scale=1; $num/1000" | bc)"
    else
        echo "$num"
    fi
}

echo -e "${BAR_COLOR}${BAR}${RESET} ${PCT}% ${SURFACE}·$RESET ${YELLOW}$(format_k $INPUT_TOKENS)${SURFACE}/${RESET}${YELLOW}$(format_k $OUTPUT_TOKENS)${RESET} ${SURFACE}·$RESET ${PEACH}$COST_FMT${SURFACE} ·${RESET} ${CYAN}${MINS}m${SECS}s${RESET}"
