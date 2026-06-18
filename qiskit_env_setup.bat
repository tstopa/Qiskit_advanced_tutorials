@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Qiskit Environment Setup Script
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo WARNING: Not running as administrator. Some operations may fail.
    echo Please right-click and select "Run as administrator" if issues occur.
    echo.
    pause
)

REM Set installation directory
set "INSTALL_DIR=%USERPROFILE%\miniforge3"
set "TEMP_DIR=%TEMP%\miniforge_install"

echo Step 1: Downloading Miniforge installer...
echo ========================================
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"

REM Download Miniforge for Windows
set "MINIFORGE_URL=https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe"
set "INSTALLER=%TEMP_DIR%\Miniforge3-Windows-x86_64.exe"

powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%MINIFORGE_URL%' -OutFile '%INSTALLER%'}"

if not exist "%INSTALLER%" (
    echo ERROR: Failed to download Miniforge installer
    pause
    exit /b 1
)

echo.
echo Step 2: Installing Miniforge...
echo ========================================
echo Installing to: %INSTALL_DIR%
echo This may take several minutes...
echo.

REM Install Miniforge silently
start /wait "" "%INSTALLER%" /InstallationType=JustMe /RegisterPython=1 /S /D=%INSTALL_DIR%

if not exist "%INSTALL_DIR%" (
    echo ERROR: Miniforge installation failed
    pause
    exit /b 1
)

echo Miniforge installed successfully!
echo.

REM Initialize conda for cmd.exe
echo Step 3: Initializing conda...
echo ========================================
call "%INSTALL_DIR%\Scripts\activate.bat"
call conda init cmd.exe
call conda init powershell

echo.
echo Step 4: Creating Qiskit environment...
echo ========================================
echo Creating conda environment 'qiskit_env'...
echo.

REM Create new environment with Python 3.11 (compatible with Qiskit)
call conda create -n qiskit_env python=3.11 -y

if %errorLevel% neq 0 (
    echo ERROR: Failed to create conda environment
    pause
    exit /b 1
)

echo.
echo Step 5: Activating environment and installing packages...
echo ========================================
call conda activate qiskit_env

echo Installing specified packages with exact versions...
echo This may take 10-15 minutes...
echo.

REM Install packages with exact versions
call pip install qiskit==2.4.1
call pip install qiskit-aer==0.17.2
call pip install qiskit-algorithms==0.4.0
call pip install qiskit-ibm-runtime==0.46.1
call pip install qiskit-machine-learning==0.8.4
call pip install qiskit-optimization==0.7.0
call pip install scikit-learn==1.7.2
call pip install scipy==1.15.3
call pip install numpy==2.3.3
call pip install notebook==7.5.0
call pip install networkx==3.6
call pip install matplotlib==3.10.7
call pip install matplotlib-inline==0.2.1
call pip install jupyter==1.1.1
call pip install ibm-platform-services==0.71.0
call pip install ibm-quantum-schemas==0.7.20260419

if %errorLevel% neq 0 (
    echo WARNING: Some packages may have failed to install
    echo Check the output above for details
    echo.
)

echo.
echo Step 6: Verifying installation...
echo ========================================
python -c "import qiskit; print('Qiskit version:', qiskit.__version__)"
python -c "import notebook; print('Jupyter Notebook installed successfully')"

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo Environment name: qiskit_env
echo Installation directory: %INSTALL_DIR%
echo.
echo To use your Qiskit environment:
echo 1. Open a new Command Prompt or PowerShell window
echo 2. Run: conda activate qiskit_env
echo 3. Run: jupyter notebook
echo.
echo The Jupyter Notebook will open in your default browser.
echo.
echo Cleaning up temporary files...
rmdir /s /q "%TEMP_DIR%" 2>nul

echo.
echo Press any key to exit...
pause >nul
