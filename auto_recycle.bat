@echo off
set INTERVAL=300
:Again
echo start server
taskkill /f /t /im streamlit.exe
set /a num = %random%
echo %num%
start streamlit run main.py --server.port %num% --server.headless true
timeout %INTERVAL%
goto Again
