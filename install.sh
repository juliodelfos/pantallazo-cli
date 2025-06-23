#!/usr/bin/env bash
# install.sh – pantallazo-cli (auto-sanador)
set -e

DEST="$HOME/bin"
RAW="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/master"

# ── Garantizar ~/.zshrc ───────────────────────────────────────────────
[ -f "$HOME/.zshrc" ] || { touch "$HOME/.zshrc"; echo "🆕 Creado ~/.zshrc"; }

# ── Descargar script ─────────────────────────────────────────────────
echo "📦 Instalando pantallazo-cli en $DEST …"
mkdir -p "$DEST"
curl -fsSL "$RAW/bin/cap.sh" -o "$DEST/cap.sh"
chmod +x "$DEST/cap.sh"
echo "  • cap.sh instalado"

# ── Limpiar bloques antiguos ─────────────────────────────────────────
sed -i '' '/pantallazo-cli  (/,+10d' "$HOME/.zshrc"            # bloques marcados
sed -i '' '/\/Nextcloud\/scripts\/cap.sh/d' "$HOME/.zshrc"     # rutas viejas
sed -i '' '/pantallazo() { .*"\\\$@"/d' "$HOME/.zshrc"         # "$@" escapado

# ── Asegurar PATH ────────────────────────────────────────────────────
if ! grep -qE "^export PATH=\"$DEST" "$HOME/.zshrc"; then
  echo -e "\nexport PATH=\"$DEST:\$PATH\"" >> "$HOME/.zshrc"
  echo "  • PATH actualizado en ~/.zshrc"
fi

# ── Insertar bloque correcto (si no está) ────────────────────────────
if ! grep -q "__pantallazo_cli__" "$HOME/.zshrc"; then
cat >> "$HOME/.zshrc" <<'EOB'

# ── pantallazo-cli  (__pantallazo_cli__) ───────────────────────────
unalias pantallazo screenshot scrsht 2>/dev/null
pantallazo() { ~/bin/cap.sh "$@"; }
screenshot() { pantallazo "$@"; }
scrsht()     { pantallazo "$@"; }
# ───────────────────────────────────────────────────────────────────
EOB
  echo "  • Función y alias añadidos a ~/.zshrc"
fi

echo "✅ Instalación completada. Abre nueva terminal o ejecuta: source ~/.zshrc"