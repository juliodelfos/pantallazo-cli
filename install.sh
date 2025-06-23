#!/bin/bash
set -e

DEST="$HOME/bin"
RAW_BASE="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/master"

echo "📦 Instalando pantallazo-cli en $DEST …"
mkdir -p "$DEST"

curl -fsSL "$RAW_BASE/bin/cap.sh" -o "$DEST/cap.sh"
chmod +x "$DEST/cap.sh"
echo "  • cap.sh instalado"

# ── Detectar shell y archivo de configuración ─────────────────────
SHELL_CONFIG=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    # Fallback: intentar detectar por archivos existentes
    if [[ -f "$HOME/.zshrc" ]]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [[ -f "$HOME/.bashrc" ]]; then
        SHELL_CONFIG="$HOME/.bashrc"
    else
        SHELL_CONFIG="$HOME/.zshrc"  # Crear zshrc por defecto
    fi
fi

echo "  • Usando archivo de configuración: $SHELL_CONFIG"

# ── Crear archivo de configuración si no existe ───────────────────
touch "$SHELL_CONFIG"

# ── 1. Añadir DEST al PATH solo una vez ─────────────────────────────
if ! grep -qE "^export PATH=\"$DEST" "$SHELL_CONFIG" 2>/dev/null; then
  echo -e "\nexport PATH=\"$DEST:\$PATH\"" >> "$SHELL_CONFIG"
  echo "  • PATH actualizado en $SHELL_CONFIG"
fi

# ── 2. Inyectar función + alias si faltan ───────────────────────────
if ! grep -q "__pantallazo_cli__" "$SHELL_CONFIG" 2>/dev/null; then
cat >> "$SHELL_CONFIG" <<'EOB'

# ── pantallazo-cli  (__pantallazo_cli__) ───────────────────────────
unalias pantallazo screenshot scrsht 2>/dev/null

pantallazo() { ~/bin/cap.sh "$@"; }
screenshot() { pantallazo "$@"; }
scrsht()     { pantallazo "$@"; }
# ───────────────────────────────────────────────────────────────────
EOB
  echo "  • Función y alias añadidos a $SHELL_CONFIG"
else
  echo "  • Bloque pantallazo-cli ya estaba presente"
fi

echo "✅ Instalación completada. Abre nueva terminal o ejecuta: source $SHELL_CONFIG"