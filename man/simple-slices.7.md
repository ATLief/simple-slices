% simple-slices(7) | Miscellaneous
%
% "April 18 2024"

# NAME

simple-slices - priority-based resource division via simple categories

# USAGE

The priority of individual graphical applications can be changed, but this process may be different on different desktop environments. More information about how to do this will be added in the future.

systemd services can be assigned to a category by adding a drop-in file to that service which specifies the Slice directive. Such files should ideally be placed in /etc/systemd/system/NAME.service.d/SLICE.conf for system services and /etc/systemd/user/NAME.service.d/SLICE.conf for user services, where "NAME" is the name of the service and "SLICE" is the desired category.

Individual commands can also be run within a category, most conveniently with the **ssrun**(1) command. It is strongly recommended to execute scripts within categories by creating a systemd service file that executes the script and has the Slice directive, rather than invoking **systemd-run**(1) or **ssrun**(1) within the script; this may become unsupported in the future.

# FILES

/usr/share/simple-slices/snippets/
:   Example drop-in files for each category assignment.

# TECHNICAL INFORMATION

It isn't necessary to read or understand this section in order to use this package. You should read this if you're curious how this package works, or want to make modifications beyond just putting things into categories.

systemd includes a feature called "slices", which combines "services" and "scopes" into groups that are preferentially given access to computing resources based on their assigned priority (similar to "nice" and "ionice"); if the system isn't resource-constrained, these priorities have no effect. Each slice defines a priority for CPU processing, disk bandwidth, RAM storage, and PID assignment. Future versions may also support priorities for network bandwidth and core types for hybrid CPUs.

Note: A restart may be required in order to start using all features. Individual (non-root) users may need to manually enable simple-slices.target.

# SEE ALSO

**ssrun**(1), **systemd.slice**(5), **systemd.resource-control**(5), **systemd-run**(1)
