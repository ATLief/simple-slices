% ssrun(1) | User Commands
%
% "October 2 2023"

# NAME

ssrun - program to do something

# SYNOPSIS

**ssrun** _slice_ [_systemd-run options_] _command_ [_command arguments_]

**ssrun** [{**-h** | **\-\-help**} | {**-v** | **\-\-version**}]

# DESCRIPTION

This manual page documents briefly the **ssrun** command and (symbolic links of) the **ssrun_sym** command.

**ssrun** is a somewhat simple wrapper of **systemd-run**; it creates a SystemD scope, assigns that scope to the specified slice, and then executes the specified command within the scope. The scope (and thus the command) attachs to the current TTY and inherits all environment variables, as if that command was executed without the wrapper.

If **ssrun** is executed as a user with UID 0 (usually the root user), **systemd-run** is executed in system mode. Otherwise it is executed in user mode.

**Note: the PID of this command invocation is currently not the same as the PID of the command executed within the scope.**

# OPTIONS

**ssrun** relies on a single positional argument for which slice the command should be assigned to. All other arguments are passed to **systemd-run**; which arguments are interpreted as **systemd-run** options, the command, or the command's arguments are determined by that command. See the relevant documentation for details.

(Symbolic links) of **ssrun_sym** internally call **ssrun** with the base of their name automatically provided as the first positional argument. All other arguments are appended to that call. Thus, these "commands" pass all specified arguments to **systemd-run**, and the desired slice is specified by using the respective symlink.

**ssrun** automatically appends **\-\-system** to the **systemd-run** options if the effective UID of the invoking user is 0 (usually the root user). Otherwise it appends the **\-\-user** option. This behavior can be overridden by additionally supplying one of these options before the desired command.

When run in user mode...

# FILES

/etc/foo.conf
:   The system-wide configuration file to control the behaviour of
    ssrun. See **foo.conf**(5) for further details.

${HOME}/.foo.conf
:   The per-user configuration file to control the behaviour of
    ssrun. See **foo.conf**(5) for further details.

# ENVIRONMENT

**FOO_CONF**
:   If used, the defined file is used as configuration file (see also
    the section called “FILES”).

# DIAGNOSTICS

The following diagnostics may be issued on stderr:

Bad configuration file. Exiting.
:   The configuration file seems to contain a broken configuration
    line. Use the **\-\-verbose** option, to get more info.

**ssrun** provides some return codes, that can be used in scripts:

    Code Diagnostic
    0 Program exited successfully.
    1 The configuration file seems to be broken.

# BUGS

The program is currently limited to only work with the foobar library.

The upstream BTS can be found at http://bugzilla.foo.tld.

# SEE ALSO

**simple-slices**(7), **systemd-run**(1), **systemd.scope**(1)
