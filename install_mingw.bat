@echo off

set repo_owner=niXman
set repo_name=mingw-builds-binaries
set unzip_path=C:
set url=https://www.7-zip.org/a/7z2201.exe
set installer_file=7z2201.exe

set "SEVENZIP_EXE=C:\Program Files (x86)\7-Zip\7z.exe"
if not exist "%SEVENZIP_EXE%" (
  echo 7zip is not installed, downloading installer...
  curl -L -o %installer_file% %url%
  echo Installing 7zip...
  start /wait %installer_file%
)

echo Retrieving latest release information...
for /f "usebackq tokens=2 delims== " %%G in (`curl -s https://api.github.com/repos/%repo_owner%/%repo_name%/releases/latest ^| findstr "browser_download_url"`) do set url=%%~G

if not exist "%unzip_path%" mkdir "%unzip_path%"

for /f "tokens=*" %%F in ("%url%") do set zip_file=%%~nxF

if not exist "%zip_file%" (
  echo Downloading %zip_file%...
  curl -L -o %zip_file% %url%
)

echo Extracting files to %unzip_path%...
"%SEVENZIP_EXE%" x "%zip_file%" -o"%unzip_path%"

echo %unzip_path%\mingw64\bin
setx PATH "%unzip_path%\mingw64\bin;%PATH%" /M

echo Done!
