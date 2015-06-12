#!/bin/bash

clear 
echo "Starting Descovery Script as $USER"
echo "===================================="
function getIP()
{
    local  ip=$(hostname -i)
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
	local mac=$(cat /sys/class/net/eth?/address)
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
serverType=$(checkServerType)
cores=$(getCPUCoreCount)
ip=$(getIP)
hostname=$(getHostname)
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
echo "Number of Cores		$cores"
echo "CPU Speed		$speed Mhz"
echo "		Other"
echo "===================================="
echo "Server Type: 	$serverType" 

