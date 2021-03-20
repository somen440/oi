use strict;
use warnings FATAL => 'all';
use Socket;

my $sock;
socket($sock, PF_INET, SOCK_STREAM, getprotobyname('tcp'))
    or die "Cannot create socket: $!";

my $remote_host = 'localhost';
my $packed_remote_host = inet_aton($remote_host)
    or die "Cannot pack $remote_host: $!";

my $remote_port = 9000;

my $sock_addr = sockaddr_in($remote_port, $packed_remote_host)
    or die "Cannot pack $remote_host:$remote_port: $!";

connect($sock, $sock_addr)
    or die "Cannot connect $remote_host:$remote_port: $!";

my $old_handle = select $sock;
$| = 1;
select $old_handle;

print $sock "Hello";

shutdown $sock, 1;

while (my $line = <$sock>) {
    print $line;
}

close $sock;
