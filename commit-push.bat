@echo off
echo Committing and pushing changes...
echo.

git add .
git commit -m "Update"

git push

echo.
echo Done!
pause