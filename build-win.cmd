@Echo off
cls
echo -----------------------------------------
echo      Start generating UI for ESPEasy
echo -----------------------------------------
del *.h > nul
call gulp jade

cd .tmp
del *.h > nul

for %%f in (*.*) do (
  echo Processing: %%f
  C:\cygwin64\bin\xxd -i %%f > %%~nf.h
  C:\cygwin64\bin\sed "s/unsigned char %%~nf\_html\[\] \=/const char %%~nf_html[] PROGMEM =/" %%~nf.h | sed "s/unsigned int/const int/" >../%%~nf.h
  echo Resulting : %%~nf.h
)
echo -----------------------------------------
echo                 Done. 
echo -----------------------------------------
