$computer = 'uptime-demo'
$Username = 'uptimedemo\robert'
$Password = 'a789632145'
$pass = ConvertTo-SecureString -AsPlainText $Password -Force
$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$pass

icm -cn $computer -credential $Cred {
    #Param( 
    #	[string]$gender,
    #	[string]$texttospeak,
    #	[string]$rate
    #)
    $Error.Clear()

    $NTPStatus = w32tm /query /status /verbose
    $NTPConfiguration = w32tm /query /configuration

#build config array and clean it up

    $NTPConfigArray = New-Object System.Collections.Generic.List[String]
    $NTPConfigArray = $NTPConfiguration -split '[\r\n]'
    $NTPConfigArray = $NTPConfigArray + $NTPStatus -split '[\r\n]'

    $NTPConfigArray = $NTPConfigArray | ? {$_}
    $NTPConfigArray = $NTPConfigArray | ? {@("[Configuration]", "[TimeProviders]", "NtpClient (Local)", "NtpServer (Local)", "VMICTimeProvider (Local)") -notcontains $_}
    
    #Write-host ($NTPConfigArray | Out-String).Trim()

    foreach ($pair in $NTPConfigArray) {
        $element= @{}
        $element=$pair -split ':',2
        Write-Host $element[0].Replace(" ", "_").Trim() $element[1].Trim()
    }
}