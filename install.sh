#!/usr/bin/env bash
# install.sh – pantallazo-cli
set -e

DEST="$HOME/bin"
RAW_BASE="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/master"

echo "📦 Instalando pantallazo-cli en $DEST …"
mkdir -p "$DEST"

curl -fsSL "$RAW_BASE/bin/cap.sh" -o "$DEST/cap.sh"
chmod +x "$DEST/cap.sh"
echo "  • cap.sh instalado"

# ── 1. Asegura que $DEST está en el PATH (una sola vez) ────────────
if ! grep -qE "^export PATH=\"$DEST" \$HOME/.zshrc; then
  echo -e "\nexport PATH=\"$DEST:\$PATH\"" >> \$HOME/.zshrc
  echo "  • PATH actualizado en ~/.zshrc"
fi

# ── 2. Inyecta función + alias, evitando duplicados ────────────────
if ! grep -q "__pantallazo_cli__" \$HOME/.zshrc; then
cat >> \$HOME/.zshrc <<'EOB'

# ── pantallazo-cli  (__pantallazo_cli__) ───────────────────────────
unalias pantallazo screenshot scrsht 2>/dev/null

pantallazo() { ~/bin/cap.sh "\$@"; }
screenshot() { pantallazo "\$@"; }
scrsht()     { pantallazo "\$@"; }
# ───────────────────────────────────────────────────────────────────
EOB
  echo "  • Función y alias añadidos"
fi

echo "✅ Instalación completada. Abre nueva terminal o ejecuta: source ~/.zshrc"