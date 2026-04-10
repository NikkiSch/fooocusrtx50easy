@echo off
chcp 65001 >nul
title Fooocus - KI-Bildgenerator

echo Starte Fooocus...
echo Bitte warten - der Browser oeffnet sich gleich automatisch.
echo.

set NO_PROXY=localhost,127.0.0.1
set no_proxy=localhost,127.0.0.1

call fooocus_env\Scripts\activate.bat
python launch.py

pause
