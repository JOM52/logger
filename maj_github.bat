@echo off
rem Met a jour GitHub (JOM52/airsens) : commit local, pull (fusion), push (double-clic)
chcp 65001 > nul
cd /d "%~dp0"

git add .
git diff --cached --quiet
if errorlevel 1 (
    echo == Fichiers modifies :
    git status --short
    echo.
    call :commit
    if errorlevel 1 goto erreur
)

echo == Recuperation et fusion des modifications (git pull)
git pull --no-edit
if errorlevel 1 (
    echo.
    echo CONFLIT : corriger les fichiers marques ^<^<^<^<^<^<^< / ^>^>^>^>^>^>^>,
    echo puis : git add . ^&^& git commit --no-edit ^&^& git push
    pause
    exit /b 1
)

echo == Envoi (git push)
git push
if errorlevel 1 goto erreur

echo.
echo GitHub et le PC sont a jour.
pause
exit /b 0

:commit
set "MSG="
set /p "MSG=Message du commit (Entree = date du jour) : "
if "%MSG%"=="" set "MSG=Mise a jour PC %DATE% %TIME:~0,5%"
git commit -m "%MSG%"
exit /b %ERRORLEVEL%

:erreur
echo.
echo ERREUR : voir le message ci-dessus.
pause
exit /b 1
