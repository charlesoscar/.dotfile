# Makefile: install prerequisites only

SHELL := /usr/bin/env bash
.SHELLFLAGS := -eu -o pipefail -c

.PHONY: help deps

help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"}; /^[a-zA-Z0-9_-]+:.*?##/ {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

deps: ## Install common prerequisites (auto-detects apt or Homebrew)
	@set -euo pipefail; \
	if command -v apt-get >/dev/null 2>&1; then \
	  echo "[deps] Using apt-get"; \
	  sudo apt-get update; \
	  sudo apt-get install -y \
	    zsh git fzf fd-find ripgrep bat tree zoxide python3 iproute2 \
	    p7zip-full unzip unrar ncompress stow; \
	  # Normalize Debian/Ubuntu names (optional) \
	  if command -v batcat >/dev/null 2>&1; then sudo update-alternatives --install /usr/local/bin/bat bat /usr/bin/batcat 10; fi; \
	  if command -v fdfind  >/dev/null 2>&1; then sudo update-alternatives --install /usr/local/bin/fd  fd  /usr/bin/fdfind 10; fi; \
	elif command -v brew >/dev/null 2>&1; then \
	  echo "[deps] Using Homebrew"; \
	  brew update; \
	  brew install zsh git fzf fd ripgrep bat tree zoxide python3 p7zip unzip unrar stow; \
	else \
	  echo "Unsupported distro. Please install: zsh, git, fzf, fd/fdfind, ripgrep, bat, tree, zoxide, python3, archivers (7zip/unzip/unrar), and stow."; \
	  exit 2; \
	fi
