% sschange(1) | User Commands
%
% "April 18 2024"

# NAME

sschange - utility to change the priority of existing processes

# SYNOPSIS

**sschange** _priority_ [_pid_] [_pid_...]

# DESCRIPTION

This manual page documents briefly the **sschange** command.

# OPTIONS

The first positional argument determines which slice the process(es) will be assigned to. All other arguments are interpreted as PIDs to assign. If no PIDs are specified, the caller's PID is used; this can be used to change the priority of an interactive shell.

Note that this is different and less reliable than executing commands with **ssrun**(1), since the reassigned process(es) lose their original CGroup assignment.

# SEE ALSO

**ssrun**(1), **simple-slices**(7)
