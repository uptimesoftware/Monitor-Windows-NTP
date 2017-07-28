$UPT_HOSTNAME = Get-ChildItem Env:UPTIME_HOSTNAME | select -expand value;

if([string]::IsNullOrEmpty($UPT_HOSTNAME)) {
	Write-Host "Hostname not being passed to script."
	Get-ChildItem Env:UPTIME*
	Exit 3
	}

#uncomment for command line testing
#$UPT_HOSTNAME = 'localhost'

$NTPStatus = w32tm /query /computer:$UPT_HOSTNAME /status /verbose
$NTPConfiguration = w32tm /query /computer:$UPT_HOSTNAME /configuration

#build config array and clean it up

$NTPConfigArray = New-Object System.Collections.Generic.List[String]
$NTPConfigArray = $NTPConfiguration -split '[\r\n]'
$NTPConfigArray = $NTPConfigArray + $NTPStatus -split '[\r\n]'

$NTPConfigArray = $NTPConfigArray | ? {$_}
$NTPConfigArray = $NTPConfigArray | ? {@("[Configuration]", "[TimeProviders]", "NtpClient (Local)", "NtpServer (Local)", "VMICTimeProvider (Local)") -notcontains $_}
    
    
#Write-host ($NTPConfigArray | Out-String).Trim()

$NTPmap = @{}
$NTPmap.Clear()

foreach ($pair in $NTPConfigArray) {
    $element= @{}
    $element=$pair -split ':',2
    $NTPmap.Set_Item($element[0].Replace(" ", "_").Trim(), $element[1].Trim())
}

#test the full output by uncommenting this.. messy but informative
#Write-Host ($NTPmap | Out-String).Trim()

#Monitor output stage    

#check if we have valid data
if ($NTPmap.Last_Sync_Error) {

	Write-Host "Last_Sync_Error" $NTPmap.Last_Sync_Error.Substring(0, $NTPmap.Last_Sync_Error.IndexOf(' '))
	Write-Host "Last_Successful_Sync_Time" $NTPmap.Last_Successful_Sync_Time
} else {
	Write-Host $NTPStatus
	Exit 3
	}
if ($NTPmap.Time_since_Last_Good_Sync_Time) {
	#convert the string output to decimal then int
	$lastSyncSec = $NTPmap.Time_since_Last_Good_Sync_Time.Trim("s"," ")
	$secs = [INT] $lastSyncSec
	Write-Host "Time_since_Last_Good_Sync_Time" $secs
}
if ($NTPmap.Source)	{Write-Host "Source" $NTPmap.Source}

if ($NTPmap.Type)	{Write-Host "Type" $NTPmap.Type.Substring(0, $NTPmap.Type.IndexOf(' '))}
if ($NTPmap.Precision)	{Write-Host "Precision" $NTPmap.Precision}
if ($NTPmap.Stratum)	{Write-Host "Stratum" $NTPmap.Stratum}