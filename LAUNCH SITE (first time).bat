@echo off
REM ============================================================
REM  Double-click this ONCE, when you're ready to go live.
REM  It creates the public website and puts your dashboards on it.
REM  After this, the site updates itself every time your bots run.
REM ============================================================
cd /d "%~dp0"

echo Refreshing dashboards into the site...
copy /Y "C:\Users\Justin\Projects\daytrader-sim\dashboard.html" "daytrader.html" >nul
copy /Y "C:\Users\Justin\Projects\trading-scout\dashboard.html" "scout.html" >nul

echo Setting up the site...
git init -b main
git add -A
git -c user.email="2ndchanceproductions8@gmail.com" -c user.name="Justin" commit -m "Launch trading sims site"

echo Creating the public website (GitHub Pages)...
gh repo create trading-sims --public --source=. --remote=origin --push

echo Turning on GitHub Pages...
gh api -X POST repos/2ndchanceproductions8-cmd/trading-sims/pages -f "source[branch]=main" -f "source[path]=/" 2>nul

echo.
echo ============================================================
echo  DONE. Your site will be live in about 1 minute at:
echo.
echo    https://2ndchanceproductions8-cmd.github.io/trading-sims/
echo.
echo  Send that link to your friends (works on Mac, phone, anything).
echo ============================================================
echo.
pause
