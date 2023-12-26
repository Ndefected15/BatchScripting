@echo off

setlocal enabledelayedexpansion

goto :main

 

:main

setlocal

              goto :readFiles

endlocal

goto :eof

             

:readFiles

setlocal

set /a count=0

              for /f %%i in ('dir /b /a-d *.csv') do (

                             set /a count=count+1

                             set choice[!count!]=%%i

              )

              echo.

              if !switch!==1 (

                             goto :selectemail

              )

              if NOT !switch!==1 (

                             goto :task

              )

             

endlocal

goto :eof

 

:task

setlocal

              set /a switch=0

              echo Would you like to concatenate two CSV files, add an ID column to one CSV file or send a file through email:

              echo 1] Concatenate

              echo 2] Add ID Column

              echo 3] Send An Email

              echo.

              set /p select=?

              if !select!==1 goto :file1

              if !select!==2 goto :selectFile

              if !select!==3 (

                             set /a switch=1

                             goto :readFiles

              )

              if NOT !select!==1 (

                             if NOT !select!==2 (

                                           if NOT !select!==3 (

                                           echo.

                                           echo.

                                           echo Not a valid response.

                                           goto :task

                                           )

                             )

              )

endlocal

goto :eof

 

:file1

setlocal

              Echo.

              echo Select File 1:

              for /l %%x in (1,1,!count!) do (

                             echo  %%x] !choice[%%x]!

              )

              echo.

              set /p select1=?

              echo.

              if !select1! gtr 0 (

                             goto :1true

              )else (

                             goto :1false

              )

              :1true

                             if !select1! leq !count! (

                                           goto :1true2

                             )else (

                                           goto :1false

                             )

              :1true2

                             echo You chose !choice[%select1%]!

                             echo.

                             goto :file2

              :1false

                             echo not a valid reponse

                             goto :file1

endlocal

goto :eof

 

:file2

setlocal

              echo Select File 2:

              for /l %%x in (1,1,!count!) do (

                             echo  %%x] !choice[%%x]!

              )

              echo.

              set /p select2=?

              echo.

              if !select2! gtr 0 (

                             goto :2true

              )else (

                             goto :2false

              )

              :2true

                             if !select2! leq !count! (

                                           goto :2true2

                             )else (

                                           goto :2false

                             )

              :2true2

                             echo You chose !choice[%select2%%]!

                             echo.

                             goto :concatenate

              :2false

                             echo not a valid reponse

                             goto :file2

endlocal

goto :eof

             

:selectFile

setlocal

              Echo.

              echo Select a File:

              for /l %%x in (1,1,!count!) do (

                             echo  %%x] !choice[%%x]!

              )

              echo.

              set /p select=?

              echo.

              if !select! gtr 0 (

                             goto :selecttrue

              )else (

                             goto :selectfalse

              )

              :selecttrue

                             if !select! leq !count! (

                                           goto :selecttrue2

                             )else (

                                           goto :selectfalse

                             )

              :selecttrue2

                             echo You chose !choice[%select%]!

                             echo.

                             set /a count=0

                             goto :transform

              :selectfalse

                             echo not a valid reponse

                             goto :selectFile

endlocal

goto :eof

 

:concatenate

setlocal

              copy !choice[%select1%]! + !choice[%select2%]! Concat.csv

              echo.

              echo.

              echo Complete!

              goto :email

endlocal

goto :eof

 

 

:transform

setlocal
			  echo.

              echo Adding ID column to !choice[%select%]!

              set i=0

              echo ID > output.csv

              (for /f "UseBackQ Delims=" %%a in (!choice[%select%]!) do (

                             echo !i!,%%a >> output.csv

                             set /A "i=(i+1)"

              ))
			  
			  echo.
			  
			  echo Complete!

              goto :email

endlocal

goto :eof

 

:email

setlocal

              echo.

              echo.

              echo Would you like to email a file? (y/n)

              echo.

              set /p response=

              if !response!==y (

                             set /a switch=1

                             goto :readFiles

              )

              if !response!==n goto :end

endlocal

goto :eof

 

:selectemail

setlocal

              set /a switch=0

              Echo.

              echo Select a File to email:

              for /l %%x in (1,1,!count!) do (

                             echo  %%x] !choice[%%x]!

              )

              echo.

              set /p select=?

              echo.

              if !select! gtr 0 (

                             goto :3true

              )else (

                             goto :3false

              )

              :3true

                             if !select! leq !count! (

                                           goto :3true2

                             )else (

                                           goto :3false

                             )

              :3true2

                             echo You chose !choice[%select%]!

                             echo.

                             set /a count=0

                             goto :emailInfo

                             goto :sendemail

              :3false

                             echo not a valid reponse

                             goto :selectemail

endlocal

goto :eof

 

:emailInfo

setlocal

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

              goto :sendemail

endlocal

goto :eof

 

:sendemail

setlocal
			  echo !body!
              PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& './email.ps1'" !choice[%select%]! !to! !subject! "!body!"

endlocal

goto :eof

 

:end

setlocal

              echo.

              echo.

              echo Thank you!

endlocal