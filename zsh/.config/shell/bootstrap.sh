#!/usr/bin/env bash

set -euo pipefail

ANTIDOTE_DIR="${HOME}/.antidote"
P10K_DIR="${HOME}/.p10k"        # Theme repo (directory)
PLUGINS_TXT="${HOME}/.zsh_plugins.txt"
PLUGINS_ZSH="${HOME}.zsh_plugins.zsh"

if [[ ! -f "${ANTIDOTE_DIR}/antidote.zsh" ]]; then
  git clone --quiet --depth=1 https://github.com/mattmc3/antidote "${ANTIDOTE_DIR}"
fi

if [[ ! -d "${P10K_DIR}" ]]; then
  git clone --quiet --depth=1 https://github.com/romkatv/powerlevel10k.git "${P10K_DIR}"
fi

if [[ -r "${PLUGINS_TXT}" ]]; then
  zsh -lc "source '${ANTIDOTE_DIR}/antidote.zsh'; antidote bundle < '${PLUGINS_TXT}' > '${PLUGINS_ZSH}'"
fi

echo "Bootstrap complete. Restart zsh."
