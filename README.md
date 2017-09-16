# biztalk$invocation = (Get-Variable MyInvocation).Value;
$MainDirectory = Split-Path $invocation.MyCommand.Path;
. "$MainDirectory\Config\Modulo_Biztalk.ps1";
$GlobalFunctions = "$MainDirectory\Config\Global_functions.psm1";
Import-Module $GlobalFunctions;
$DataConfiguration = Get-ParameterFile -filepath "$MainDirectory\Config\HashTable.psd1"
[void] [System.reflection.Assembly]::LoadWithPartialName("Microsoft.BizTalk.ExplorerOM")
$BizTalkGroup = Get-WmiObject MSBTS_GroupSetting -namespace root\MicrosoftBizTalkServer -ErrorAction Stop
$BizTalkDBInstance = $BizTalkGroup.MgmtDbServerName
$BizTalkDB = $BizTalkGroup.MgmtDbName
function Deploy-Application(){
 <#
.DESCRIPTION
    Instala la aplicacion en Biztalk 
.PARAMETER nameApplication
    Nombre de aplicacion a instalar
.PARAMETER activity
    Tipo Actividad Despliegue , Redespliegue , configuracion		
#>
	Param(
		$params,
		$nameApplication,
		$activity
	);

#1 Descargar Fuentes de Harvest
#2 Detener Servicio Microsoft Monitor Agent
#3 Respaldar Aplicacion Biztalk
#4 Detener Aplicacion 
#5 Eliminar Aplicacion
#6 Importar MSI
#7 Instalar MSI
#8 Importar Bindings

$ServerName = $DataConfiguration.Get_Item("databaseServer");				
$ServerDataBase = $DataConfiguration.Get_Item("databaseName");	
Write-host "Inicio proceso de Instalacion Biztalk"$BizTalkDBInstance
$BizTalkOM = New-Object Microsoft.BizTalk.ExplorerOM.BtsCatalogExplorer
$BizTalkOM.ConnectionString = 'SERVER='+$BizTalkDBInstance+';DATABASE='+$BizTalkDB+';Integrated Security=SSPI'
# Obtiene informacion de las aplicaciones
$applications = $BizTalkOM.Applications

# Desplegar informacion
Write-Host "`nBizTalk Applications ("$applications.Count")" -fore DarkGray

Foreach ($application in $applications) {
    if ($application.Status -eq "Started") {
        Write-Host $application.Name "- " -NoNewline
        Write-Host $application.Status -fore Green
    }
    elseif ($application.Status -eq "Stopped") {
        Write-Host $application.Name "- " -NoNewline
        Write-Host $application.Status -fore Red
    }
    else {
        Write-Host $application.Name "- " -NoNewline
        Write-Host $application.Status -fore Yellow
    }
}
Import-MSI -pathMSI "C:\test\Epm.Biztalk.Mercurio.msi" -enviroment "test" -nameApplication "Epm.Biztalk.Mercurio"
#Delete-Application -nameApplication "Epm.Biztalk.Mercurio"
#Stop-Application   -nameApplication "Epm.Biztalk.Mercurio"-applications $applications
#$BizTalkOM.SaveChanges()
$Extension = ".msi"
$nameApplication = "Bistalk Application 1"
$Backuplocation = "C:\capsula\workspace\"+$nameApplication + $Extension
#Backup-Application -nameApplication "Bistalk Application 1"-pathBackup $Backuplocation
Write-host "Finaliza proceso de Instalacion Biztalk"$BizTalkDB	
} 
Deploy-Application -params $args;
