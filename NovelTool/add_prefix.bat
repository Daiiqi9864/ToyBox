@echo off
setlocal enabledelayedexpansion

:: 设置代码页为GBK (936) 以支持中文字符
chcp 936 >nul

:: 对当前目录下的targetDir子文件夹内，所有文件添加prefix作为前缀

:: 用户可修改的部分 - 开始
:: 设置目标文件夹名称和要添加的前缀
set "targetDir=目标文件夹名"
set "prefix=前缀-"
:: 用户可修改的部分 - 结束

:: 检查目标文件夹是否存在
if not exist "%targetDir%" (
    echo 文件夹 %targetDir% 不存在。
    pause
    exit /b
)

:: 进入目标文件夹
cd /d "%targetDir%"

:: 遍历目标文件夹中的所有文件并重命名
for %%f in (*.*) do (
    :: 获取不带扩展名的文件名和文件扩展名
    set "fileName=%%~nf"
    set "fileExt=%%~xf"
    
    :: 构建新的文件名
    set "newFileName=%prefix%!fileName!!fileExt!"
    
    :: 如果新旧文件名相同则跳过
    if not "%prefix%%%f"=="%%f" (
        :: 重命名文件
        ren "%%f" "!newFileName!"
    )
)

:: 返回上一级目录
cd ..

:: 恢复默认代码页
chcp 437 >nul

:: 通知用户操作完成
echo 文件名前缀添加完成。
pause