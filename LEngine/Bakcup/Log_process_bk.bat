@echo off

Echo "the zip process will begin."

set homedir=C:\LEngine
set current_log_dir=%homedir%\Currnet
set archive_dir=%homedir%\Archive
set attachment_dir=%homedir%\Email_attach
set zipbin_dir=%homedir%\7-Zip
::set archive_filename=%date%_%time:~0,2%_%time:~3,2%.zip
set email_bin_dir=%homedir%\Email_bin
set game_log_dir=D:\CrazyFruit\CrazyFruit_Data\StreamingAssets\Logs


::Get yesterday date
for /f %%i in ('powershell -c "Get-Date (Get-Date).AddDays(-1) -uformat "%%Y-%%m-%%d""') do ( set "yesterday=%%i" )
ECHO %yesterday%
set yesterday_archive_filename=%yesterday%.zip


PING smtp.vrdreams.com.cn
PING smtp.vrdreams.com.cn

::Fatch the yesterday game log from the game
move %game_log_dir%\%yesterday%.csv %current_log_dir%\

::count the game cycle number
for /f "tokens=* delims=- " %%b in ('find /c "end" %current_log_dir%\%yesterday%.csv') do ( set countnum=%%b )

set gamecyclenum=%countnum:~35,-1%

::mail email logic
IF NOT EXIST %current_log_dir%\%yesterday%.csv (ECHO log file not existed && "C:\LEngine\Email_bin\blat" %email_bin_dir%\Email_error.txt -s "[Testing-RX480_yesterday] [Error] [No Log Found]: GSTX-Fruit0.1.0 %date% %time% " -tf %email_bin_dir%\Email_ToList.txt -debug -log %email_bin_dir%\blat.log) ELSE (%zipbin_dir%\7z.exe -pideal a -tzip %attachment_dir%\%yesterday_archive_filename% %current_log_dir%\%yesterday%.csv && "C:\LEngine\Email_bin\blat" %email_bin_dir%\Email_body.txt -s "[Testing-RX480_yesterday] [Total GameCycle:%gamecyclenum%]: GSTX-Fruit0.1.0 %date% %time%" -attach %attachment_dir%\%yesterday_archive_filename% -tf %email_bin_dir%\Email_ToList.txt -debug -log %email_bin_dir%\blat.log)

::to zip
::"C:\Program Files\7-Zip\7z.exe" a -tzip %attachment_dir%\%archive_filename% %current_log_dir%\*.csv

::to email
::"D:\VRDreams_workspace\Log_upload\Test\Email_bin\blat" %email_bin_dir%\Email_body.txt -s "PC_GSTX_GM1.0.0 %date% %time%Log status" -attach %attachment_dir%\%archive_filename% -tf %email_bin_dir%\Email_ToList.txt -debug -log %email_bin_dir%\blat.log

::to count the lines in the log file
::C:\cygwin64\bin>bash.exe -login -c ("wc -l D:\/VRDreams_workspace\/Log_upload\/20160720.gstx.pc001.log.csv")

::to archive
move %attachment_dir%\%yesterday_archive_filename% %archive_dir%\
del %current_log_dir%\*.csv

pause
