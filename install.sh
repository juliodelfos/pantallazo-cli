set -e

DEST="${HOME}/bin"                              # carpeta destino
RAW_BASE="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/master"

echo "📦 Instalando pantallazo-cli en ${DEST} …"
mkdir -p "$DEST"

curl -fsSL "${RAW_BASE}/bin/cap.sh" -o "${DEST}/cap.sh"
chmod +x "${DEST}/cap.sh"
echo "  • cap.sh instalado"

# Añadir DEST al PATH si falta
grep -qxF "export PATH=\"${DEST}:\$PATH\"" "$HOME/.zshrc" || {
  echo "export PATH=\"${DEST}:\$PATH\"" >> "$HOME/.zshrc"
  echo "  • PATH actualizado en ~/.zshrc"
}

# Inyectar función + alias solo si no existen
if ! grep -q "__pantallazo_cli__" "$HOME/.zshrc"; then
cat >> "$HOME/.zshrc" <<'EOB'

# ── pantallazo-cli  (__pantallazo_cli__) ─────────────────────────────
unalias pantallazo screenshot scrsht 2>/dev/null

pantallazo() { ~/bin/cap.sh "\$@"; }
screenshot() { pantallazo "\$@"; }
scrsht()     { pantallazo "\$@"; }
# ────────────────────────────────────────────────────────────────────
EOB
  echo "  • Función y alias añadidos a ~/.zshrc"
else
  echo "  • Bloque pantallazo-cli ya estaba en ~/.zshrc (no duplicado)"
fi

echo "✅ Instalación completada. Abre nuevo terminal o ejecuta: source ~/.zshrc"