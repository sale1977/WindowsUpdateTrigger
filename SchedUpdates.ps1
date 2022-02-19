[string]$TaskName = "WindowsUpdates"
$Trigger = New-ScheduledTaskTrigger  -At "12:00" -Daily # Specify the trigger settings
$User = "NT AUTHORITY\SYSTEM" # Specify the account to run the script
$pr = New-ScheduledTaskPrincipal  -Groupid "INTERACTIVE" 
$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ex bypass -noninteractive -nologo C:\Assets\Updates\Updates.ps1" # Specify what program to run and with its parameters
$TaskEinstellungen = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries # Einstellungen des Tasks                             
if (Get-ScheduledTask $TaskName -ErrorAction SilentlyContinue) {Unregister-ScheduledTask $TaskName -confirm:$false} # Falls die Aufgabe schon vorhanden ist, wird sie zuerst gelöscht             
Register-ScheduledTask -TaskName $TaskName -Trigger $Trigger -Settings $TaskEinstellungen -User $User -Action $Action -RunLevel Highest # Specify the name of the task
