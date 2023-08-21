#!/bin/ksh 
#
# Filename: netcal.ksh
# Location: /home/mbrennan/scripts
# Description: script to netmask/default gateway math
#
#  3.09.2007 mmb written
#  2.23.2007 mmb rewritten to accept variables from the command prompt
#

#
# Variables
#

ipaddress=$1
netmask=$2
type=$3
breaks=1

#
# Functions
#

function getBreaks {

#
# Locate network breaks based on subnetting, and print
# gateway and broadcast addresses
#

	((netsize= 256 - $NM4bd10))
	((hostseg=$netsize - 2))

	network=$(print $ipaddress | awk -F"." '{printf "%s.%s.%s.",$1,$2,$3}')
	print "Gateway Broadcast"| awk '{printf "%-15s  %-15s\n",$1,$2}'

	while [[ $breaks -lt 256 ]]
		do

		DG=$network$breaks
		((breaks=$breaks + $hostseg ))
		BC=$network$breaks
		((breaks=$breaks + 2 ))
	 	print "$DG $BC"| awk '{printf "%-15s  %-15s\n",$1,$2}'
		
	done
	
	((breaks=1))
}

function networkType {

#
# Ugly, ugly way to determing what type of network is being investigated
# but hey, it works!
#

	((NM4bd2=$(echo $(typeset -i2 NM4;print $NM4)|sed 's/0//g'|sed 's/2#//g'|wc -m)+23))
	print "\nNetwork type /$NM4bd2\n"
}

function print35 {

#
# Print 35 underscores to breakup output (probably no longer needed
# as the program stands now).
#

	print "___________________________________"
}

function nicDisplay {

#
# Print information on the current NIC in a pretty format
#

	print "IP-Address Netmask"| awk '{printf "%-15s  %-15s\n",$1,$2}'
	print "$ipaddress $NMb10"| awk '{printf "%-15s  %-15s\n",$1,$2}'

}

function nmBase10 {

#
# Modify the inputed netmask so that it can be used by other fuctions
#

	NMb10=$netmask
	NM1bd10=$(echo $netmask|awk -F"." '{print $1}')
	NM2bd10=$(echo $netmask|awk -F"." '{print $2}')
	NM3bd10=$(echo $netmask|awk -F"." '{print $3}')
	NM4bd10=$(echo $netmask|awk -F"." '{print $4}')
		
	NM1=$(typeset -i16 NM1bd10;print $NM1bd10)
	NM2=$(typeset -i16 NM2bd10;print $NM2bd10)
	NM3=$(typeset -i16 NM3bd10;print $NM3bd10)
	NM4=$(typeset -i16 NM4bd10;print $NM4bd10)
}

function nmBase16 {

#
# Modify the inputed netmask so that it can be used by other fuctions
#

	typeset -i NM1=16#$(echo $netmask|cut -b1-2)
	typeset -i NM2=16#$(echo $netmask|cut -b3-4)
	typeset -i NM3=16#$(echo $netmask|cut -b5-6)
	typeset -i NM4=16#$(echo $netmask|cut -b7-8)

	NM1bd10=$(typeset -i10 NM1;print $NM1)
	NM2bd10=$(typeset -i10 NM2;print $NM2)
	NM3bd10=$(typeset -i10 NM3;print $NM3)
	NM4bd10=$(typeset -i10 NM4;print $NM4)
	
	NMb10=$(print "$NM1bd10.$NM2bd10.$NM3bd10.$NM4bd10")
}

#
# Script body
#

case $type in

	-t | t ) 

		nmBase10
		print35
		nicDisplay
		networkType 
		getBreaks
		print35;;

	-h | h )

		nmBase16
		print35
		nicDisplay
		networkType 
		getBreaks
		print35;;

	*)
		print "\nUSAGE: $0 IP-Address Netmask Netmask-format"
		print "\nExamples"
		print "\t$0 10.1.1.2 255.255.255.192 -t\n"
		print "\t$0 10.1.1.2 ffffffc0 -h\n\n";;
esac
