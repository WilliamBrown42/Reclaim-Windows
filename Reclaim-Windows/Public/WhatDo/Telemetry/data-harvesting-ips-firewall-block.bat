@echo off

:: IPs by https://twitter.com/EveningStarNM/, https://twitter.com/bartblaze/, and https://github.com/odan
:: Firewall rule by odan: https://github.com/dfkt/win10-unfuck/issues/4

:: The following addresses belong to Akamai - blocking them might lead to some broken stuff (besides Windows telemetry)
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="2.22.61.43" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="2.22.61.66" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="23.218.212.69" profile=any action=block

:: United States Superior Edgar Rental Corporation; Pinpoint Communications, Inc.
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="65.39.117.230" profile=any action=block

:: Microsoft Corp
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="65.55.108.23" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="134.170.30.202" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="137.116.81.24" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="157.56.106.189" profile=any action=block
netsh advfirewall firewall add rule name="Block MS IP Address" dir=out protocol=any remoteip="204.79.197.200" profile=any action=block

pause
