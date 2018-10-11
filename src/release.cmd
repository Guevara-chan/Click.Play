REM --Setup util_root for actual path.
chcp 65001
setlocal
set tmp_exe=Click.Play.exe
set util_root=C:/Utils

if exist %tmp_exe% ( del %tmp_exe% )
%util_root%/[dot]Net/Boo/bin/booc.exe -embedres:inc_btn.wav,inc_sound -embedres:dec_btn.wav,dec_sound -embedres:null_btn.wav,null_sound -debug- -i:Counter.ico Click.Play.boo

if exist %tmp_exe% (
%util_root%/[dot]Net/Extra/ILMerge/ilmerge.exe %tmp_exe% C:/Utils/[dot]Net/Boo/bin/Boo.Lang.dll /t:winexe /ndebug /out:../[Click.Play].exe
del %tmp_exe%
)