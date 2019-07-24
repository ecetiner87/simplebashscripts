#!/bin/bash
clear
set x
echo "Enter Username of Mysql User:"
read username

while true; do
    echo "Password must contain at least 1 upper case character, 1 lowercase character, 1 digit and 1 special character[!$#%&]"
    read -p "Enter Password: " password
    echo

    FAIL=no

    # Mininum 8 characters
    [[ ${#password} -ge 8 ]] || FAIL=yes

    # Must contain 1 upper case letters
    echo $password | grep -q ".*[A-Z]" || FAIL=yes

    # Must contain 1 lower case letters
    echo $password | grep -q ".*[a-z]" || FAIL=yes

    # Must contain 1 digits
    echo $password | grep -q ".*[0-9]" || FAIL=yes

    # Must contain 1 non-alphanumeric character (no spaces)
    echo $password | grep -q "[^a-zA-Z0-9 ]" || FAIL=yes

    [[ ${FAIL} == "no" ]] && break

    echo "Password invalid"
done

echo "Password $password is valid"

for addr in $(cat sites.txt)
do
        mysql -uroot -pRootPass -h $addr -P 3306 <<MYSQL_SCRIPT
        CREATE USER '$username'@'%' IDENTIFIED BY '$password';
        GRANT ALL PRIVILEGES ON *.* TO '$username'@'%';
        FLUSH PRIVILEGES;
MYSQL_SCRIPT
echo $username created on host $addr MYSQL SITE.
done

printf "\n\n"

echo "MySQL user created for all hosts."
echo "Username:   $username"
echo "Password:   $password"
