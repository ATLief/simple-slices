#
# Regular cron jobs for the simple-slices package.
#
0 4	* * *	root	[ -x /usr/bin/simple-slices_maintenance ] && /usr/bin/simple-slices_maintenance
