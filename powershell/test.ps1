$LoginUrl = "https://login.microsoftonline.com"  # Graph API URLs
$ResourceUrl = "https://graph.microsoft.com"     # Ressource API URLs
$TenantId = "xxxxxxxxxxxxx-9fa8-30c1ec9b00be"
$AppID = "xxxxxxxxxxxxxxx3-311436c12492"
$Appkey = "xxxxxxxxxxxxxxxxxxxxxxxxx"
$CertTB = "xxxxxxxxxxxxxxxxxxxxxxxxx"
#Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All", "APIConnectors.Read.All" , "CallRecords.Read.All"
Connect-MgGraph -TenantId $TenantId -ClientId $AppID  -CertificateThumbprint $CertTB
#Get Call Records
$datefilter = "(fromDateTime=$((get-date).adddays(-1).ToString("yyyy-MM-dd")),toDateTime=$((get-date).adddays(2).ToString("yyyy-MM-dd")))"

$records = Invoke-MgGraphRequest -Method GET 'https://graph.microsoft.com/v1.0/communications/callRecords/'
$x = $records.value | Sort-Object -Property startDateTime 

function New-TeamsCall() {
    param ($callId, $sourceCallId, $targetCallId , $successfulCall , $startDateTime, $directRoutingCallId)
    $no = New-Object -TypeName psobject
    $no | Add-Member NoteProperty -Name callId -Value $callId 
    $no | Add-Member NoteProperty -Name sourceCallId  -Value $sourceCallId
    $no | Add-Member NoteProperty -Name targetCallId  -Value $targetCallId
    $no | Add-Member NoteProperty -Name successfulCall  -value $successfulCall
    $no | Add-Member NoteProperty -Name startDateTime -Value  $startDateTime
    $no | Add-Member NoteProperty -Name directRoutingCallId -Value $directRoutingCallId

    return $no
}

$TeamsCallList = [System.Collections.Generic.List[psobject]]@()


foreach ($u in $x) {
  
    $o = New-TeamsCall -callId $u.id -startDateTime $u.startDateTime  -sourceCallId $u.organizer.phone.id 
   
    $TeamsCallList.Add($o)
    #
   
}

#$TeamsCallList | ft


$records1 = Invoke-MgGraphRequest -Method GET https://graph.microsoft.com/v1.0/communications/callRecords/getDirectRoutingCalls$datefilter
$r = $records1.value

foreach ($u in $r) {
    # write-host $u.id ' ' $u.callerNumber  ' ' $u.calleeNumber ' '  $u.successfulCall   '' $u.correlationId 
    $ca = $TeamsCallList | Where-Object { $_.callId -eq $u.correlationId }
    $ca.targetCallId = $u.calleeNumber
    $ca.successfulCall = $u.successfulCall
    $ca.directRoutingCallId = $u.correlationId 
    

}


$TeamsCallList  | Where-Object { $_.successfulCall -eq $false } | ft