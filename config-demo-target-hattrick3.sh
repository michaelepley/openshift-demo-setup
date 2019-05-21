#!/usr/bin/env bash

. config-resources-available-all.sh || { echo "FAILED: Could not load available resource index" && exit 1; }

[[ -v CONFIGURATION_DEMO_TARGET_HATTRICK3_COMPLETED ]] && echo "Using demo target HATTRICK3 configuration" && { return || exit ; }
: ${CONFIGURATION_DEMO_TARGET_HATTRICK3_DISPLAY:=$CONFIGURATION_DISPLAY}

# https://osp-master-8d43.int.HATTRICK3.lab/console/

# variables marked as "PRIMARY", "SECONDARY", etc denote available alternatives 
OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY=int.hattrick3.lab
OPENSHIFT_DOMAIN_PRIMARY=${OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY}
OPENSHIFT_DOMAIN_HATTRICK3=${OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY}
OPENSHIFT_MASTER_HATTRICK3_PRIMARY=osp-master-8d43.${OPENSHIFT_DOMAIN_HATTRICK3}
OPENSHIFT_MASTER_HATTRICK3_PRIMARY=ocp.${OPENSHIFT_DOMAIN_HATTRICK3}
OPENSHIFT_MASTER_HATTRICK3_PRIMARY_PORT_HTTPS=443
OPENSHIFT_APPS_HATTRICK3_PRIMARY=int.${OPENSHIFT_DOMAIN_HATTRICK3}
OPENSHIFT_LOGGING_HATTRICK3_PRIMARY=logging.${OPENSHIFT_DOMAIN_HATTRICK3}/apps/kibana
OPENSHIFT_PROXY_AUTH_HATTRICK3_PRIMARY=proxy.${OPENSHIFT_DOMAIN_HATTRICK3}
OPENSHIFT_AUTH_METHOD_HATTRICK3_PRIMARY=token

OPENSHIFT_APPLICATION_NAME_MYPHP=myphp

OPENSHIFT_PRIMARY_CREDENTIALS_CLI_DEFAULT=

# get encryption/decryption key if one is not provided automatically
[[ -v SCRIPT_ENCRYPTION_KEY ]] || { read -t 10 -s -p "======> ENTER ENCRYPTION/DECRYPTION KEY:" SCRIPT_ENCRYPTION_KEY && echo "" ; }
# assume a default key if the user did not supply one in time
: ${SCRIPT_ENCRYPTION_KEY:=$OPENSHIFT_USER_PRIMARY_PASSWORD}

! [[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && ! [[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && { echo -n "Enter password for ${OPENSHIFT_MASTER_HATTRICK3_PRIMARY} : " && read -s OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT ; }
[[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT ]] || { echo "FAILED: OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT must be set and match a valid password for the openshift cluster ${OPENSHIFT_MASTER_HATTRICK3_PRIMARY}" && exit 1 ; }
[[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && ! [[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "--> it is recommended to use an encrypted password; you may save the encrypted value OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT=${OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT} or you may encrypt and store the token using the following: " && echo ' OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT=`echo ${OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT} | openssl enc -e -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}`'
[[ -v OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "	--> Decrypting the script key" && { OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT=`echo "${OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_CIPHERTEXT}" | openssl enc -d -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}` || { echo "FAILED: Could not validate the password" && exit 1; } ; }


# each user entry is an array of (username, password, auth-method default project, and any other projects)
OPENSHIFT_USER_HATTRICK3_ADMIN=(admin "${OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT}" token admin-default)
OPENSHIFT_USER_HATTRICK3_DEVELOPER=(developer "${OPENSHIFT_HATTRICK3_USER_PASSWORD_DEFAULT_PLAINTEXT}" token developer-default)
# array of all users for this demo target
OPENSHIFT_USERS_HATTRICK3=(OPENSHIFT_USER_HATTRICK3_ADMIN OPENSHIFT_USER_HATTRICK3_DEVELOPER)

if [ "$CONFIGURATION_DEMO_TARGET_HATTRICK3_DISPLAY" != "false" ]; then
	echo "Demo Target HATTRICK3 Configuration__________________________"
	echo "	OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY           = ${OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_PRIMARY                    = ${OPENSHIFT_DOMAIN_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_HATTRICK3                   = ${OPENSHIFT_DOMAIN_HATTRICK3}"
	echo "	OPENSHIFT_MASTER_HATTRICK3_PRIMARY           = ${OPENSHIFT_MASTER_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_MASTER_HATTRICK3_PRIMARY_PORT_HTTPS= ${OPENSHIFT_MASTER_HATTRICK3_PRIMARY_PORT_HTTPS}"
	echo "	OPENSHIFT_APPS_HATTRICK3_PRIMARY             = ${OPENSHIFT_APPS_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_LOGGING_HATTRICK3_PRIMARY          = ${OPENSHIFT_LOGGING_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_PROXY_AUTH_HATTRICK3_PRIMARY       = ${OPENSHIFT_PROXY_AUTH_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_AUTH_METHOD_HATTRICK3_PRIMARY      = ${OPENSHIFT_AUTH_METHOD_HATTRICK3_PRIMARY}"
	echo "	OPENSHIFT_USERS_HATTRICK3 = {"
	for OPENSHIFT_USER_HATTRICK3 in ${!OPENSHIFT_USERS_HATTRICK3[@]}; do
		echo -n "		${OPENSHIFT_USERS_HATTRICK3[$OPENSHIFT_USER_HATTRICK3]} : "
		OPENSHIFT_USER_HATTRICK3_USERNAME_REF=${OPENSHIFT_USERS_HATTRICK3[$OPENSHIFT_USER_HATTRICK3]}[0] && echo -n "( username = ${!OPENSHIFT_USER_HATTRICK3_USERNAME_REF} , "
		OPENSHIFT_USER_HATTRICK3_PASSWORD_REF=${OPENSHIFT_USERS_HATTRICK3[$OPENSHIFT_USER_HATTRICK3]}[1] && echo -n "password (obfuscated) = ` echo ${!OPENSHIFT_USER_HATTRICK3_PASSWORD_REF} | md5sum`, "
		OPENSHIFT_USER_HATTRICK3_AUTHMETHOD_REF=${OPENSHIFT_USERS_HATTRICK3[$OPENSHIFT_USER_HATTRICK3]}[2] && echo -n "auth-method = ${!OPENSHIFT_USER_HATTRICK3_AUTHMETHOD_REF} , "
		OPENSHIFT_USER_HATTRICK3_PROJECT_REF=${OPENSHIFT_USERS_HATTRICK3[$OPENSHIFT_USER_HATTRICK3]}[3] && echo -n "project = ${!OPENSHIFT_USER_HATTRICK3_PROJECT_REF} )"
		echo ""
	done
	echo "	}"
	echo "____________________________________________________________"
	echo "	--> FYI: ssh access to rhsademo available vi jump.rhsademo.net" && echo "	--> Use: ssh -vvv -i ~/.ssh/id_rsa_openshift mepley@jump.rhsademo.net"
fi

# overwrite  generic configuration with RHSAMEMO specific configuration
OPENSHIFT_DOMAIN_DEFAULT=${OPENSHIFT_DOMAIN_HATTRICK3_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT=${OPENSHIFT_MASTER_HATTRICK3_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT_PORT_HTTPS=${OPENSHIFT_MASTER_HATTRICK3_PRIMARY_PORT_HTTPS}
OPENSHIFT_APPS_PRIMARY_DEFAULT=${OPENSHIFT_APPS_HATTRICK3_PRIMARY}
OPENSHIFT_LOGGING_PRIMARY_DEFAULT=${OPENSHIFT_LOGGING_HATTRICK3_PRIMARY}
OPENSHIFT_PROXY_AUTH_PRIMARY_DEFAULT=${OPENSHIFT_PROXY_AUTH_HATTRICK3_PRIMARY}
OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT="OPENSHIFT_USER_HATTRICK3_ADMIN"
OPENSHIFT_USER_PRIMARY_DEFAULT=${OPENSHIFT_USER_HATTRICK3_ADMIN[0]}
OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT=${OPENSHIFT_USER_HATTRICK3_ADMIN[1]}
OPENSHIFT_AUTH_METHOD_PRIMARY_DEFAULT=${OPENSHIFT_USER_HATTRICK3_ADMIN[2]}
OPENSHIFT_PROJECT_PRIMARY_DEFAULT=${OPENSHIFT_USER_HATTRICK3_ADMIN[3]}
: ${OPENSHIFT_APPLICATION_NAME_DEFAULT:=default-app}
: ${OPENSHIFT_OUTPUT_FORMAT_DEFAULT:=json}

CONFIGURATION_DEMO_TARGET_HATTRICK3_COMPLETED=true