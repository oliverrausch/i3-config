# i3-config
Personal i3 configuration  
Install: `i3 i3blocks`

# other things

## remove grub timeout
edit `/etc/default/grub` and replace `GRUB_TIMEOUT=0`

## make home and end work in terminal
`cp /etc/inputrc ~/.inputrc`
(if not present try `.inputrc` in `other/`)

## lock automatic
Copy `other/slock.service` into `/etc/systemd/system/`  
run `systemctl enable slock.service`  

## dmenu wifi
install https://github.com/firecat53/networkmanager-dmenu to `/usr/bin/`  
install dmenu `.desktop` file

## vimium
https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb?hl=en

## backlight 
try `xbacklight`. If it doesn't work:  
  
clone: `https://github.com/Ventto/lux`  
`sudo make install`  
`sudo usermod -aG video oliver`  
run `sudo lux` once.  
relog.  

## volume
cp `other/volume-script` to `/usr/bin/`

### other approach
clone `https://github.com/fernandotcl/pa-applet` and `cd`
`./autogen.sh`
`./configure --prefix=/usr/`
`rg Werror` and remove the `-Werror` tag
`sudo make install`

## spotify in i3bar
Install https://github.com/acrisci/playerctl/releases

# firefox
- set to light theme (not default)
- change fonts to roboto and noto serif
- disable autohide by going to `about:config` and double clicking `browser.fullscreen.autohide`
## addons
- vim vixen
- ublock origin

