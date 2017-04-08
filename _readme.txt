USAGE
-----

To use (from Command Prompt):
    ioctl [--decimal] [--device] value
where "value" can be a decimal, hexadecimal (optionally prefixed with "0x"), or case-insensitive regular expression string value.
If [--decimal] is passed, then "value" must be a decimal value.
If [--device] is passed, then "value" is used to search defined device types instead of IOCTLs.

Note that the device searching may produce superfluous answers; e.g., FILE_DEVICE_SCSI and FILE_DEVICE_SERIAL_PORT have the same underlying value, so any search for either device will include all ioctls of both devices. Also note that not all symbolic constants are preserved in the database; in particular, all of the ".*_BASE" names are not kept.

Multiple results may be returned with string values (or if a decimal value may be interpreted as a valid hexadecimal value and they are both defined ioctl codes):
    >ioctl simbad

    Found 2 matching IOCTLs:

    IOCTL: 0x7d000 (IOCTL_DISK_SIMBAD)
    Device: 0x7 (FILE_DEVICE_DISK)
    Function: 0x400
    Access: 0x3 (FILE_READ_ACCESS | FILE_WRITE_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)

    IOCTL: 0x2400c (IOCTL_CDROM_PAUSE_AUDIO or IOCTL_CDROM_SIMBAD)
    Device: 0x2 (FILE_DEVICE_CD_ROM)
    Function: 0x3
    Access: 0x1 (FILE_READ_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)

Ambiguous numbers are searched as both decimal and hexadecimal; to force a hexadecimal search, prefix with "0x":
    >ioctl --device 12

    Found 4 matching IOCTLs:

    IOCTL: 0x120003 (IOCTL_TCP_QUERY_INFORMATION_EX)
    Device: 0x12 (FILE_DEVICE_NETWORK)
    Function: 0x0
    Access: 0x0 (FILE_ANY_ACCESS)
    Method: 0x3 (METHOD_NEITHER)

    IOCTL: 0x128030 (IOCTL_IP_SET_FIREWALL_HOOK)
    Device: 0x12 (FILE_DEVICE_NETWORK)
    Function: 0xc
    Access: 0x2 (FILE_WRITE_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)

    IOCTL: 0x128058 (IOCTL_PF_SET_EXTENSION_POINTER)
    Device: 0x12 (FILE_DEVICE_NETWORK)
    Function: 0x16
    Access: 0x2 (FILE_WRITE_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)

    IOCTL: 0xc4003 (FSCTL_MAILSLOT_PEEK)
    Device: 0xc (FILE_DEVICE_MAILSLOT)
    Function: 0x0
    Access: 0x1 (FILE_READ_ACCESS)
    Method: 0x3 (METHOD_NEITHER)

Special "notes" are printed if:
1) The device type has the common bit set (indicating a non-Microsoft-defined device type)
2) The function code has the custom bit set (indicating a non-Microsoft-defined function code)
3) An inexact match is found

If a numeric value is not known, then it will be decoded to device/function/access/method (giving the device name, if known):
    >ioctl 0x2a2008

    Found 1 matching IOCTLs:

    IOCTL: 0x2a2008 <decoded>
    Device: 0x2a (FILE_DEVICE_BUS_EXTENDER)
    Function: 0x802
    Access: 0x0 (FILE_ANY_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)
    Note: Function code has the custom bit set

    >ioctl 0x80042008

    Found 1 matching IOCTLs:

    IOCTL: 0x80042008 <decoded>
    Device: 0x8004
    Function: 0x802
    Access: 0x0 (FILE_ANY_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)
    Note: Device type has the common bit set
    Note: Function code has the custom bit set

In addition, notes can indicate "close" matches for decoded ioctls (i.e., a match on device and function but mismatch on access and/or method):
    >ioctl 0x4d0004

    Found 1 matching IOCTLs:

    IOCTL: 0x4d0004 <decoded>
    Device: 0x4d (MOUNTDEVCONTROLTYPE)
    Function: 0x1
    Access: 0x0 (FILE_ANY_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)
    Note: Inexact match found for 0x4dc004 (IOCTL_MOUNTDEV_UNIQUE_ID_CHANGE_NOTIFY)

    >ioctl 0x4dc004

    Found 1 matching IOCTLs:

    IOCTL: 0x4dc004 (IOCTL_MOUNTDEV_UNIQUE_ID_CHANGE_NOTIFY)
    Device: 0x4d (MOUNTDEVCONTROLTYPE)
    Function: 0x1
    Access: 0x3 (FILE_READ_ACCESS | FILE_WRITE_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)

If a device is searched for that has no defined ioctls, then a fake ioctl is returned:
    >ioctl --device datalink

    Found 1 matching IOCTLs:

    IOCTL: 0x50000 (fake)
    Device: 0x5 (FILE_DEVICE_DATALINK)
    Function: 0x0
    Access: 0x0 (FILE_ANY_ACCESS)
    Method: 0x0 (METHOD_BUFFERED)


BINARIES
--------

A "binary" distribution may be created which includes only the following files:
  ioctl.bat
  ioctl.wsf
  ioctl.js
  ioctl_db.js

The "binary" usage does not require any additional tools, but rebuilding the ioctl database requires the Cygwin toolset and a Java runtime.


UPDATING WITH NEW SDK/WDK
-------------------------

To rebuild the IOCTL database (from Cygwin Shell):
  1) Manually change file locations of WDK and SDK in build.sh
  2) Fix build.sh to use Unix line endings ("d2u build.sh")
  3) ./build.sh (uses build.awk, postprocess.wsf, dump.js, and External/Dojo/custom_rhino.jar to generate ioctl_db.js)
The build process will generate warnings for any suspected new IOCTL groupings, unknown values, etc. Some of these are normal; some will require updating the build scripts.
Currently, there are two warnings:
  Unrecognized device: FILE_DEVICE_AVIO
  Improper IOCTL definition: 2∟1003∟0∟1 -> 2∟3∟0∟1 for IOCTL_CDROM_SIMBAD

To generate new stats (from Command Prompt):
  stats


HISTORY
-------

Version history:
  1.5 Beta (2009-02-17) - Recognizes 77 device types (74 unique values) and 901 ioctl codes (877 unique values) - built against WDK 7000.0.081212 Beta and SDK v7.0 Beta (7000.0.4011)
  1.4 (2008-06-13) - Recognizes 75 device types (72 unique values) and 857 ioctl codes (831 unique values) - built against WDK 6001.18001 and SDK v6.1 (6001.18000.367)
    Added [--decimal] and [--device] parameters to allow forcing of decimal searches and searching device names
  1.3 (2008-06-09) - Recognizes 75 device types (72 unique values) and 857 ioctl codes (831 unique values) - built against WDK 6001.18001 and SDK v6.1 (6001.18000.367)
    First source release (previously only existed in "binary" form on my personal web page)
  1.2 - Recognizes 75 device types (72 unique values) and 857 ioctl codes (831 unique values) - built against WDK 6001.18000 and SDK 6000.16384.10
  1.1 - Recognizes 75 device types (72 unique values) and 847 ioctl codes (823 unique values) - built against WDK 6000 and SDK 6000.16384.10
  1.0 - Recognizes 72 device types and 786 ioctl codes.
