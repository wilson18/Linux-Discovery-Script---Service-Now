#!/bin/bash

clear 
echo "Starting Descovery Script as $USER"
echo "===================================="
function getIP(){
	local  ip=$(hostname -i)
	size=${#ip}
	if [  -z $ip ] || [ $size > 15 ]
	then
		ip=$(ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1' |head -1)
	fi
	echo "$ip"
}
function getHostname(){
        local hostname=$(hostname -s)
        echo "$hostname"
}
function getRAM(){
	local ramKB=$(less /proc/meminfo | grep "MemTotal" | grep -o '[0-9]*')
	let ram=$ramKB/1024
	echo "$ram"
}
function getKernel(){
	local kernel=$(uname -r)
	echo "$kernel"
}
function getMacAddress(){
	if [ -e /sys/class/net/eth?/address ]
        then
                local mac=$(cat /sys/class/net/eth?/address)
	else
		 local mac=$( ifconfig | grep "ether" |head -1 | grep -o '[0-9:a-z]*' |head -2| tail -1)
	fi
	echo "$mac"
}
function getDiskSpace(){
	local disk=$( df -BG -l --total | grep "total" | grep -o '[0-9]*' | head -1)
	echo "$disk"
}
function getDiskUsed(){
	local disk=$( df -BG -l --total | grep "total" | grep -o '[0-9]*' | tail -n -3 |head -1)
	echo "$disk"
}
function getOS(){
	local os=$(cat /etc/*-release | grep "release" |head -1)
	if [ -z "$os" ]
	then
		os=$(lsb_release -d -s)
	fi

	echo "$os"
}
function getVarUsedPercent(){
	local used=$(df -BG -l --total | grep "var" | grep -o '[0-9]*' | tail -n -1)
	echo "$used"
}
function getUsrUsedPercent(){
        local used=$(df -BG -l --total | grep "usr" | grep -o '[0-9]*' | tail -n -1)
        echo "$used"
}
function getTmpUsedPercent(){
        local used=$(df -BG -l --total | grep "tmp" | grep -o '[0-9]*' | tail -n -1)
        echo "$used"
}
function getCPUCoreCount(){
	local cores=$( lscpu | grep "CPU(s)" | grep -o '[0-9]*' | head -1)
	echo "$cores"
}
function getCoreSpeed(){
	local speed=$( lscpu | grep "CPU MHz" | grep -o '[0-9.]*' | head -1)
	echo "$speed"
}
function checkServerType(){
        local type='Computer';
        if [ -e /etc/nginx ] || [ -e /etc/apache2 ]
        then
                type=WebServer
        elif  ps cax | grep "mysql"
        then
                $type = "Database"
	fi
        echo "$type"
}
function getDomain(){
	local domain=$(hostname)
	echo "$domain"
}
function getCPUCount(){
	local cpus=$(lscpu | grep "Socket(s)" | grep -o '[0-9]*' | head -1)
	echo "$cpus"
}
function getCPUType(){
	local type=$(lscpu | grep "Model name" |cut -c 12- |sed "s/^[ \t]*//")
	echo "$type"
}
function getCPUManu(){
	local manu=$(lscpu | grep "Vendor ID:" | grep -o '[0-9a-zA-Z]*' |tail -1);
	echo "$manu"
}
serverType=$(checkServerType)
cores=$(getCPUCoreCount)
cpus=$(getCPUCount)
cputype=$(getCPUType)
cpuManu=$(getCPUManu)
ip=$(getIP)
hostname=$(getHostname)
domain=$(getDomain)
ram=$(getRAM)
kernel=$(getKernel)
mac=$(getMacAddress)
disk=$(getDiskSpace)
os=$(getOS)
diskUsed=$(getDiskUsed)
varUsed=$(getVarUsedPercent)
tmpUsed=$(getTmpUsedPercent)
usrUsed=$(getUsrUsedPercent)
speed=$(getCoreSpeed)
echo "            General"
echo "===================================="
echo "Name: 		$hostname"
echo "Domain:         $domain"
echo "OS: 		$os"
echo "Kernel:		$kernel"
echo "IP:   		$ip"
echo "Mac Address:	$mac"
echo "RAM:		$ram MB"
echo "          HDD Infomation"
echo "===================================="
echo "DiskSpace 		$disk GB"
echo "DiskUsed 		$diskUsed GB"
echo "/var usage		$varUsed %"
echo "/usr usage 		$usrUsed %"
echo "/tmp usage 		$tmpUsed %"
echo "            CPU Information"
echo "===================================="
echo "Number of CPUs           $cpus"
echo "Number of Cores		 $cores"
echo "CPU Name                $cputype"
echo "CPU Speed		 $speed Mhz"
echo "CPU Manufacturor         $cpuManu"
echo "		Other"
echo "===================================="
echo "Server Type: 	$serverType" 

