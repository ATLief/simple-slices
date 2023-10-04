% simple-slices(7) | Miscellaneous
%
% "October 2 2023"

# NAME

simple-slices - small collection of SystemD slices with various priorities

# SYNOPSIS

**ignore-me** [{**-h** | *\-\-help**} | {**-v** | **\-\-version**}]

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
