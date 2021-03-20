use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use IO::Socket;

my $server_socket = IO::Socket::INET->new(
  LocalPort => 2525,
  Proto     => 'tcp',
  Listen    => 1,
  ReuseAddr => 1,
);

Carp::croak "Could not create socket: $!" unless $server_socket;
my $encoder = Encode::find_encoding('utf8');

my $welcome_msg = <<'EOS';
welcome oi
EOS


while(1) {
    my $client_socket = $server_socket->accept;
    print $client_socket "$welcome_msg\n";

    while(my $msg = <$client_socket>) {
        $msg = $encoder->decode($msg);
        $msg =~ s/\x0D?\x0A?$//;
        if ($msg =~ m/(quit|q|exit)/i) {
            print "Connection closed.\n";
            last;
        }
        my $encoded = $encoder->encode($msg);
        print "Client>> $encoded\n";
        print $client_socket "Server>> $encoded\n";
    }
    $client_socket->close;
}

$server_socket->close;
