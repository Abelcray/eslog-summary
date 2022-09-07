#!/bin/bash

disk_used='_cat/nodes?v&h=ip,disk.total,disk.used,disk.avail,disk.used_percent'
indexlist='_cat/indices?v&h=index,cd&s=cd'
cmd='curl'
version='_cluster/stats'

if [[ $1 != "getdata" ]] && [[ $1 != '' ]] ;then
     echo "本脚本参数只支持getdata！"
     exit 1
else

# 判断是否有账号密码
function pw(){
  if [[ $pw != "1"  ]];then
    cmd="curl -u$user:$pw"
  fi
}

# 采集es信息
function getdata(){
  mkdir -p $dir
  $cmd $url/$disk_used > $dir/disk.log
  $cmd $url/$indexlist > $dir/index.log
  $cmd $url/$version > $dir/version.log
}

# 打印采集到的es信息
function printserverinfo(){
  cat $dir/disk.log |sed 1d| while read server disk_total disk_used disk_avail disk_percent
    do
       echo 服务器： $server  磁盘容量：$disk_total   磁盘使用量：$disk_used  磁盘剩余空间：$disk_avail 磁盘使用率：$disk_percent
    done
}


# 打印时间保留标准
function timeprint(){
  current_date=`date +%s`
  if [[ -n $days  ]];then
    base_date=`date  -v-${days}d +%s`
  fi
  echo 最早日志留存时间：$time
  echo "`date -Iseconds -r $current_date` 当前时间"
  echo "`date -Iseconds -r $base_date` 基准留存时间"
  
}

#读取配置文件进行处理
cat config | while read env url user pw dir days
do
  echo ""
  echo $env
  pw
  $1
  time=`cat $dir/index.log |awk '{print $1}'| egrep '^[a-z].*2022.[0-9]{2}.[0-9]{2}' |grep java| grep -v staging|awk -F\- '{print $NF}'| sort| uniq| head -n1 `
  printserverinfo
  timeprint
done

fi
