% simple-slices(7) | Miscellaneous
%
% "October 6 2023"

# NAME

simple-slices - priority-based resource division via simple categories

# USAGE

SystemD services can be assigned to a slice by adding a drop-in file to that service which specifies the Slice directive. Such files should ideally be placed in /etc/systemd/system/NAME.service.d/SLICE.conf for system services and /etc/systemd/user/NAME.service.d/SLICE.conf for user services, where "NAME" is the name of the service and "SLICE" is the desired slice.

Individual commands can also be run within a slice, most conveniently with the **ssrun(1)** command. It is strongly recommended to execute scripts within slices by creating a SystemD service file that executes the script and has the Slice directive, rather than invoking **systemd-run(1)** or **ssrun(1)** within the script.

# DESCRIPTION

This manual page documents briefly the intended usage of the Simple Slices package.

**simple-slices** is a program that...

# FILES

/etc/foo.conf
:   The system-wide configuration file to control the behaviour of
    simple-slices. See **foo.conf**(5) for further details.

${HOME}/.foo.conf
:   The per-user configuration file to control the behaviour of
    simple-slices. See **foo.conf**(5) for further details.

# BUGS

A restart may be required in order to start using all features. Individual (non-root) users may need to manually enable simple-slices.target.

Please report bugs to https://github.com/ATLief/simple-slices/issues.

# SEE ALSO

**ssrun**(1), **ssrun_sym**(1)
