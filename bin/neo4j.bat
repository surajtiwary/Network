@REM
@REM Copyright (c) 2002-2018 "Neo Technology,"
@REM Network Engine for Objects in Lund AB [http://neotechnology.com]
@REM This file is a commercial add-on to Neo4j Enterprise Edition.
@REM

@ECHO OFF

SETLOCAL

Powershell -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -Command "try { Unblock-File -Path '%~dp0Neo4j-Management\*.*' -ErrorAction 'SilentlyContinue' } catch {};Import-Module '%~dp0Neo4j-Management.psd1'; Exit (Invoke-Neo4j %*)"
EXIT /B %ERRORLEVEL%
