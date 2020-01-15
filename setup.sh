#! /bin/bash

space ()
{
	for i in $(seq 1 1 $1)
	do
		echo -ne " "
	done
}

create_vm ()
{
	echo -ne "\033[0;33m- $1"
	
	space $2

	VBoxManage createvm --name $1 --ostype Debian_64 --register 2>&1 | grep -e "created" &> /dev/null

	if [ $? == 0 ]
	then
		echo -ne "\033[0;32m[OK]\n"
	else
		echo -ne "\033[0;36m[RETRY]"
		VBoxManage unregistervm $1 -delete 2>&1 | grep -e "100%" &> /dev/null
		if [ $? == 0 ]
		then
			echo -ne "\033[0;36m[ACCEPTED]\n"
			create_vm $1 $2
		else
			echo -ne "\033[1;31m[ERROR]\nLeave Prog!\n"
			exit 1
		fi
	fi
}

exec_cmd ()
{
	echo -ne "\033[0;33m- $1"
	
	space $2

	$3 2>&1 | grep -e "error" &> /dev/null

	if [ $? == 0 ]
	then
		echo -ne "\033[1;31m[ERROR]\nLeave Prog!\n"
		exit 1
	else
		echo -ne "\033[0;32m[OK]\n"
	fi
}

km="kubmaster"
kn="kubnode"

echo -ne "\033[1;35m[VIRTUAL MACHINES]\n"
echo -ne "\033[0;33m[Creating virtual machines...]\n"
create_vm ${km} 3
create_vm ${kn} 5
# echo -ne "\033[0;33m[Init bridges...]\n"
# exec_cmd ${km} 3 "VBoxManage modifyvm ${km} --bridgeadapter1 vmnet1"
# exec_cmd ${kn} 5 "VBoxManage modifyvm ${kn} --nic1 bridged"
echo -ne "\033[0;33m[Init memory...]\n"
exec_cmd ${km} 3 "VBoxManage modifyvm ${km} --memory 2048"
exec_cmd ${kn} 5 "VBoxManage modifyvm ${kn} --memory 2048"
echo -ne "\033[0;33m[Init storage...]\n"
# Creat hard disk CHECKER AVEC 0%...10%... CHECKER COMMENT REMOVE UN HD SATA CONTROLER ETC
# VBoxManage createhd --filename /goinfre/rchallie/VMs/${km}/${km}.vdi --size 10000 --format VDI
# VBoxManage storagectl ${km} --name "SATA Controller" --add sata --controller IntelAhci
# VBoxManage storageattach ${km} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium /goinfre/rchallie/VMs/${km}/${km}.vdi