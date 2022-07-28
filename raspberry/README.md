# Clean install readme

## Create Raspberry Image

1. Install Raspberry Pi Imager v1.7.2
2. Choose Raspberry Pi OS (Raspberry Pi OS Lite 64-Bit recommended)
3. Press the gear icon to set more options
4. Activate SSH and create a user with password
5. Enable WIFI and configure the settings (Either choose your own wifi or setup a mobile wifi)
6. After the install finished insert the sd card and boot the raspberry pi

## Install all the necessary apps

DISCLAIMER ~ Everything was initially setup using the recommended OS if you run into any issues using the commands try using the recommended OS or search for the commands for your selected OS

1. Either connect a keyboard directly to the raspberry or find the raspberrys ip and connect via ssh
 - On windows use `ssh PIUSERNAME@PIADRESS` 
2. Run the following commands to install all dependend apps
 - `sudo apt-get update`
 - `sudo apt-get upgrade -y`
 - `sudo apt-get install -y curl`
 - `sudo apt-get install -y git`
 - `curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -`
 - `sudo apt install -y nodejs`
 - `sudo apt-get install -y --no-install-recommends chromium-browser=101.0.4951.57-rpt2`
 - `sudo apt-get install -y unclutter=8-25`
 - `sudo apt-get install -y xdotool=1:3.20160805.1-4`
 - `sudo apt-get install -y lightdm=1.26.0-7+rpt1`
 - `sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox`

## Setup openbox

1. Use `sudo nano /etc/xdg/openbox/autostart`
2. Replace with the following:

       # Disable any form of screen saver / screen blanking / power management
    
       xset s off
    
       xset s noblank
    
       xset -dpms
    
       xrandr --orientation left
    
       # Allow quitting the X server with CTRL-ATL-Backspace
    
       setxkbmap -option terminate:ctrl_alt_bksp
    
       # Start Chromium in kiosk mode
    
       sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
    
       sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/ "exit_type":"Normal"/' ~/.config/chromium/Default/Preferences
    
       chromium-browser --no-first-run --kiosk --disable-infobars--force-device-scale-factor=0.90 --noerrdialogs 'http://localhost:3000'

## Setup LightDM

1. Run `sudo nano /etc/lightdm/lightdm.conf`
2. Add the following lines:

       [SeatDefaults]
       autologin-user={USERNAME}
       autologin-user-timeout=0
1. Run `sudo nano /etc/pam.d/lightdm-autologin` and replace `auth required pam_succeed_if.so user != root quiet_success` with `auth sufficient pam_succeed_if.so user = root`

## Create directory for react and clone git repo

1. Use mkdir mirror to create an directory for the git code using `sudo mkdir mirror`
2. Then switch to mirror with `cd mirror`
3. Then we clone the repo of our mirror (in our case: `sudo git clone https://username:password@git.it.hs-heilbronn.de/cdeme/labswp-gruppe-4-smart-mirror.git`, make sure to replace username and password with your git login data)
4. Then use `sudo npm rebuild labswp-gruppe-4-smart-mirror/raspberry/react-mirror/`
5. Then use `sudo npm install --legacy-peer-deps labswp-gruppe-4-smart-mirror/raspberry/react-mirror/` to install react and the projects dependencies

## Setup systemd

1. Run `sudo nano /etc/systemd/system/react.service` and enter:

       [Unit]
       Description=React service

       [Service]
       Type=idle
       WorkingDirectory= /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/react-mirror
       ExecStart=/usr/bin/npm start

       [Install]
       WantedBy=multi-user.target

2. Run `sudo nano /etc/systemd/system/ldmreact.service` and enter: 

       [Unit]
       Description=LightDM after react service
    
       [Service]
       Type=idle
       ExecStart= /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/ldmreact.sh
    
       [Install]
       WantedBy=multi-user.target

3. Run `sudo nano /etc/systemd/system/wsocket.service` and enter:

       [Unit]
       Description=Websocket service
       After=network-online.target

       [Service]
       Type=idle
       ExecStart= /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/wsocket.sh

       [Install]
       WantedBy=multi-user.target

4. Run `sudo nano  /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/ldmreact.sh` and enter (in case it takes too long you may need to change sleep time to 90s or 120s):

       #!/bin/bash
       sleep 75s
       systemctl restart lightdm

5. Run `sudo nano  /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/wsocket.sh` and enter:

       #!/bin/bash
       sleep 30s
       node  /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/node_websocket/index.js

6. Run `sudo chmod +x  /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/wsocket.sh`
7. Run `sudo chmod +x  /home/{USERNAME}/mirror/labswp-gruppe-4-smart-mirror/raspberry/lightdm.sh`
8. Run `sudo systemctl enable react.service`
9.Run `sudo systemctl enable ldmreact.service`
10. Run `sudo systemctl enable wsocket.service`

## Finally...

`sudo reboot`
