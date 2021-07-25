# Windows steps Commands for volatility tool

# Steps to get the users passwords hash
```
# Get info about the memory dump
volatility -f <dump_file> imageinfo
```

[ADD_IMAGE]

```
# Use the info returned on line Suggested Profile(s) as a parameter and get the hivelist like the example below
volatility -f <dump_file> --profile=Win7SP1x64 hivelist
```

[ADD_IMAGE]

```
# Use the memory Virtual addressesof SYSTEM and SAM returned from hivelist command above with hashdump to get the user/password hashes like the example below
volatility -f <dump_file> --profile=Win7SP1x64 hashdump -y 0xfecc0 -s 0xeec00
```
[ADD_IMAGE]



 
