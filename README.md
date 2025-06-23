# pantallazo-cli

Script de línea de comandos para **capturas de pantalla avanzadas** en macOS.

| Comando básico | Descripción |
|----------------|-------------|
| `pantallazo`               | Copia un área al portapapeles y oculta la terminal |
| `pantallazo --nota`        | Guarda PNG en la carpeta destino y abre Preview |
| `pantallazo --nota --copiar` | Igual que anterior, pero copia el PNG al portapapeles |
| `pantallazo --ver`         | Guarda PNG + Preview **sin** ocultar la terminal |
| `pantallazo --term …`      | Nunca oculta la terminal (sobrescribe lo anterior) |
| Alias equivalentes         | `screenshot`, `scrsht` |

> Por defecto las capturas se guardan en: `~/Downloads/Capturas de pantalla`

---

## Instalación rápida

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/juliodelfos/pantallazo-cli/main/install.sh)
```

El instalador:

1. Copia `cap.sh` a `~/bin`.
2. Añade `~/bin` al `PATH` (si hace falta).
3. Crea la función `pantallazo()` y los alias `screenshot` y `scrsht` en tu `~/.zshrc`.

Reabre la terminal o ejecuta `source ~/.zshrc` y ya podrás usarlo.

---

## Carpeta de destino personalizable

| Método | Ejemplo | Nota |
|--------|---------|------|
| Variable permanente | `export PANTALLAZO_DIR=~/Nextcloud/Capturas` | Ponla en tu `~/.zshrc` |
| Flag puntual       | `pantallazo --dir ~/Pictures --nota`         | Sólo para esa ejecución |

---

## Ayuda integrada

```bash
pantallazo --help
```

Muestra la guía rápida con todos los flags y ejemplos.

---

## Desinstalación

```bash
rm -f ~/bin/cap.sh
sed -i '' '/pantallazo() {/,/scrsht() {/d' ~/.zshrc
```

---

## Licencia

MIT © [juliodelfos](https://github.com/juliodelfos)