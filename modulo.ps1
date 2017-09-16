function Backup-Application(){
    Param(
        $nameApplication,
        $pathBackup
    );
    Write-host "Inicio proceso para Respaldar aplicacion"$nameApplication
    & BTSTask exportapp /ApplicationName:$nameApplication /Package:$pathBackup
}
function Stop-Application(){
 <#
 .DESCRIPTION
    Busca y detiene la aplicacion
 .PARAMETER nameApplication
    Nombre de aplicacion que se requiere Detener
 .PARAMETER applications
    Listado de aplicaciones que se encuentran en Biztalk      
 #>   
    Param(
        $nameApplication,
        $applications
    );
    Write-host "Inicio proceso para Detener apliccion"$nameApplication
    Write-Host "`nBizTalk Applications ("$applications.Count")" -fore Green
    Foreach ($application in $applications) {
    #if ($application.Status -eq "Started") {
        Write-Host $application.Name "- " -NoNewline
        if ($application.Name -eq $nameApplication) {
            $application.Stop([Microsoft.BizTalk.ExplorerOM.ApplicationStopOption] "StopAll")
            Write-Host $application.Status -fore Green
        }
        
    #}
}

}
function Delete-Application(){
<#
.DESCRIPTION
    Elimina aplicacion de Biztalk
.PARAMETER nameApplication
    Nombre de la aplicacion a eliminar    
#>    
    Param(
        $nameApplication
    );
    Write-host "Inicio proceso para Eliminar apliccion"$nameMSI
    & BTSTask RemoveApp /ApplicationName:$nameApplication
}

function Import-MSI(){
 <#
.DESCRIPTION
    Importa aplicacion MSI en Biztalk
.PARAMETER pathMSI
    Ruta de MSI
 .PARAMETER enviroment
    Tipo de ambiente        
.PARAMETER nameApplication
    Nombre de aplicacion a instalar		
#>  
   Param(
		$pathMSI,
        $enviroment,
        $nameApplication
	);
    Write-host "Inicio proceso de Importacion de MSI"$pathMSI
    & BTSTask ImportApp /Package:$pathMSI /Environment:$enviroment /ApplicationName:$nameApplication /Overwrite
    #sinvoke-expression $importapp | out-null
} 
function Instalar-MSI(){
   Param(
		$nameMSI
	);
    Write-host "Inicio proceso de Instalacion de MSI"$nameMSI    
} 
function Import-Binding(){
   Param(
		$nameMSI
	);
    Write-host "Inicio proceso de Importacion de Binding"$nameMSI    
} 
