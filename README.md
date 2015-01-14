# Packer templates for Oracle Enterprise Linux

### Overview

This repository contains templates for Oracle Enterprise Linux that can create
Vagrant boxes using Packer.

## Current Boxes

64-bit boxes:

* Oracle Enterprise Linux 7.0 (64-bit), VirtualBox 397MB/Parallels 430MB
* Oracle Enterprise Linux 7.0 Desktop (64-bit), VirtualBox 932MB/Parallels 962MB
* Oracle Enterprise Linux 6.6 (64-bit), VMware 588MB/VirtualBox 508MB/Parallels 588MB
* Oracle Enterprise Linux 6.6 (64-bit), VMware 1.2GB/VirtualBox 1.2GB/Parallels 1.3GB
* Oracle Enterprise Linux 6.5 (64-bit), VMware 561MB/VirtualBox 513MB/Parallels 579MB
* Oracle Enterprise Linux 6.5 (64-bit), VMware 1.2GB/VirtualBox 1.1GB/Parallels 1.2GB
* Oracle Enterprise Linux 6.4 (64-bit), VMware 501MB/VirtualBox 427MB/Parallels 484MB
* Oracle Enterprise Linux 5.11 (64-bit), VMware 278MB/VirtualBox 302MB
* Oracle Enterprise Linux 5.10 (64-bit), VMware 278MB/VirtualBox 203MB
* Oracle Enterprise Linux 5.9 (64-bit), VMware 277MB/VirtualBox 198MB
* Oracle Enterprise Linux 5.8 (64-bit), VMware 262MB/VirtualBox 187MB
* Oracle Enterprise Linux 5.7 (64-bit), VMware 263MB/VirtualBox 188MB

32-bit boxes:

* Oracle Enterprise Linux 6.6 (32-bit), VMware 501MB/VirtualBox 433MB/Parallels 484MB
* Oracle Enterprise Linux 6.5 (32-bit), VMware 471MB/VirtualBox 400MB/Parallels 477MB
* Oracle Enterprise Linux 6.4 (32-bit), VMware 422MB/VirtualBox 379MB/Parallels 445MB
* Oracle Enterprise Linux 5.11 (32-bit), VMware 268MB/VirtualBox 192MB
* Oracle Enterprise Linux 5.10 (32-bit), VMware 262MB/VirtualBox 194MB
* Oracle Enterprise Linux 5.9 (32-bit), VMware 260MB/VirtualBox 188MB
* Oracle Enterprise Linux 5.8 (32-bit), VMware 252MB/VirtualBox 177MB
* Oracle Enterprise Linux 5.7 (32-bit), VMware 253MB/VirtualBox 178MB

## Building the Vagrant boxes

To build all the boxes, you will need Packer and both VirtualBox, VMware
Fusion, and Parallels Desktop for Mac installed.

Parallels requires that the
[Parallels Virtualization SDK for Mac](http://ww.parallels.com/downloads/desktop)
be installed as an additional preqrequisite.

A GNU Make `Makefile` drives the process via the following targets:

    make        # Build all the box types (VirtualBox, VMware & Parallels)
    make test   # Run tests against all the boxes
    make list   # Print out individual targets
    make clean  # Clean up build detritus

### Proxy Settings

The templates respect the following network proxy environment variables
and forward them on to the virtual machine environment during the box creation
process, should you be using a proxy:

* http_proxy
* https_proxy
* ftp_proxy
* rsync_proxy
* no_proxy

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

    make ssh-box/virtualbox/oel65-nocm.box

Upon logout `make ssh-*` will automatically de-register the box as well.

### Makefile.local override

You can create a `Makefile.local` file alongside the `Makefile` to override
some of the default settings.  The variables can that can be currently
used are:

* CM
* CM_VERSION
* HEADLESS
* \<iso_path\>
* UPDATE

`Makefile.local` is most commonly used to override the default configuration
management tool, for example with Chef:

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

The variable `HEADLESS` can be set to run Packer in headless mode.
Set `HEADLESS := true`, the default is false.

The variable `UPDATE` can be used to perform OS patch management.  The
default is to not apply OS updates by default.  When `UPDATE := true`,
the latest OS updates will be applied.

Another use for `Makefile.local` is to override the default locations
for the Oracle Enterprise Linux install ISO files.

For Oracle Enterprise Linux, the ISO path variables are:

* ORACLE70_X86_64
* ORACLE66_X86_64
* ORACLE65_X86_64
* ORACLE64_X86_64
* ORACLE511_X86_64
* ORACLE510_X86_64
* ORACLE59_X86_64
* ORACLE58_X86_64
* ORACLE57_X86_64
* ORACLE66_I386
* ORACLE65_I386
* ORACLE64_I386
* ORACLE511_I386
* ORACLE510_I386
* ORACLE59_I386
* ORACLE58_I386
* ORACLE57_I386

This override is commonly used to speed up Packer builds by
pointing at pre-downloaded ISOs instead of using the default
download Internet URLs:
`ORACLE66_X86_64 := file:///Volumes/OL6/OracleLinux-R6-U6-Server-x86_64-dvd.iso`
