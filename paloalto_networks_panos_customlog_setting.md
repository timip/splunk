# Palo Alto Networks Firewall Customized Syslog Filter for Splunk
Customized Syslog filter for Splunk

Configuration Location: `Device>Server Profiles>Syslog>[Syslog Profile Name]>Custom Log Format`

## Traffic Log
- Remove redundant timestamps and fields in syslog message
- Optimze search speed, Splunk license usage and network bandwidth
```
,$receive_time,,$type,$subtype,,,$src,$dst,$natsrc,$natdst,$rule,$srcuser,$dstuser,$app,,$from,$to,$inbound_if,$outbound_if,,,,,$sport,$dport,$natsport,$natdport,,$proto,$action,$bytes,$bytes_sent,$bytes_received,$packets,,,$category,,,,,,,$pkts_sent,$pkts_received,$session_end_reason
```

## Config Log
- Provide full audit information for configuration change
```
,$receive_time,$serial,$type,$subtype,,$time_generated,$host,$vsys,$cmd,$admin,$client,$result,$path,$seqno,$actionflags,$before-change-detail,$after-change-detail,$dg_hier_level_1,$dg_hier_level_2,$dg_hier_level_3,$dg_hier_level_4,$vsys_name,$device_name
```

## Threat Log
```
,$time_received,,$type,$subtype,,,$src,$dst,$natsrc,$natdst,$rule,$srcuser,$dstuser,$app,,$from,$to,$inbound_if,$outbound_if,,,$sessionid,,$sport,$dport,$natsport,$natdport,$flags,$proto,$action,$misc,$threatid,$category,$severity,$direction,,,,,,$contenttype,,$filedigest,$cloud,$url_idx,,$filetype,$xff,$referer,$sender,$subject,$recipient,$reportid,,,,,,,$file_url
```
