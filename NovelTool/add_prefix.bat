@echo off
setlocal enabledelayedexpansion

:: ���ô���ҳΪGBK (936) ��֧�������ַ�
chcp 936 >nul

:: �Ե�ǰĿ¼�µ�targetDir���ļ����ڣ������ļ����prefix��Ϊǰ׺

:: �û����޸ĵĲ��� - ��ʼ
:: ����Ŀ���ļ������ƺ�Ҫ��ӵ�ǰ׺
set "targetDir=Ŀ���ļ�����"
set "prefix=ǰ׺-"
:: �û����޸ĵĲ��� - ����

:: ���Ŀ���ļ����Ƿ����
if not exist "%targetDir%" (
    echo �ļ��� %targetDir% �����ڡ�
    pause
    exit /b
)

:: ����Ŀ���ļ���
cd /d "%targetDir%"

:: ����Ŀ���ļ����е������ļ���������
for %%f in (*.*) do (
    :: ��ȡ������չ�����ļ������ļ���չ��
    set "fileName=%%~nf"
    set "fileExt=%%~xf"
    
    :: �����µ��ļ���
    set "newFileName=%prefix%!fileName!!fileExt!"
    
    :: ����¾��ļ�����ͬ������
    if not "%prefix%%%f"=="%%f" (
        :: �������ļ�
        ren "%%f" "!newFileName!"
    )
)

:: ������һ��Ŀ¼
cd ..

:: �ָ�Ĭ�ϴ���ҳ
chcp 437 >nul

:: ֪ͨ�û��������
echo �ļ���ǰ׺�����ɡ�
pause