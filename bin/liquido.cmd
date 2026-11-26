@echo off
rem Executa a interface por linha de comando do Liquido.
rem Uso: liquido ^<comando^> [opcoes]
rem Interpretador: LIQUIDO_DELEGUA; sem ela, o deldel (delegua-delegua) se estiver no PATH; senao, o delegua.
if "%LIQUIDO_DELEGUA%"=="" (where deldel >nul 2>nul && set LIQUIDO_DELEGUA=deldel)
if "%LIQUIDO_DELEGUA%"=="" (set LIQUIDO_DELEGUA=delegua)
%LIQUIDO_DELEGUA% "%~dp0..\fontes\ilc.delegua" -- %*
