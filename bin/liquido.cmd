@echo off
rem Executa a interface por linha de comando do Liquido.
rem Uso: liquido ^<comando^> [opcoes]
if "%LIQUIDO_DELEGUA%"=="" (set LIQUIDO_DELEGUA=delegua)
%LIQUIDO_DELEGUA% "%~dp0..\fontes\ilc.delegua" -- %*
