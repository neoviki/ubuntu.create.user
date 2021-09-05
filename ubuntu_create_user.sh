#!/bin/bash
#
#       Author  : Viki (a) Vignesh Natarajan 
#       Contact : vikiworks.io
#       Licence : MIT

USERNAME=$1
PASSWORD=$2
CMD=$0
STATUS_E="  [ error   ]"
STATUS_S="  [ success ]"
STATUS_N="  [ notice  ]"

os_support_check(){
    OS_SUPPORTED=0

    #Check Ubuntu 18.04 Support
    cat /etc/lsb-release | grep 18.04 2> /dev/null 1> /dev/null
    if [ $? -eq 0 ]; then
        OS_SUPPORTED=1
    fi

    #Check Ubuntu 16.04 Support
    cat /etc/lsb-release | grep 16.04 2> /dev/null 1> /dev/null
    if [ $? -eq 0 ]; then
        OS_SUPPORTED=1
    fi

    if [ $OS_SUPPORTED -eq 0 ]; then
	echo
	echo "$STATUS_E Utility is not supported in this version of linux"
	echo
	exit 1
    fi

}

check_permission(){
    touch /bin/test.txt 2> /dev/null 1>/dev/null

    if [ $? -ne 0 ]; then
	echo "$STATUS_E permission error, try to run this script wih sudo option";
	echo ""
	echo "    Example: sudo $CMD $USERNAME XXXXXX"
	echo ""
	exit 1;
    fi

    rm /bin/test.txt
}



add_user(){
    adduser --gecos "" --disabled-password $USERNAME 2> /dev/null 1> /dev/null
    if [ $? -ne 0 ]; then
        echo "$STATUS_E user creation -> USERNAME: $USERNAME"
        exit 1
    fi
    echo "$STATUS_S user creation -> USERNAME: $USERNAME"
}

set_password(){
    chpasswd <<<"$USERNAME:$PASSWORD" 2> /dev/null 1> /dev/null
    if [ $? -ne 0 ]; then
        echo "$STATUS_E setting password  -> USERNAME: $USERNAME"
        exit 1
    fi
    echo "$STATUS_S setting password -> USERNAME: $USERNAME"
}

is_user_exist(){
    id -u $USERNAME 2> /dev/null 1> /dev/null
    if [ $? -eq 0 ]; then
        echo "$STATUS_N user name already exist -> USERNAME: $USERNAME"
        set_password
        exit 0
    fi

}

usage(){
    echo
    echo "  Usage: "
    echo " "
    echo "    $CMD 'username' 'password'"
    echo " "
}

usage_check(){
    if [ -z $USERNAME ]; then
	usage
        exit 1
    fi

    if [ -z $PASSWORD ]; then
	usage
        exit 1
    fi
}

usage_check
os_support_check
check_permission
is_user_exist
add_user
set_password


