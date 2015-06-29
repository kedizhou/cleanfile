#!/bin/bash

source /etc/profile
export PATH=$PATH:/usr/bin/:/sbin/:/usr/sbin/
t=22
function l
{
	pd=$(cd $(dirname $0);pwd)
	echo -e $(date): "\n$*" >> $pd/log.dat
}

function tEst
{
	if [ `echo "$(df -ThP /opt/logbak/ | grep -v '^F' | awk  '{print $(NF-1)}' | sed 's/%//')>${t}" | bc -l` -eq 1 ];then
		return 1
	else
		return 0
	fi
}

function Rm
{
	flist=$(find /opt/logbak/ -type f -mtime $p)
	let p++
	if [ ! -z "$flist" ];then
		Rm
		let p--
		r=$(find /opt/logbak/ -type f -mtime $p)
		l "$r"
		\rm -rf $r
		tEst
		[ $? -eq 0 ] && exit
	else
		let p--
		return 0
	fi
}

p=0
Rm
