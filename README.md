# puppet-healthcheck

## Types

### tcp_conn_validator

`tcp_conn_validator` is used to verify that a service is listening on a given port.
It could be used to test either a remote or a local service. It support both IPv4 and
IPv6 connection strings. It also works with hostname.

```puppet
tcp_conn_validator { 'foo-machine ssh service' :
  host => '192.168.0.42',
  port   => 22,
}
```

The namevar of this resource can also be the connection string. It comes handy when
one already have an array of ip:port or hostname:port string to test.

```puppet
mongodb_cluster_nodes = ['192.168.0.2:27017', 'node02.foo.bar.com:27017']
tcp_conn_validator { $mongodb_cluster_nodes : }
```

####`host`

IP address or server DNS name on which the service is supposed to be bound to. Required if the namevar is not a connection string.

####`port`

Port on which the service is supposed to listen. Required if the namevar is not a connection string.

####`try_sleep`

The time to sleep in seconds between ‘tries’. Default: 1

####`timeout`

Number of seconds to wait before timing out. Default: 60

### http_conn_validator

`http_conn_validator` is used to verify that an http server is answering on a given port.
It could be used to test either a remote or a local service. It support both IPv4 and
IPv6 connection strings. It also works with hostname.

```puppet
http_conn_validator { 'foo-machine home' :
  home    => '127.0.0.1',
  port    => 80,
  use_ssl => true,
}
```

The namevar of this resource can also be the connection string. It comes handy when
one already have an array of URLs string to test.

```puppet
appli_cluster_nodes = ['https://server1.com/test-url', 'https://server2.com/test-url']
http_conn_validator { $appli_cluster_nodes : }
```

####`host`

IP address or server DNS name on which the service is supposed to be bound to. Required if the namevar is not a connection string.

####`port`

Port on which the service is supposed to listen. Required if the namevar is not a connection string.

####`use_ssl`

Whether the connection will be attempted using https. Default: false

####`test_url`

URL to use for testing if the HTTP server is up. Default: /

####`try_sleep`

The time to sleep in seconds between ‘tries’. Default: 1

####`timeout`

Number of seconds to wait before timing out. Default: 60

####`expected_code`

Expected HTTP result code to consider success. Default: 200

####`verify_peer`

Whether to verify the peer credentials, if possible. Verification will not take place if the CA certificate is missing

