BOINC Web Monitor
====

## Description
This is the web monitor for [BOINC](http://boinc.berkeley.edu/) on UNIX machine. 

The program generates html files to show the status of boinc-client using 'boinccmd'.

## Requirement
* boinc-client (this program uses 'boinccmd')
* ruby 2.0.0 or newer (1.9.3 might work, but not tested)
* lm-sensors (optional, using 'sensors' command)
* 'aticonfig' command (optional, only for AMD Grpahics)

## Usage
1. Put files in html directory into open directory of web server (e.g. /var/www/index.html etc...)
2. Put javascripts from [jQuery Animated Table Sorter](http://www.matanhershberg.com/plugins/jquery-animated-table-sorter/)
into js direcoty (e.g. /var/www/js/tsort.js etc...) (You need arrow\_asc.png, 
arrow\_desc.png, jquery.min.js, style.css, tsort.js, tsort.min.js)
3. Configure settings in make\_html.sh. Set the direcory of web server to WWW\_DIR. If you can use 'sensors' command of lm-sensors, set
SENSOR to 1. If you can use 'aticonfig' command, set AMD to 1.
4. Run make\_html.sh. If you need scheduling, please use cron.
5. Access your machine from browser.

## ScreenShots
![TaskList](https://raw.githubusercontent.com/wiki/nkgami/boinc-web-monitor/images/boinc_sc0.png)
![ProjectList](https://raw.githubusercontent.com/wiki/nkgami/boinc-web-monitor/images/boinc_sc1.png)
![Sensors](https://raw.githubusercontent.com/wiki/nkgami/boinc-web-monitor/images/boinc_sc2.png)

## Licence

[MIT](https://github.com/tcnksm/tool/blob/master/LICENCE)

## Author

[nkgami](https://github.com/nkgami)

