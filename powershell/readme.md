# Automatisierung von Teams mit Powershell

## Powerhell für Teams vorbereiten
[Powershell für Teams](https://learn.microsoft.com/de-de/microsoftteams/teams-powershell-install)
## Create a self signed  certidicate
``` Powershell
$Certificate=New-SelfSignedCertificate –Subject MSGraphTeams-CertStoreLocation Cert:\CurrentUser\My 
Export-Certificate -Cert $Certificate -FilePath "C:\temp\TeamsPWS.cer" #<Use your preferred location and certificate name in 'FilePath’ > 
```
## App in EntraId erstellen
https://www.msxfaq.de/teams/reporting/teams_call_auswertung.htm
## Teams Login
``` Powershell
Connect-MicrosoftTeams
```

### Inventarisierung

Eingerichtete Warteschlangen
``` Powershell
Get-CsCallQueue  
```
