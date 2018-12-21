
# install ROS2 on Windows 10

## [cmd] start from installing choco

    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

## [cmd] choco install chrome

if you need a browser

    choco install -y GoogleChrome

## [cmd] choco install VisualStudio

    choco install -y VisualStudio2017Community
    choco install -y visualstudio2017-workload-vctools

## [cmd] choco install msys2

    choco install msys2

## [msys2] pacman install

    pacman -S msys/unzip

## [msys2] downloads

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
    unzip opencv-3.4.1-vc15.VS2017.zip
    mv opencv /c/  # use File Explorer if it doesn't work
    ./Win64OpenSSL-1_1_1a.exe

## [cmd] choco install ROS2 dependencies

    choco install -y python cmake git patch curl cppcheck
    choco install -y -s C:\tools\msys64\home\Administrator asio eigen tinyxml-usestl tinyxml2

## [cmd] pip install

    python -m pip install -U catkin_pkg empy git+https://github.com/lark-parser/lark.git@0.7b pyparsing pyyaml setuptools
    pip install -U vcstool colcon-common-extensions
    pip install -U pytest coverage mock
    pip install -U flake8 flake8-blind-except flake8-builtins flake8-class-newline flake8-comprehensions flake8-deprecated flake8-docstrings flake8-import-order flake8-quotes pep8 pydocstyle

## [cmd] PATH prepend

    setx Path "C:\Program Files\OpenSSL-Win64\bin;c:\opencv\x64\vc15\bin;C:\Program Files\CMake\bin;C:\ProgramData\chocolatey\lib\tinyxml2\lib;C:\Program Files\Git\cmd;C:\Program Files\Cppcheck;C:\tools\msys64\usr\bin;%Path%" /M

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

## [cmd,GUI] File Explorer Options

[ref](https://superuser.com/questions/744123/opening-folder-options-window-in-windows-from-the-command-prompt)

### method 1

    C:\Windows\System32\rundll32.exe shell32.dll,Options_RunDLL 7

### method 2

    control folders

then click "View" tab

### change some options

    Files and Folders
        [X] Display the full path in the title bar
        Hidden files and folders
            (*) Show hiddenfiles, folders, and drives
        [ ] Hide empty drives
        [ ] Hide extensions for known file types
        [ ] Hide folder merge conflicts
        [ ] Hide protected operating system files
    Navigation pane
        [X] Expand to open folder
        [X] Show all folders
        [X] Show libraries


# build a package

Make sure VisualStudio has the components installed.

![](vs2017.png)

## log4cxx as an example

### fetch code and apply patches

    wget http://archive.apache.org/dist/apr/apr-1.5.2-win32-src.zip
    wget http://archive.apache.org/dist/apr/apr-util-1.5.4-win32-src.zip
    wget https://archive.apache.org/dist/logging/log4cxx/0.10.0/apache-log4cxx-0.10.0.zip

    unzip apr-1.5.2-win32-src.zip > /dev/null 2>&1
    unzip apr-util-1.5.4-win32-src.zip > /dev/null 2>&1
    unzip apache-log4cxx-0.10.0.zip > /dev/null 2>&1

    mkdir ap
    mv apr-1.5.2 ap/apr
    mv apr-util-1.5.4 ap/apr-util
    mv apache-log4cxx-0.10.0 ap/log4cxx

    cd ap/log4cxx
    ./configure-aprutil.bat
    ./configure.bat

    ln -s /usr/bin/sed .

    sed -i "/#include <vector>/ a #include<iterator>" ../log4cxx/src/main/cpp/stringhelper.cpp
    sed -i "/namespace log4cxx/ i #define DELETED_CTORS(T) T(const T&) = delete; T& operator=(const T&) = delete;\n\n#define DEFAULTED_AND_DELETED_CTORS(T) T() = default; T(const T&) = delete; T& operator=(const T&) = delete;\n" ../log4cxx/src/main/include/log4cxx/helpers/objectimpl.h
    sed -i "/END_LOG4CXX_CAST_MAP()/ a \  DEFAULTED_AND_DELETED_CTORS(PatternConverter)" ../log4cxx/src/main/include/log4cxx/pattern/patternconverter.h
    sed -i "/virtual ~RollingPolicyBase();/ i \          DELETED_CTORS(RollingPolicyBase)" ../log4cxx/src/main/include/log4cxx/rolling/RollingPolicyBase.h
    sed -i "/virtual ~TriggeringPolicy();/ i \             DEFAULTED_AND_DELETED_CTORS(TriggeringPolicy)" ../log4cxx/src/main/include/log4cxx/rolling/TriggeringPolicy.h
    sed -i "/Filter();/ a \                        DELETED_CTORS(Filter)" ../log4cxx/src/main/include/log4cxx/spi/Filter.h
    sed -i "/virtual ~Layout();/ i \                DEFAULTED_AND_DELETED_CTORS(Layout)" ../log4cxx/src/main/include/log4cxx/Layout.h
    sed -i -e "s/defined(_MSC_VER) \&\&/defined(_MSC_VER) \&\& _MSC_VER < 1600 \&\&/" ../log4cxx/src/main/include/log4cxx/log4cxx.h

### build in VisualStudio

#### open log4cxx.dsw

![](01-log4cxx.dsw.png)
![](02-oneway_upgrade.png)
![](03-MigratingSolution.png)
![](04-VSready.png)


#### set the right platform

Right-click solution, then click "Configuration Manager..."

![](05-ConfigurationManager.png)
![](06-ConfigurationManager0.png)
![](07-ConfigurationManager1.png)
![](08-ConfigurationManager2.png)
![](09-ConfigurationManager3.png)
![](10-ConfigurationManager4.png)
![](11-ConfigurationManager5.png)
![](12-ConfigurationManager6.png)
![](13-ConfigurationManager7.png)
![](14-ConfigurationManager_DONE.png)

#### retarget solution

Right-click solution, then click "Retarget solution..."

![](15-RetargetSolution.png)
![](16-RetargetProjects.png)
![](17-RetargetProjects_DONE.png)

#### additional lib

Additional Dependency rpcrt4.lib

![](18-log4cxx_Properties.png)
![](19-AdditionalDeps.png)
![](20-AdditionalDeps_rpcrt4.lib.png)
![](21-AdditionalDeps_DONE.png)

#### build

Right-click log4cxx, then click build

![](22-log4cxx_Build.png)
![](23-log4cxx_Build1.png)
![](24-log4cxx_Build2.png)
![](25-log4cxx_Build3.png)
![](26-log4cxx_Build4.png)
![](27-log4cxx_Build5.png)
![](28-log4cxx_Build_DONE.png)


