% sschange(1) | User Commands
%
% "March 30 2024"

# NAME

sschange - utility to change the priority of existing processes

# SYNOPSIS

**sschange** _priority_ [_pid_] [_pid_...]

# DESCRIPTION

This manual page documents briefly the **sschange** command.

# OPTIONS

The first positional argument determines which slice the process(es) will be assigned to. All other arguments are interpreted as PIDs to assign. If no PIDs are specified, the caller's PID is used; this can be used to change the priority of an interactive shell.

Note that this is different and less reliable than executing commands with **ssrun**(1), since the reassigned process(es) lose their original CGroup assignment.

# FILES

/etc/foo.conf
:   The system-wide configuration file to control the behaviour of
    sschange. See **foo.conf**(5) for further details.

${HOME}/.foo.conf
:   The per-user configuration file to control the behaviour of
    sschange. See **foo.conf**(5) for further details.

# ENVIRONMENT

**FOO_CONF**
:   If used, the defined file is used as configuration file (see also
    the section called “FILES”).

# DIAGNOSTICS

The following diagnostics may be issued on stderr:

Bad configuration file. Exiting.
:   The configuration file seems to contain a broken configuration
    line. Use the **\-\-verbose** option, to get more info.

**sschange** provides some return codes, that can be used in scripts:

    Code Diagnostic
    0 Program exited successfully.
    1 The configuration file seems to be broken.

# BUGS

Please report bugs to https://github.com/ATLief/simple-slices/issues.

# SEE ALSO

**ssrun**(1), **simple-slices**(7)
