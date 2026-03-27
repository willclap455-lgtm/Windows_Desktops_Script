Import-Module VirtualDesktop -DisableNameChecking

#check to make sure the desktop count is right


function Repair-Desktops {	
	Remove-AllDesktops
	Set-DesktopName (Get-CurrentDesktop) "Dev Env"
	Set-DesktopWallpaper (Get-CurrentDesktop) "C:\Users\aaron\Pictures\Desktop Backgrounds\Sunset.jpg"

	Switch-Desktop (New-Desktop)
	Set-DesktopName (Get-CurrentDesktop) "Wiki Work"
	Set-DesktopWallpaper (Get-CurrentDesktop) "C:\Users\aaron\Pictures\Desktop Backgrounds\River.jpg"

	Switch-Desktop (New-Desktop)
	Set-DesktopName (Get-CurrentDesktop) "FoxPro and Tasks"
	Set-DesktopWallpaper (Get-CurrentDesktop) "C:\Users\aaron\Pictures\Desktop Backgrounds\Oregon.jpg"

	Switch-Desktop (New-Desktop)
	Set-DesktopName (Get-CurrentDesktop) "Calls and Edu"
	Set-DesktopWallpaper (Get-CurrentDesktop) "C:\Users\aaron\Pictures\Desktop Backgrounds\Safari.jpg"

}

function Get-Desktops {
	[CmdletBinding()]  
	$answer = $null 
	$dt_count = Get-DesktopCount
	if ($dt_count -eq 4) { #make sure there's 4 desktops total
		$dt_count = Get-DesktopCount
		$dt1_name = Get-DesktopName 0
		$dt2_name = Get-DesktopName 1
		$dt3_name = Get-DesktopName 2
		$dt4_name = Get-DesktopName 3
		if ($dt1_name -ne "Dev Env") { #and that the names of the desktops are what they should be also
			$answer = Read-Host -Prompt "There's a problem with your desktops. Would you like to fix them now? (y/n)"
		} elseif ($dt2_name -ne "Wiki Work") {
			$answer = Read-Host -Prompt "There's a problem with your desktops. Would you like to fix them now? (y/n)"
		} elseif ($dt3_name -ne "FoxPro and Tasks") {
			$answer = Read-Host -Prompt "There's a problem with your desktops. Would you like to fix them now? (y/n)"
		} elseif ($dt4_name -ne "Calls and Edu") {
			$answer = Read-Host -Prompt "There's a problem with your desktops. Would you like to fix them now? (y/n)"
		}
		Write-Host "The desktop configuration appears to be correct."
	} else {
		$answer = Read-Host -Prompt "There's a problem with your desktops. Would you like to fix them now? (y/n)"
	}

	if ($answer -eq "y") {
		Repair-Desktops
	}

	#this section below starts a 1 second loop that detects changes in the desktop, then fires off the ssh command to change the led light on my desk
	$last_id = Get-DesktopIndex (Get-CurrentDesktop)
	Write-Host "Listening for desktop changes ... "
	while ($true) {
		Start-Sleep -Seconds 1
		$current = Get-DesktopIndex (Get-CurrentDesktop)
		if ($current -ne $last_id) {
			switch ($current) {
				0 {ssh denverchess@192.168.102.187 'sudo python ./LED/LED.py solid 44 56 68 1'}
				1 {ssh denverchess@192.168.102.187 'sudo python ./LED/LED.py solid 107 156 92 1'}
				2 {ssh denverchess@192.168.102.187 'sudo python ./LED/LED.py solid 235 151 151 1'}
				3 {ssh denverchess@192.168.102.187 'sudo python ./LED/LED.py solid 255 178 42 1'} 
				default {ssh denverchess@192.168.102.187 'sudo python ./LED/LED.py solid 255 255 255 1'}
			}
			$last_id = $current
		}
	}
}
