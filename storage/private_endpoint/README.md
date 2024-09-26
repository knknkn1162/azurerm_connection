# DB connection

+ 

```sh
~$ nslookup 5j7cztd73gqn.privatelink.blob.core.windows.net
Server:127.0.0.53
Address:127.0.0.53#53

Non-authoritative answer:
Name:5j7cztd73gqn.privatelink.blob.core.windows.net
Address: 10.0.2.5

adminuser@vm-9bea8f8d-0a92-9a08-ff71-aa883ccd3c45:~$ nslookup 5j7cztd73gqn.blob.core.windows.net
Server:127.0.0.53
Address:127.0.0.53#53

Non-authoritative answer:
5j7cztd73gqn.blob.core.windows.netcanonical name = 5j7cztd73gqn.privatelink.blob.core.windows.net.
Name:5j7cztd73gqn.privatelink.blob.core.windows.net
Address: 10.0.2.5
```