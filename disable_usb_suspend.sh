#!/bin/bash

##Need to be run as root

vendor=$1
product=$2

echo "vendor=$vendor, product=$product"
final_list=""
for my_path in /sys/bus/usb/devices/usb*/
do 
    my_files=$(find $my_path -name 'idProduct' -exec grep  -l $product {} \;)
    	
    if [ -z $my_files ] ; then
	continue
    fi	
	
    for my_fi in $my_files
    do
		my_dir=$(dirname $my_fi)
		if [ x`grep $vendor $my_dir/idVendor`=x$vendor ];
		then
			final_list="$final_list $my_dir"
		fi
 
		
    done
	 	
done

for dir in $final_list
do 
	echo "Changing: $dir/power/autosuspend"
	echo -1 > $dir/power/autosuspend
done
