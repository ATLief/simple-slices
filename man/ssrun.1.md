% ssrun(1) | User Commands
%
% "April 18 2024"

# NAME

ssrun - utility to execute commands with specified priority

# SYNOPSIS

**ssrun** _slice_ [_systemd-run options_] _command_ [_command arguments_]

# DESCRIPTION

This manual page documents briefly the **ssrun** command and (symbolic links of) the **ssrun_sym** command.

**ssrun** is a somewhat simple wrapper of **systemd-run**(1); it creates a systemd scope, assigns that scope to the specified slice, and then executes the specified command within the scope. The scope (and thus the command) attachs to the current TTY and inherits all environment variables, as if that command was executed without the wrapper.

If **ssrun** is executed as a user with UID 0 (usually the root user), **systemd-run**(1) is executed in system mode. Otherwise it is executed in user mode.

**Note: the PID of this command invocation is currently not the same as the PID of the command executed within the scope.**

# OPTIONS

**ssrun** relies on a single positional argument for which slice the command should be assigned to. All other arguments are passed to **systemd-run**(1); which arguments are interpreted as **systemd-run**(1) options, the command, or the command's arguments are determined by that command. See the relevant documentation for details.

(Symbolic links) of **ssrun_sym** internally call **ssrun** with the base of their name automatically provided as the first positional argument. All other arguments are appended to that call. Thus, these "commands" pass all specified arguments to **systemd-run**(1), and the desired slice is specified by using the respective symlink.

**ssrun** automatically appends **\-\-system** to the **systemd-run**(1) options if the effective UID of the invoking user is 0 (usually the root user). Otherwise it appends the **\-\-user** option. This behavior can be overridden by additionally supplying one of these options before the desired command. When run in user mode, slices are created within your user session, and so only affect their priority relative to the other processes within your session.

# SEE ALSO

**simple-slices**(7), **systemd-run**(1), **systemd.scope**(1)
