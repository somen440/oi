# OI

server

```shell
❯ perl lib/echo_server.pl
Listening on 2525...
Wide character in print at lib/echo_server.pl line 29.
接続あり: localhost:50646
Wide character in print at lib/echo_server.pl line 31.
Wide character in print at lib/echo_server.pl line 34.
親プロセス(87678): 引き続き 2525 を見張ります。
Wide character in print at lib/echo_server.pl line 35.
親プロセス(87678): クライアントの相手はプロセス 87694 が行います。
Client>> おい a !!
```

client (telnet)

```shell
❯ telnet localhost 2525
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
おい

a
おい a !!
```

client

```shell
❯ perl lib/echo_client.pl
> a
おい
> a

>
おい a !!
```