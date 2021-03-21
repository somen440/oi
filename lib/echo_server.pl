use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use IO::Socket;

my $port = 2525;
my $server_socket = IO::Socket::INET->new(
  LocalPort => $port,
  Proto     => 'tcp',
  Listen    => 10,
  Broadcast => 1,
);

Carp::croak "Could not create socket: $!" unless $server_socket;
print "Listening on $port...\n";

my $encoder = Encode::find_encoding('utf8');

my $welcome_msg = <<'EOS';
おい
EOS

while (1) {
    my $client_socket = $server_socket->accept;
    my $client_addr = gethostbyaddr($client_socket->peeraddr, AF_INET);
    my $client_port = $client_socket->peerport;
    print "接続あり: $client_addr:$client_port\n";

    print $client_socket "$welcome_msg\n";
    if (my $pid = fork()) {
        # 親プロセス
        print "親プロセス($$): 引き続き $port を見張ります。\n";
        print "親プロセス($$): クライアントの相手はプロセス $pid が行います。\n";
        $client_socket->close;
        next;
    } else {
        # 子プロセス
        while(my $msg = <$client_socket>) {
            $msg = $encoder->decode($msg);
            $msg =~ s/\x0D?\x0A?$//;
            if ($msg =~ m/(quit|q|exit)/i) {
                print "Connection closed.\n";
                last;
            }
            my $encoded = $encoder->encode("おい $msg !!");
            print "Client>> $encoded\n";
            print $client_socket "$encoded\n";
        }
        $client_socket->close;
        exit;
    }
}

$server_socket->close;
