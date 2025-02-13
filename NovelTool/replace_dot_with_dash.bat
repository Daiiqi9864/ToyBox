@echo off
setlocal enabledelayedexpansion

rem 它把当前目录内所有 .png 文件的名称内（不含后缀），"."替换成"-"
rem 设置根目录
set root_folder=%~dp0

rem 遍历根目录及其子目录中的所有 .png 文件
for /r "%root_folder%" %%f in (*.png) do (
    set "old_filename=%%~nf"
    set "new_filename=!old_filename:.=-!"
    set "file_ext=%%~xf"
    set "full_old_path=%%f"
    set "full_new_path=%%~dpf!new_filename!!file_ext!"

    rem 检查是否有需要替换的字符
    if not "!old_filename!"=="!new_filename!" (
        if not exist "!full_new_path!" (
            ren "!full_old_path!" "!new_filename!!file_ext!"
            echo Renamed: "!full_old_path!" to "!full_new_path!"
        ) else (
            echo File "!full_new_path!" already exists. Skipping.
        )
    )
)

echo All files processed.
pause