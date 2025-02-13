@echo off
setlocal enabledelayedexpansion

:: 它将当前目录内的所有子目录中的文件，移动到当前目录下。

:: 获取当前目录
set "currentDir=%cd%"

:: 使用for循环递归遍历所有子目录及文件
for /r "%currentDir%" %%i in (*) do (
    :: 检查是否为文件
    if exist "%%i" (
        :: 移动文件到当前目录
        move "%%i" "%currentDir%"
    )
)

:: 通知用户操作完成
echo 文件移动完成。
pause
