#!/bin/bash
SECONDS=0
clear
set x
choice=0
echo "REDIS Configuration"
echo "--------------------------"
PS3='Please enter your choice: '
options=("Create new Master" "Create new Slave"  "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create new Master")
            echo "New Master Redis will be configured..."
	    choice=1;
	    break
            ;;
        "Create new Slave")
            echo "New Slave Redis will be configured..."
	    choice=0
	    break
            ;;
        "Quit")
            exit 0 
            ;;
        *) echo "Invalid Choice.$REPLY";;
    esac
done

echo $choice


if [ "$choice" -eq 1 ];then
	filename="masterredis"
else
	filename="slaveredis"
	echo "Enter Master Redis IP:"
	read masterIP
	sudo sed -i 's/IP/'$masterIP'/g' /etc/ansible/templates/slaveredis.conf.j2
fi

echo "Enter Redis Name:"
read rname
echo "Enter port for new redis:"
read port

cd /etc/ansible
echo "Creation of new Redis"
ansible-playbook  createredis.yml  --extra-vars "redisname=$rname redisport=$port filename=$filename"

if [ "$filename" == "slaveredis" ];then
	sed -i 's/'$masterIP'/IP/g' /etc/ansible/templates/slaveredis.conf.j2
	echo "Slave redis configuration completed"
else
	echo "Master redis configuration completed"
fi

end_time=`date +%s`
echo SCRIPT EXECUTION COMPLETED: "Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
