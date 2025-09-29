EXTENSIONS := AlphabeticalAppGrid@stuarthayhurst \
			  alt-tab-current-monitor@esauvisky.github.io \
			  caffeine@patapon.info \
			  clipboard-history@alexsaveau.dev \
			  color-picker@tuberry \
			  dash-to-dock@micxgx.gmail.com \
			  eepresetselector@ulville.github.io \
			  gnome-ui-tune@itstime.tech \
			  just-perfection-desktop@just-perfection \
			  logomenu@aryan_k \
			  mprisLabel@moon-0xff.github.com \
			  quick-settings-tweaks@qwreey \
			  tailscale@joaophi.github.com \
			  top-bar-organizer@julian.gse.jsts.xyz \
			  user-theme@gnome-shell-extensions.gcampax.github.com \
			  warptoggle@mrvladus.github.io \

stow:
	@command -v stow >/dev/null 2>&1 || echo "missing stow" && exit 1
	@stow --target=$$HOME --restow --verbose=1 dotfiles/

install-extensions:
	@command -v uvx >/dev/null 2>&1 || echo "missing uvx" && exit 1
	@for ext in $(EXTENSIONS); do uvx install $$ext || exit 1; done
