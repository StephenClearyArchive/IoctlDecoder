#!/bin/bash

echo Building file list...
find /cygdrive/c/WinDDK/7000.0.081212/inc -type f > tmp0.dat
find /cygdrive/c/Program\ Files/Microsoft\ SDKs/Windows/v7.0/Include -type f >> tmp0.dat

echo Searching for CTL_CODE...
# cat reads the file list
# xargs cat reads each line in each of those files
# sed recognizes backslash-escaping at the end of lines, and appends the next line if that's the case.
# sed strips any comments (C++ "//" style only); this removes comments after ioctl defitions and also removes commented-out ioctl definitions
# grep finds the lines containing CTL_CODE or its variations
# tr deletes tabs and spaces
cat tmp0.dat | xargs -i cat {} | sed -e :a -e '/\\$/N; s/\\\n//; ta' | sed -e 's://.*$::g' | grep -Ee '#define[ \t]+IOCTL_|CTL_CODE\(|_TDI_CONTROL_CODE\(|USB_CTL\(|USB_KERNEL_CTL\(|USB_KERNEL_CTL_BUFFERED\(|BTH_CTL\(|BTH_KERNEL_CTL\(' | tr -d '\t ' > tmp1.dat
rm tmp0.dat

echo Processing CTL_CODE definitions
gawk -f build.awk tmp1.dat > ioctl_db0.js
rm tmp1.dat

echo Post-processing
cscript //nologo postprocess.wsf > ioctl_db1.js
rm ioctl_db0.js

echo Compressing result
java -jar External/Dojo/custom_rhino.jar -c ioctl_db1.js > ioctl_db.js
rm ioctl_db1.js
