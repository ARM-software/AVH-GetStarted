SET PATH=C:\Keil_v537\ARM\ARMCLANG\Bin;C:\Windows\system32;C:\Windows;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\Program Files\Microsoft VS Code\bin;C:\Program Files\Intel\WiFi\bin\;C:\Program Files\Common Files\Intel\WirelessCommon\;C:\Program Files\dotnet\;C:\Program Files\Svn\bin;C:\Program Files\TortoiseSVN\bin;C:\Program Files\doxygen186\bin;C:\Program Files\Mercurial\;C:\Program Files\doxygen_1.8.6\bin;C:\Program Files\nodejs\;C:\Program Files\PowerShell\7\;C:\Program Files\7-Zip\;C:\xmllint\;C:\Program Files\PuTTY\;C:\Program Files\Git\cmd;C:\Users\chrsei01\AppData\Local\Microsoft\WindowsApps;C:\Users\chrsei01\AppData\Local\GitHubDesktop\bin;C:\Users\chrsei01\AppData\Roaming\npm;C:\Program Files\CMake\bin;C:\00_ZeroInstall;C:\ti\ccs_base\common\uscif;
SET CPU_TYPE=ARMCM85
SET CPU_VENDOR=ARM
SET UV2_TARGET=Corstone-310
SET CPU_CLOCK=0x00B71B00
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\main.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\irq_armv8mml._ac"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_delay.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_evflags.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_evr.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_kernel.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_lib.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_memory.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_mempool.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_msgqueue.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_mutex.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_semaphore.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_system.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_thread.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_timer.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\os_systick.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\rtx_config.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\eventrecorder.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\retarget_io.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\startup_armcm85.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmClang.exe" @".\objects\system_armcm85.__i"
"C:\Keil_v537\ARM\ARMCLANG\Bin\ArmLink" --Via ".\Objects\Blinky.lnp"
