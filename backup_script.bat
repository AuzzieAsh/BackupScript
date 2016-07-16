:: A Windows backup script
:: Ashley Manson

@echo off

title Backup Script
color 0A
mode con: cols=80 lines=40
cls

:: Drive letter is set to which ever drive the script runs from
set BACKUP_DRIVE=%cd:~0,2%
:: set BACKUP_DRIVE=A:
set BACKUP_PATH=%BACKUP_DRIVE%\Backup\%USERNAME%
set LOG_PATH=%BACKUP_DRIVE%\Backup\.logs

set MULTI_THREAD_NUM=4
set PROMPT_USER=true

if "%PROMPT_USER%" == "false" (
	GOTO START
)

echo Script will backup to drive "%BACKUP_DRIVE%"
set /p SHOULD_CONTINUE=Do you wish to continue with the backup (Y/[N])? 
if /i "%SHOULD_CONTINUE%" NEQ "Y" GOTO :EOF

:START

:: Ensure all directories exist before continuing 
if not exist %BACKUP_PATH% mkdir %BACKUP_PATH%
if not exist %LOG_PATH% mkdir %LOG_PATH%

:: Format date and time for log file name, and create empty log file
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)
set LOG_FILE=%LOG_PATH%\%mydate%_%mytime%_backup.log
echo. 2> %LOG_FILE%


if not exist %CD%\.backup_directories (
	echo .backup_directories does not exist, skipping directory backup. >> %LOG_FILE%
	GOTO :EOF
)

for /f "tokens=*" %%A in (.backup_directories) do (
	title Backup Script - %%A
	robocopy %%A %BACKUP_PATH%\%%~nA /e /np /tee /mt:%MULTI_THREAD_NUM% /log+:%LOG_FILE%
)

title Backup Script
pause
