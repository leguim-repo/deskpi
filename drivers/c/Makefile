all: safecutoffpower fanstop pwmfancontrol

safecutoffpower:  safecutoffpower.c 
	gcc -o safecutoffpower safecutoffpower.c

fanstop: fanstop.c
	gcc -o fanStop fanStop.c

pwmfancontrol: pwmControlFan.c
	gcc -o pwmFanControl pwmControlFan.c

clean:
	rm -rf safecutoffpower

