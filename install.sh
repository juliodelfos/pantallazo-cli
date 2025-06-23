set -e

# ── 0. Asegurar que ~/.zshrc exista ─────────────────────────────────
[ -f "$HOME/.zshrc" ] || { touch "$HOME/.zshrc"; echo "🆕 Creado ~/.zshrc"; }

# ── 1. Descarga del script ──────────────────────────────────────────
DEST="$HOME/bin"                                            # carpeta destino
RAW_BASE="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/master"

echo "📦 Instalando pantallazo-cli en $DEST …"
mkdir -p "$DEST"

curl -fsSL "$RAW_BASE/bin/cap.sh" -o "$DEST/cap.sh"
chmod +x "$DEST/cap.sh"
echo "  • cap.sh instalado"

# ── 2. Añadir DEST al PATH (solo si falta) ──────────────────────────
if ! grep -qE "^export PATH=\"$DEST" "$HOME/.zshrc"; then
  echo -e "\nexport PATH=\"$DEST:\$PATH\"" >> "$HOME/.zshrc"
  echo "  • PATH actualizado en ~/.zshrc"
fi

# ── 3. Inyectar función + alias (evitar duplicados) ─────────────────
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
else
  echo "  • Bloque pantallazo-cli ya estaba presente (no duplicado)"
fi

echo "✅ Instalación completada. Abre nueva terminal o ejecuta: source ~/.zshrc"