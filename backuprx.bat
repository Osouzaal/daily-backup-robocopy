@echo off

echo Iniciando backup...

robocopy "E:\RAIOSXSERVIDOR" "G:\Backup_RAIOSXSERVIDOR" /E /Z /R:3 /W:5 /LOG:E:\backup_log.txt

echo Backup concluido!
pause