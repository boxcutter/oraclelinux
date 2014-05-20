# Packer templates for Oracle Enterprise Linux

### Overview

This repository contains templates for Oracle Enterprise Linux that can create
Vagrant boxes using Packer.

## Current Boxes

64-bit boxes:

* [box-cutter/oel65](https://vagrantcloud.com/box-cutter/oel65) - Oracle Enterprise Linux 6.5 (64-bit)
* [box-cutter/oel64](https://vagrantcloud.com/box-cutter/oel64) - Oracle Enterprise Linux 6.4 (64-bit)
* [box-cutter/oel510](https://vagrantcloud.com/box-cutter/oel510) - Oracle Enterprise Linux 5.10 (64-bit)
* [box-cutter/oel59](https://vagrantcloud.com/box-cutter/oel59) - Oracle Enterprise Linux 5.9 (64-bit)
* [box-cutter/oel58](https://vagrantcloud.com/box-cutter/oel58) - Oracle Enterprise Linux 5.8 (64-bit)
* [box-cutter/oel57](https://vagrantcloud.com/box-cutter/oel57) - Oracle Enterprise Linux 5.7 (64-bit)

32-bit boxes:

* [box-cutter/oel65-i386](https://vagrantcloud.com/box-cutter/oel65-i386) - Oracle Enterprise Linux 6.5 (32-bit)
* [box-cutter/oel64-i386](https://vagrantcloud.com/box-cutter/oel64-i386) - Oracle Enterprise Linux 6.4 (32-bit)
* [box-cutter/oel510-i386](https://vagrantcloud.com/box-cutter/oel510-i386) - Oracle Enterprise Linux 5.10 (32-bit)
* [box-cutter/oel59-i386](https://vagrantcloud.com/box-cutter/oel59-i386) - Oracle Enterprise Linux 5.9 (32-bit)
* [box-cutter/oel58-i386](https://vagrantcloud.com/box-cutter/oel58-i386) - Oracle Enterprise Linux 5.8 (32-bit)
* [box-cutter/oel57-i386](https://vagrantcloud.com/box-cutter/oel57-i386) - Oracle Enterprise Linux 5.7 (32-bit)

## Building the Vagrant boxes

To build all the boxes, you will need Packer and both VirtualBox and VMware Fusion
installed.

A GNU Make `Makefile` drives the process via the following targets:

    make        # Build all the box types (VirtualBox & VMware)
    make test   # Run tests against all the boxes
    make list   # Print out individual targets
    make clean  # Clean up build detritus
    
### Tests

The tests are written in [Serverspec](http://serverspec.org) and require the
`vagrant-serverspec` plugin to be installed with:

    vagrant plugin install vagrant-serverspec
    
The `Makefile` has individual targets for each box type with the prefix
`test-*` should you wish to run tests individually for each box.

Similarly there are targets with the prefix `ssh-*` for registering a
newly-built box with vagrant and for logging in using just one command to
do exploratory testing.  For example, to do exploratory testing
on the VirtualBox training environmnet, run the following command:

    make ssh-box/virtualbox/centos65-nocm.box
    
Upon logout `make ssh-*` will automatically de-register the box as well.

### Makefile.local override

You can create a `Makefile.local` file alongside the `Makefile` to override
some of the default settings.  It is most commonly used to override the
default configuration management tool, for example with Chef:

    # Makefile.local
    CM := chef

Changing the value of the `CM` variable changes the target suffixes for
the output of `make list` accordingly.

Possible values for the CM variable are:

* `nocm` - No configuration management tool
* `chef` - Install Chef
* `puppet` - Install Puppet
* `salt`  - Install Salt

You can also specify a variable `CM_VERSION`, if supported by the
configuration management tool, to override the default of `latest`.
The value of `CM_VERSION` should have the form `x.y` or `x.y.z`,
such as `CM_VERSION := 11.12.4`

Another use for `Makefile.local` is to override the default locations
for the Ubuntu install ISO files.

For Oracle Enterprise Linux, the ISO path variables are:

* ORACLE65_X86_64
* ORACLE64_X86_64
* ORACLE510_X86_64
* ORACLE59_X86_64
* ORACLE58_X86_64
* ORACLE57_X86_64
* ORACLE65_I386
* ORACLE64_I386
* ORACLE510_I386
* ORACLE59_I386
* ORACLE58_I386
* ORACLE57_I386

This override is commonly used to speed up Packer builds by
pointing at pre-downloaded ISOs instead of using the default
download Internet URLs:
`ORACLE65_X86_64 := file:///Volumes/OL6/OracleLinux-R6-U5-Server-x86_64-dvd.iso`
