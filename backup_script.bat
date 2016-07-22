:: A Windows backup script
:: Ashley Manson

@echo off

title Backup Script
color 0A
cls

:: First parameter should be the backup drive letter.
set BACKUP_DRIVE=%1
set BACKUP_DRIVE=%BACKUP_DRIVE:\=%

set BACKUP_PATH=%BACKUP_DRIVE%\Backup\%USERNAME%
set LOG_PATH=%BACKUP_DRIVE%\Backup\.logs

set PROMPT_USER=%2

if "%PROMPT_USER%" == "no-prompt" (
	goto START
)

echo Files will backup to %BACKUP_PATH%
set /p SHOULD_CONTINUE=Do you wish to continue with the backup (Y/[N])? 
if /i "%SHOULD_CONTINUE%" NEQ "Y" goto :EOF

:START

:: Ensure all directories exist before continuing 
if not exist %BACKUP_PATH% mkdir %BACKUP_PATH%
if not exist %LOG_PATH% mkdir %LOG_PATH%

:: Format date and time for log file name, and create empty log file
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set the_date=%%c-%%b-%%a)
for /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set the_time=%%a%%b)
set the_time=%the_time: =0%
set LOG_FILE="%LOG_PATH%\%the_date%_%the_time%_backup.log"
echo. 2> %LOG_FILE%

for /f "tokens=*" %%A in (.backup_directories) do (
    title Backup Script [%%A to %BACKUP_PATH%\%%~nxA]
    robocopy %%A %BACKUP_PATH%\%%~nxA /e /xjd /eta /tee /mt:4 /log+:%LOG_FILE%
)

title Backup Script [Complete]

if "%PROMPT_USER%" == "no-prompt" (
    goto :EOF
)

pause

