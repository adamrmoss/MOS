#!/usr/bin/env coffee

child_process = require 'child_process'
program = require 'commander'

executeCommand = (commandLine)->
  console.log('Executing: ' + commandLine)
  child_process.execSync commandLine

program
  .command 'boot'
  .description 'Boot up Mos'
  .action (env, options)->
    console.log 'Booting Mos...'
    executeCommand 'qemu-system-i386 -m 1 -fda disks/mos.img -boot a'

program
  .command 'dos'
  .description 'Boot up DOS 3.3'
  .action (env, options)->
    console.log 'Booting DOS 3.3...'
    executeCommand 'qemu-system-i386 -m 1 -fda disks/dos3.3.img -boot a'

program
  .command 'mount'
  .description 'Mount the Floppy Disk Image to OSX'
  .action (env, options)->
    console.log 'Mounting Mos Floppy Disk...'
    executeCommand 'hdiutil attach disks/mos.img'

program
  .command 'build'
  .description 'Build Mos'
  .action (env, options)->
    console.log 'Extracting BIOS Parameter Block from disk image...'
    executeCommand 'dd if=disks/mos.img of=build/bpb conv=notrunc bs=1 skip=3 count=59'
    console.log '\nBuilding boot sector...'
    executeCommand 'nasm -f bin source/boot.asm -o build/boot'
    console.log '\nWriting BIOS Parameter Block to boot sector...'
    executeCommand 'dd if=build/bpb of=build/boot conv=notrunc bs=1 count=59 seek=3'
    console.log '\nWriting boot sector to disk image...'
    executeCommand 'dd if=build/boot of=disks/mos.img conv=notrunc'

program
  .parse process.argv
