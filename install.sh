set -e
DEST="$HOME/bin"                         # carpeta destino; cámbiala si quieres
REPO_URL="https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/HEAD"

echo "📦 Instalando pantallazo-cli en $DEST …"
mkdir -p "$DEST"

curl -fsSL "$REPO_URL/bin/cap.sh" -o "$DEST/cap.sh"
chmod +x "$DEST/cap.sh"
echo "  • cap.sh instalado"

# Añadir PATH si hace falta
case ":$PATH:" in
  *":$DEST:"*) : ;;
  *)  echo "export PATH=\"$DEST:\$PATH\"" >> "$HOME/.zshrc"
      echo "➕ Añadido $DEST al PATH (en ~/.zshrc)"
     ;;
esac

# Añadir función + alias si no existen
grep -q "pantallazo()" "$HOME/.zshrc" || cat >> "$HOME/.zshrc" <<'EOB'

# ── pantallazo-cli ────────────────────────────────────────────────────
unalias pantallazo screenshot scrsht 2>/dev/null
pantallazo()  { cap.sh "$@"; }
screenshot()  { pantallazo "$@"; }
scrsht()      { pantallazo "$@"; }
# ──────────────────────────────────────────────────────────────────────
EOB

echo "✅ Instalación completada. Abre una nueva terminal o ejecuta: source ~/.zshrc"