@echo off
setlocal enabledelayedexpansion

rem 当前文件夹下有着名称为 xx.yy 或 xx-yy 的文件。xx为1~30的数字。这个脚本把这些文件扔到子文件夹里。
rem 创建 A1 到 A30 的文件夹
for /L %%i in (1,1,30) do (
    set "folder=A%%i"
    if not exist "!folder!" (
        mkdir "!folder!"
        echo Created folder: !folder!
    ) else (
        echo Folder !folder! already exists.
    )
)

rem 移动文件到对应的子文件夹
for %%f in (*-*.*) do (
    set "filename=%%f"
    set "prefix=!filename:~0,2!"
    
    rem 检查前缀是否为数字
    if "!prefix!" gtr "0" if "!prefix!" lss "31" (
        set "target_folder=A!prefix!"
        if exist "!target_folder!" (
            move "%%f" "!target_folder!\"
            echo Moved file: %%f to !target_folder!
        ) else (
            echo Target folder !target_folder! does not exist.
        )
    )
)

endlocal
pause