:: don't bug me

@echo off

:: wait for slackers (check if this could be dropped!)

timeout /T 5 /nobreak > NUL 

:: jump into unix world and kick off some awesome stuff

C:\cygwin\bin\bash -li /cygdrive/e/config/env/provide_environment.sh