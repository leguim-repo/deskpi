#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root or with sudo"
  exit
fi
. /lib/lsb/init-functions

daemonname="deskpi"
tempmonscript=/usr/bin/pmwFanControl
deskpidaemon=/lib/systemd/system/$daemonname.service
safeshutdaemon=/lib/systemd/system/$daemonname-safeshut.service
installationfolder=$(pwd)

echo "* * * * * Installing udev rule * * * * *"
sudo cp $installationfolder/udev_rules/99-deskpi-pro.rules /etc/udev/rules.d/

make -C $installationfolder/drivers/c/ compile-all


# install wiringPi library.
log_action_msg "DeskPi Fan control script installation Start." 

# Create service file on system.
if [ -e $deskpidaemon ]; then
	sudo rm -f $deskpidaemon
fi

# adding dtoverlay to enable dwc2 on host mode.
log_action_msg "Enable dwc2 on Host Mode"
sudo sed -i '/dtoverlay=dwc2*/d' /boot/config.txt 
sudo sed -i '$a\dtoverlay=dwc2,dr_mode=host' /boot/config.txt 
if [ $? -eq 0 ]; then
   log_action_msg "dwc2 has been setting up successfully"
fi

# install PWM fan control daemon.
log_action_msg "DeskPi main control service loaded."
cd $installationfolder/drivers/c/ 
sudo cp -rf $installationfolder/drivers/c/pwmFanControl /usr/bin/
sudo cp -rf $installationfolder/drivers/c/fanStop  /usr/bin/
sudo chmod 755 /usr/bin/pwmFanControl
sudo chmod 755 /usr/bin/fanStop
sudo cp -rf $installationfolder/deskpi-config /usr/bin/
sudo cp -rf $installationfolder/Deskpi-uninstall /usr/bin/
sudo chmod 755 /usr/bin/deskpi-config
sudo chmod 755 /usr/bin/Deskpi-uninstall

# Build Fan Daemon
echo "[Unit]" > $deskpidaemon
echo "Description=DeskPi PWM Control Fan Service" >> $deskpidaemon
echo "After=multi-user.target" >> $deskpidaemon
echo "[Service]" >> $deskpidaemon
echo "Type=simple" >> $deskpidaemon
echo "RemainAfterExit=no" >> $deskpidaemon
echo "ExecStart=sudo /usr/bin/pwmFanControl" >> $deskpidaemon
echo "[Install]" >> $deskpidaemon
echo "WantedBy=multi-user.target" >> $deskpidaemon

# send signal to MCU before system shuting down.
echo "[Unit]" > $safeshutdaemon
echo "Description=DeskPi Safeshutdown Service" >> $safeshutdaemon
echo "Conflicts=reboot.target" >> $safeshutdaemon
echo "Before=halt.target shutdown.target poweroff.target" >> $safeshutdaemon
echo "DefaultDependencies=no" >> $safeshutdaemon
echo "[Service]" >> $safeshutdaemon
echo "Type=oneshot" >> $safeshutdaemon
echo "ExecStart=/usr/bin/sudo /usr/bin/fanStop" >> $safeshutdaemon
echo "RemainAfterExit=yes" >> $safeshutdaemon
echo "TimeoutSec=1" >> $safeshutdaemon
echo "[Install]" >> $safeshutdaemon
echo "WantedBy=halt.target shutdown.target poweroff.target" >> $safeshutdaemon

log_action_msg "DeskPi Service configuration finished." 
sudo chown root:root $safeshutdaemon
sudo chmod 644 $safeshutdaemon

sudo chown root:root $deskpidaemon
sudo chmod 644 $deskpidaemon

log_action_msg "DeskPi Service Load module." 
sudo systemctl daemon-reload
sudo systemctl enable $daemonname.service
sudo systemctl start $daemonname.service &
sudo systemctl enable $daemonname-safeshut.service

# Finished 
log_success_msg "DeskPi PWM Fan Control and Safeshut Service installed successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sudo sync
sleep 5 
log_action_msg "Reboot disabled for test purposes"
sudo reboot
