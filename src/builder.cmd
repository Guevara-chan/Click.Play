setlocal
set tmp_exe=Click.Play.exe

if exist %tmp_exe% ( del %tmp_exe% )
C:/Utils/[dot]Net/Boo/bin/booc.exe -debug- -embedres:inc_btn.wav,inc_sound -embedres:dec_btn.wav,dec_sound -embedres:null_btn.wav,null_sound Click.Play.boo

if exist %tmp_exe% (
if "%release_exe%" NEQ "" (
	"%reshacker%" -open %tmp_exe% -save %tmp_exe% -action addoverwrite -resource Counter.ico -mask ICONGROUP, MAINICON, 0
	"%ilmerge%" %tmp_exe% Boo.Lang.dll /t:winexe /ndebug /out:%release_exe%
	del %tmp_exe%
	%release_exe%	
) else ( %tmp_exe% )
)