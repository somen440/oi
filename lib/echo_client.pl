use strict;
use warnings FATAL => 'all';
use Carp;
use Encode;
use IO::Socket;

my $socket = IO::Socket::INET->new(
  PeerAddr => 'localhost',
  PeerPort => 2525,
  Proto    => 'tcp',
);

Carp::croak "Could not create socket: $!" unless $socket;

my $encoder = Encode::find_encoding('utf8');
while(1) {
    print '> ';
    my $msg = <STDIN>;
    $msg = $encoder->decode($msg);
    $msg =~ s/\x0D?\x0A?$//;
    $msg = $encoder->encode($msg);
    print $socket "$msg\n";

    $msg = <$socket>;
    $msg = $encoder->decode($msg);
    print $encoder->encode($msg);
}
$socket->close;
