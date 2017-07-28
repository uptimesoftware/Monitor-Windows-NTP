# Monitor-Windows-NTP

I made this plugin for Uptime for monitoring a few key metrics from win32tm. In its current state, you will either need to run your Uptime data collector as a user who is a local administrator on the machines you wish to monitor, similar to the credentials used to monitor windows machines with WMI in Uptime now. Or you could wrap the commands in an invoke command as I show an example of in the file with off domain in the description, in this repo. That code however was not finished. You can find finished examples in the Monitor-Windows-Memory repository / plugin. 

# Installation

Since this plugin is not part of the-grid.uptimesoftware.com it will require manual installation. 

---------------------------------Installation----------------------------------------
1. ​Download the zip and unpack into the uptime folder ie: c:\program files\uptime software\uptime   it will ask if you want to overwrite the plugins and scripts folders, just say yes. This just copies the stuff needed for the plugin into the proper spots. 
2. Next, move Monitor-Windows-NTP.xml into the uptime\xml folder.
3. Open a command prompt as administrator
4. Navigate to uptime\scripts and run erdcloader.exe -x "c:\program files\uptime software\uptime​\xml\Monitor-Windows-NTP.xml"
5. The plugin should now be added into uptime and available in the add service monitor dialogue, under "Operating System Monitors" as Monitor Windows NTP.
 
---------------------------------Uninstall-----------------------------------------
To remove the plugin, ensure any service monitors using it have been deleted, then, in an administrative command prompt, from the uptime\scripts directory, run erdcdeleter -n "Monitor Windows NTP"
 
