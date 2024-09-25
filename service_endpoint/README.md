# DB connection

+ db and vm must be the same subnet to use service endpoint
  + vm1 : OK
  + vm2 : NG

```sh
$ nslookup example23982380.database.windows.net
Server:127.0.0.53
Address:127.0.0.53#53

Non-authoritative answer:
example23982380.database.windows.netcanonical name = dataslice7.japaneast.database.windows.net.
dataslice7.japaneast.database.windows.netcanonical name = dataslice7japaneast.trafficmanager.net.
dataslice7japaneast.trafficmanager.netcanonical name = cr15.japaneast1-a.control.database.windows.net.
Name:cr15.japaneast1-a.control.database.windows.net
Address: 20.191.165.161

```