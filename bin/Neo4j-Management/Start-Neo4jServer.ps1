#
# Copyright (c) 2002-2018 "Neo Technology,"
# Network Engine for Objects in Lund AB [http://neotechnology.com]
# This file is a commercial add-on to Neo4j Enterprise Edition.
#


<#
.SYNOPSIS
Starts a Neo4j Server instance

.DESCRIPTION
Starts a Neo4j Server instance either as a java console application or Windows Service

.PARAMETER Neo4jServer
An object representing a valid Neo4j Server object

.EXAMPLE
Start-Neo4jServer -Neo4jServer $ServerObject

Start the Neo4j Windows Windows Service for the Neo4j installation at $ServerObject

.OUTPUTS
System.Int32
0 = Service was started and is running
non-zero = an error occured

.NOTES
This function is private to the powershell module

#>
Function Start-Neo4jServer
{
  [cmdletBinding(SupportsShouldProcess=$false,ConfirmImpact='Low',DefaultParameterSetName='WindowsService')]
  param (
    [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
    [PSCustomObject]$Neo4jServer

    ,[Parameter(Mandatory=$true,ParameterSetName='Console')]
    [switch]$Console

    ,[Parameter(Mandatory=$true,ParameterSetName='WindowsService')]
    [switch]$Service   
  )
  
  Begin
  {
  }

  Process
  {
    # Running Neo4j as a console app
    if ($PsCmdlet.ParameterSetName -eq 'Console')
    {      
      $JavaCMD = Get-Java -Neo4jServer $Neo4jServer -ForServer -ErrorAction Stop
      if ($JavaCMD -eq $null)
      {
        Write-Error 'Unable to locate Java'
        return 255
      }

      Write-Verbose "Starting Neo4j as a console with command line $($JavaCMD.java) $($JavaCMD.args)"
      $result = (Start-Process -FilePath $JavaCMD.java -ArgumentList $JavaCMD.args -Wait -NoNewWindow -PassThru -WorkingDirectory $Neo4jServer.Home)
      Write-Verbose "Returned exit code $($result.ExitCode)"

      Write-Output $result.ExitCode
    }
    
    # Running Neo4j as a windows service
    if ($PsCmdlet.ParameterSetName -eq 'WindowsService')
    {
      $ServiceName = Get-Neo4jWindowsServiceName -Neo4jServer $Neo4jServer -ErrorAction Stop

      Write-Verbose "Starting the service.  This can take some time..."
      $result = Start-Service -Name $ServiceName -PassThru -ErrorAction Stop
      
      if ($result.Status -eq 'Running') {
        Write-Host "Neo4j windows service started"
        return 0
      }
      else {
        Write-Host "Neo4j windows was started but is not running"
        return 2
      }
    }
  }
  
  End
  {
  }
}
