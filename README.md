# simple-slices
A small set of SystemD slices with various priorities

**Note: This project is not ready for production yet!**

SystemD includes a feature called "slices", which combines services into groups that are preferentially given access to computing resources based on their assigned priority (similar to "nice" and "ionice"); if the system isn't resource-constrained, these priorities have no effect. Despite their usefulness, few people seem use them—likely due to their complexity.

This package contains 6 pre-made slices (in addition to the 2 default slices included with SystemD) with hand-picked priority values that seem to work well for most applications. Each slice defines a priority for CPU utilization, IO utilization, and memory usage; future versions may also support priority for network utilization and core scheduling on hybrid CPUs. This allows the user to quickly and easily choose which commands and services should be given priority when the system is under load. See the manual for details, but know that it's quite easy.

For example, a desktop user may want to give higher priority to their desktop environment and user-facing applications, and lower priority to the background updates of mail clients, file syncing clients, and software update checking. A server administrator may want to give higher priority to SSH servers and firewalls, and lower priority to offsite replication.
