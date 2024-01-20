@echo off
setlocal enabledelayedexpansion

:main
setlocal
call :readFiles
endlocal

:readFiles
set /a count=0
for /f %%i in ('dir /b /a-d *.csv') do (
    set /a count+=1
    set choice[!count!]=%%i
)

echo.

if !switch!==1 (
    call :selectemail
) else (
    goto :task
)

:task
echo.
echo.
echo Would you like to concatenate two CSV files, add an ID column, or send a file through email:
echo 1] Concatenate
echo 2] Add ID Column
echo 3] Send An Email
echo 4] Quit
echo.

set /p taskSelect=?

if !taskSelect! geq 1 if !taskSelect! leq 4 (
    call :case_%taskSelect%
) else (
    set type=task
    echo.
    echo.
    call :notValid
)

:case_1
set taskType=file1
echo.
echo.
echo You have chosen Concatenate, is this correct? (y/n)
echo.
set /p choice=?
goto :confirmTaskSelect

:case_2
set taskType=ID
echo.
echo.
echo You have chosen Add ID Column, is this correct? (y/n)
echo.
set /p choice=?
goto :confirmTaskSelect

:case_3
set taskType=email
echo.
echo.
echo You have chosen Send An Email, is this correct? (y/n)
echo.
set /p choice=?
goto :confirmTaskSelect

:case_4
set taskType=quit
echo.
echo.
echo You have chosen to quit, is this correct? (y/n)
echo.
set /p choice=?
goto :confirmTaskSelect

:confirmTaskSelect
if /i !choice!==y (
    echo.
    echo Choice Confirmed.
    goto :taskTypeSwitch
) else if /i !choice!==n (
    set taskType=task
    goto :taskTypeSwitch
) else (
    goto :notValid
)

:taskTypeSwitch
if !taskType!==taskSelect (
    call :case_%taskSelect%
)
if !taskType!==file1 (
    call :file1
)
if !taskType!==file2 (
    call :file2
)
if !taskType!==ID (
    call :IDFileSelect
)
if !taskType!==email (
    set /a switch=1
    call :readFiles
)
if !taskType!==task (
    call :task
)
if !taskType!==quit (
    goto :end
)

:file1
set taskType=file1
echo.
echo Select File 1:
call :fileSelect

:file2
set taskType=file2
echo.
echo Select File 2:
call :fileSelect

:IDFileSelect
set taskType=ID
echo.
echo Select a File:
call :fileSelect

:fileSelect
for /l %%x in (1,1,!count!) do (
    echo  %%x] !choice[%%x]!
)
echo.
set /p fileSelect=?
echo.
if !fileSelect! gtr 0 (
    call :confirmFileSelect
) else (
    call :notValid
)

:confirmFileSelect
echo.
echo You have chosen !choice[%fileSelect%]!, is this correct? (y/n)
echo.
set /p choice=?
if /i !choice!==y (
    call :confirmFile_%choice%
)
if /i !choice!==n (
    call :confirmFile_%choice%
) else (
    set type=file
    set fileType=confirmFileSelect
    goto :notValid
)

:confirmFile_y
call :grtCheck

:confirmFile_n
call :taskTypeSwitch

:grtCheck
if !fileSelect! leq !count! (
    goto :leqCheck
) else (
    goto :notValid
)

:leqCheck
echo.
echo.
echo You chose !choice[%fileSelect%]!
if !taskType!==file1 (
    set select1=!fileSelect!
    goto :file2
)
if !taskType!==file2 (
    set select2=!fileSelect!
    goto :concatenate
)
if !taskType!==ID (
    goto :transform
)
if !taskType!==email (
    call :emailInfo
    call :sendemail
)

:fileTypeSwitch
if !fileType!==fileSelect (
    call :fileSelect
)
if !fileType!==confirmFileSelect (
    call :confirmFileSelect
)

:concatenate
copy !choice[%select1%]! + !choice[%select2%]! Concat.csv
echo.
echo Complete!
goto :anythingElse

:transform
echo.
echo.
echo Adding ID column to !choice[%fileSelect%]!
set i=0
echo ID > output.csv
(for /f "usebackq delims=" %%a in (!choice[%fileSelect%]!) do (
    echo !i!,%%a >> output.csv
    set /A "i=(i+1)"
))
echo.
echo.
echo ID column added to !choice[%fileSelect%]!
goto :anythingElse

:anythingElse
echo.
echo.
echo Would you like to do anything else? (y/n)
echo.
set /p choice=?
goto :choice_%choice%

:choice_y
goto :task

:choice_n
goto :end

:selectemail
set type=email
Echo.
echo Select a File to email:
call :fileSelect

:emailInfo
echo.
echo Enter email you're sending file to:
echo.
set /p to=?
echo.
echo Enter the Subject:
echo.
set /p subject=?
echo.
echo Enter the body:
echo.
set /p body=?

:sendemail
PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './email.ps1' !choice[%fileSelect%]! !to! '!subject!' '!body!'"
goto :anythingElse

:notValid
echo.
echo Not a valid response.
echo.
if !type!==task (
    call :taskTypeSwitch
)
if !type!==file (
    call :fileTypeSwitch
)   

:end
echo.
echo Thank you.
goto :eof
exit /b