use strict;
use warnings FATAL => 'all';
use Socket;

my $sock_recive;
socket($sock_recive, PF_INET, SOCK_STREAM, getprotobyname('tcp'))
    or die "Cannot create socket: $!";

my $local_port = 9000;

my $pack_addr = sockaddr_in($local_port, INADDR_ANY);

bind($sock_recive, $pack_addr)
    or die "Cannot bindL: $!";

listen($sock_recive, SOMAXCONN)
    or die "Cannot listen: $!";

my $sock_client;

while(accept( $sock_client, $sock_recive )) {
    my $content;

    while(my $line = <$sock_client>) {
        $content .= $line;
    }

    print $sock_client "echo: '$content'";
    close $sock_client;
}
