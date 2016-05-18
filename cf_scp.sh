#!/bin/bash

echo "check commands ------"
set -e
which jq
which sshpass
echo ""
set +e

app_name=$1
instance_index=$2
scp_src=$3
scp_dst=$4

api_host=`cf target | grep API | awk '{print $3}'`
ssh_host=`curl -s ${api_host}/v2/info | jq .app_ssh_endpoint | awk -F : '{print $1}' | sed 's/\"//g'`
app_id=`cf env ${app_name} | grep application_id | awk '{print $2}' | sed 's/\"//g' | sed 's/,//g'`
ssh_code=`cf ssh-code`

echo "settings ------"
echo "api_host : ${api_host}"
echo "ssh_host : ${ssh_host}"
echo "app_name : ${app_name}"
echo "app_id : ${app_id}"
echo "ssh_code : ${ssh_code}"
echo ""

echo "start scp ------"
sshpass -p "${ssh_code}" scp -v -P 2222 -o StrictHostKeyChecking=no -o User=cf:${app_id}/${instance_index} ${ssh_host}:${scp_src} ${scp_dst}
