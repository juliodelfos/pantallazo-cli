# -------- parámetros --------------------------------------------------
DIR_DEFAULT=~/Downloads/Capturas\ de\ pantalla
TARGET_DIR="${PANTALLAZO_DIR:-$DIR_DEFAULT}"

FLAG_NOTE=0 FLAG_COPY=0 FLAG_VER=0 FLAG_TERM=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --nota|--annotate) FLAG_NOTE=1 ;;
    --copiar|--copy)   FLAG_COPY=1 ;;
    --ver)             FLAG_VER=1  ;;
    --term)            FLAG_TERM=1 ;;
    -d|--dir)          TARGET_DIR="$2"; shift ;;
    -h|--help|help)
      cat <<'EOM'
pantallazo / screenshot / scrsht – ayuda rápida
  sin flags           copia área → portapapeles (oculta terminal)
  --nota              guarda PNG + Preview (oculta terminal)
  --nota --copiar     idem + copia PNG
  --ver               guarda + Preview, NO oculta terminal
  --term              no oculta terminal (override)
  -d, --dir <ruta>    carpeta destino (reemplaza predeterminada)
  env PANTALLAZO_DIR  define carpeta destino por variable de entorno
EOM
      exit 0 ;;
  esac
  shift
done

# -------- ruta y nombre ----------------------------------------------
NOW=$(date +"%Y-%m-%d_%H-%M-%S")
FILE="$TARGET_DIR/cap_$NOW.png"
mkdir -p "$TARGET_DIR"

# -------- ocultar Ghostty --------------------------------------------
if [[ $FLAG_TERM -eq 0 && $FLAG_VER -eq 0 ]]; then
  osascript -e \
  'tell application "System Events" to set visible of application process "Ghostty" to false'
fi

# -------- modos -------------------------------------------------------
# Modo vista rápida
if [[ $FLAG_VER -eq 1 ]]; then
  screencapture -i "$FILE" && open -a Preview "$FILE"
  exit 0
fi

# Modo anotación
if [[ $FLAG_NOTE -eq 1 ]]; then
  screencapture -i "$FILE" && open -a Preview "$FILE"
  [[ $FLAG_COPY -eq 1 ]] && \
    osascript -e "set the clipboard to (read (POSIX file \"$FILE\") as JPEG picture)"
else
  # Modo rápido: solo al portapapeles
  screencapture -ci
fi