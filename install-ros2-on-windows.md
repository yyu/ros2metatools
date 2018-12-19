
# install ROS2 on Windows 10

## [cmd] start from installing choco

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

## [cmd] choco install VisualStudio

    choco install visualstudio2017-installer

## [cmd] choco install cygwin

    choco install Cygwin

### [GUI] cygwin install wget

    C:\tools\cygwin\cygwinsetup.exe

## [cygwin] install apt-cyg

    wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
    install apt-cyg /bin

## [cygwin] downloads

    cat > wget-list << "EOF"
    https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg
    https://github.com/ros2/choco-packages/releases/download/2018-06-12-1/asio.1.12.1.nupkg
    https://github.com/ros2/choco-packages/releases/download/2018-06-12-1/eigen.3.3.4.nupkg
    https://github.com/ros2/choco-packages/releases/download/2018-06-12-1/tinyxml-usestl.2.6.2.nupkg
    https://github.com/ros2/choco-packages/releases/download/2018-06-12-1/tinyxml2.6.0.0.nupkg
    https://github.com/ros2/ros2/releases/download/opencv-archives/opencv-3.4.1-vc15.VS2017.zip
    https://slproweb.com/download/Win64OpenSSL-1_1_1a.exe
    EOF

    wget --input-file=wget-list
    mv opencv-3.4.1-vc15.VS2017.zip /cygdrive/c/Users/Administrator/Downloads/  # needs to be extracted as C:\opencv
    chmod +x Win64OpenSSL-1_1_1a.exe
    ./Win64OpenSSL-1_1_1a.exe

## [cmd] choco install ROS2 dependencies

    choco install -y python cmake git patch curl cppcheck
    choco install -y -s C:\tools\cygwin\home\Administrator asio eigen tinyxml-usestl tinyxml2

## [cmd] pip install

    python -m pip install -U catkin_pkg empy git+https://github.com/lark-parser/lark.git@0.7b pyparsing pyyaml setuptools
    pip install -U vcstool colcon-common-extensions
    pip install -U pytest coverage mock
    pip install -U flake8 flake8-blind-except flake8-builtins flake8-class-newline flake8-comprehensions flake8-deprecated flake8-docstrings flake8-import-order flake8-quotes pep8 pydocstyle

## [GUI] PATH prepend

    C:\Program Files\OpenSSL-Win64\bin;c:\opencv\x64\vc15\bin;C:\Program Files\CMake\bin;C:\ProgramData\chocolatey\lib\tinyxml2\lib;C:\Program Files\Git\cmd;C:\Program Files\Cppcheck;

## [cmd] env variables

    setx -m OPENSSL_CONF "C:\Program Files\OpenSSL-Win64\bin\openssl.cfg"
    setx -m OpenCV_DIR C:\opencv
    setx -m Qt5_DIR C:\Qt\5.10.0\msvc2017_64

## [cmd] pre-build

    cd \
    md \dev\ros2\src
    cd \dev\ros2

    curl -sk https://raw.githubusercontent.com/ros2/ros2/release-latest/ros2.repos -o ros2.repos
    vcs import src < ros2.repos

## [x64 Native Tools Command Prompt for VS 2017] build

    echo > C:\dev\ros2\src\ros2\rviz\AMENT_IGNORE
    cd C:\dev\ros2
    colcon build --merge-install

