# DumpCreds 2.0 
* Author: QDBA
* Version: Version 2.0
* Target: Windows

## Description

Dumps the usernames & plaintext passwords from 
 - Browsers (Crome, IE, FireFox)
 - Wifi 
 - SAM Hashes
 - M1m1Kate3 Dump
 
 without 
 - Use of USB Storage (Because USB Storage ist mostly blocked by USBGuard or DriveLock)
 - Without Internet connection (becaus Firewall ContentFilter Blocks the download sites)
 

## Configuration

None needed. 

## STATUS

| LED                | Status                                       |
| ------------------ | -------------------------------------------- |
| White              | Wait until drive are installed ( 25s)        |
| Red Blink Fast     | Impacket not found                           |
| Red Blink Slow     | Target did not acquire IP address            |
| Amber Blink Fast   | Initialization                               |
| Amber              | HID Stage                                    |
| Purple Blink Fast  | Wait for IP coming up                        |
| Purple Blink Slow  | Wait for Handshake (SMBServer Coming up)     |
| Purple / Amber     | Powershell scripts running                   |
| RED                | Error in Powershell Scripts                  |
| Green              | Finished                                     |
| ------------------ | -------------------------------------------- |

## Discussion

https://forums.hak5.org/index.php?/topic/40582-payload-drumpcreds-20-wo-internet-wo-usb-storage/
