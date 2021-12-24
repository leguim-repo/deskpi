help: ## prints all targets available and their description
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

all: safecutoffpower fanstop pwmfancontrol ## Compile all utilities

safecutoffpower:  safecutoffpower.c  ## Compile safecutoffpower
	gcc -o safecutoffpower safecutoffpower.c

fanstop: fanStop.c  ## Compile fanStop
	gcc -o fanStop fanStop.c

pwmfancontrol: pwmControlFan.c ## Compile pwmFanControl
	gcc -o pwmFanControl pwmControlFan.c

clean: ## Clean compiled files
	rm -rf safecutoffpower
        rm -rf pwmFanControl
        rm -rf fanStop

install-pwmFanControl: pwmFanControl ## Install pwmFanControl
	sudo cp -rf pwmFanControl /usr/bin/pwmFanControl
	sudo chmod 755 /usr/bin/pwmFanControl

