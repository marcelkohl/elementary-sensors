[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
[![GPLv3 license](https://img.shields.io/badge/License-GPLv3-blue.svg)](http://perso.crans.org/besson/LICENSE.html)
[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Naereen/ama)
[![Generic badge](https://img.shields.io/badge/status-alpha_test-red.svg)](https://shields.io/)

![sensors list](https://github.com/marcelkohl/elementary-vala-gtk-sensors/blob/master/sample/screenshot.png?raw=true)

# elementary-vala-gtk-sensors
An attempt to make visible temperature from sensors cli

## Building and running
`meson build --prefix=/usr
cd build
ninja`

**Pre running**
`sudo ninja uninstall
kill [wingpanel_process_id]
sudo ninja install
wingpanel`

**running with debugger**
`G_MESSAGES_DEBUG=all ./local.sample.sensors
`
