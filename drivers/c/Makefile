.PHONY: safecutoffpower fanstop pwmfancontrol clean install-pwmFanControl install-safecutoffpower install-fanstop compile-all install-all

help: ## Prints all targets available and their description
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

safecutoffpower: safecutoffpower.c ## Compile safecutoffpower
	gcc -o safecutoffpower safecutoffpower.c

fanstop: fanStop.c ## Compile fanStop
	gcc -o fanStop fanStop.c

pwmfancontrol: pwmControlFan.c ## Compile pwmFanControl
	gcc -o pwmFanControl pwmControlFan.c

clean: ## Clean compiled files
	rm -rf safecutoffpower
	rm -rf pwmFanControl
	rm -rf fanStop

install-pwmFanControl: ## Install pwmFanControl
	sudo cp -rf pwmFanControl /usr/bin/pwmFanControl
	sudo chmod 755 /usr/bin/pwmFanControl

install-safecutoffpower: ## Install safecutoffpower
	sudo cp -rf safecutoffpower /usr/bin/safecutoffpower
	sudo chmod 755 /usr/bin/safecutoffpower

install-fanstop: ## Install fanstop
	sudo cp -rf fanstop /usr/bin/fanstop
	sudo chmod 755 /usr/bin/fanstop

compile-all: safecutoffpower fanstop pwmfancontrol ## Compile all utilities

install-all: install-pwmFanControl install-safecutoffpower install-fanstop ## Install pwmFanControl, safecutoffpower, fanstop