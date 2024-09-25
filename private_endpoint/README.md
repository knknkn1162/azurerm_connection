# DB connection

+ public_network_access_enabled=true
  + firewall error
  + endpoint_private_ip: connect error
+ public_network_access_enabled=false
  + no private_dns_zone_group settings
    + nic's private IP -> connection error
    + ${db_prefixf}.privatelink.database.windows.net is public IP
  + private_dns_zone_group settings
    + ${db_prefix}.privatelink.database.windows.net is private IP
    + `sqlcmd -S example2398sdf.privatelink.database.windows.net,1433 -U adminuser -P PwjP5MZYPwjP5MZY -d mydb -C` OK!

```
~$ nslookup example2398sdf.privatelink.database.windows.net
Server:127.0.0.53
Address:127.0.0.53#53

Non-authoritative answer:
Name:example2398sdf.privatelink.database.windows.net
Address: 10.0.2.4
```