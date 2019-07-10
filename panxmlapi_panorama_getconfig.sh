#!/bin/bash

APP_HOME="/opt/splunk/etc/apps/TA_TIMLAB_PANXMLAPI"

path_panxapi="/usr/local/bin/panxapi.py"
path_python="/usr/bin/python"
path_jq=$APP_HOME/bin/scripts/jq-linux64
path_out=$APP_HOME/bin/scripts/working

panname="<Fill in PAN Panorama Name>"
panaddr="<Fill in PAN Panorama IP>"
pankey="<Fill in API Key>"

fwname_api="<Fill in PAN Firewall Name>"
fwname="<Fill in PAN Firewall Display Name you want in Splunk>"

echo "`date +'%Y%m%d %H:%M:%S'`: Getting rules from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/pre-rulebase/security/rules" > $path_out/tmp_rules.json
cat $path_out/tmp_rules.json | $path_jq '.rules.entry[] | {panname:"'$fwname'", name:.name, desc:.description, ser:.service.member, app:.application.member, src:.source.member, dest:.destination.member, from:.from.member, to:.to.member, disable:.disabled, src_user:."source-user".member, action:.action, log_end:."log-end", tag:.tag.member, log_setting:."log-setting", neg_src:."negate-source", neg_dest:."negate-destination", profile_setting:."profile-setting".group.member}' > "$path_out/input_rules.$fwname.`date +"%Y%m%d"`.json"

echo "`date +'%Y%m%d %H:%M:%S'`: Getting addresses from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/address" > $path_out/tmp_address.json
cat $path_out/tmp_address.json | $path_jq '.address.entry[] | {panname:"'$fwname'", name:.name, ip_netmask:."ip-netmask", fqdn:.fqdn, ip_range:."ip-range", desc:.description}' > $path_out/input_address.$fwname.`date +"%Y%m%d"`.json

echo "`date +'%Y%m%d %H:%M:%S'`: Getting address-groups from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/address-group" > $path_out/tmp_address-group.json
cat $path_out/tmp_address-group.json | $path_jq '."address-group".entry[] | {panname:"'$fwname'", name:.name, member:.static.member, desc:.description}' > $path_out/input_address-group.$fwname.`date +"%Y%m%d"`.json

echo "`date +'%Y%m%d %H:%M:%S'`: Getting services from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/service" > $path_out/tmp_service.json
cat $path_out/tmp_service.json | $path_jq '.service.entry[] | {panname:"'$fwname'", name:.name, protocol:.protocol}' > $path_out/input_service.$fwname.`date +"%Y%m%d"`.json

echo "`date +'%Y%m%d %H:%M:%S'`: Getting service-groups from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/service-group" > $path_out/tmp_service-group.json
cat $path_out/tmp_service-group.json | $path_jq '."service-group".entry[] | {panname:"'$fwname'", name:.name, member:.members.member}' > $path_out/input_service-group.$fwname.`date +"%Y%m%d"`.json

echo "`date +'%Y%m%d %H:%M:%S'`: Getting application-groups from firewall $fwname"
$path_panxapi -h $panaddr -K $pankey -jr -s "/config/devices/entry[@name=\"localhost.localdomain\"]/device-group/entry[@name=\"$fwname_api\"]/application-group" > $path_out/tmp_application-group.json
cat $path_out/tmp_application-group.json | $path_jq '."application-group".entry[] | {panname:"'$fwname'", name:.name, member:.members.member}' > $path_out/input_application-group.$fwname.`date +"%Y%m%d"`.json

rm -f $path_out/tmp_*.json
