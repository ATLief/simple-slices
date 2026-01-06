# Simple-Slices
<!-- Nice for all system resources -->

Running programs on a Linux system can share available resources using a feature called "CGroups", which Systemd refers to as "Slices". It supports more types of resources than "nice" or "ionice" and natively integrates with Systemd units. Unfortunately, very few people benefit from these features due to the lack of user-friendly defaults.

This project addresses that issue by defining 7 Slices with a unified priority level for CPU processing, disk bandwidth, RAM storage, and PID assignment (future versions may also support priorities for network bandwidth, swappiness, VRAM, and core types of hybrid CPUs). It can optionally change the default priority levels for certain types of programs to optimize performance for desktops or servers without needing additional configuration.

<!-- To enable one of the optimized defaults, install one of the simple-slices-preset-* packages. Instructions for usage and more technical information can be viewed by running "man simple-slices". -->

## Usage

To change the priority level for a particular Systemd Service or Scope, assign it to the Slice corresponding to that priority level. This can be done by adding a drop-in file for that Systemd unit which specifies the "Slice=" directive. Such files for Services should ideally be named "/etc/systemd/system/NAME.service.d/priority.conf" for system Services or "/etc/systemd/user/NAME.service.d/priority.conf" for user Services, where "NAME" is the name of the Service. Unprivileged users can also name it "~/.config/systemd/user/NAME.service.d/priority.conf", however this will only affect their own login session.

Individual commands can be run with a certain priority level by using the **ssrun**(1) wrapper command, which itself uses **systemd-run**(1). Individual graphical applications can also be given a certain priority level, however this will depend on the desktop environment being used and the type of graphical application being run. More information about how to do this will be added in the future.

Note: A reboot may be required after installation to use some features. Individual (non-root) users may need to manually enable simple-slices.target.
