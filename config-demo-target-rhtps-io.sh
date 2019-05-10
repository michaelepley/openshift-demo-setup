#!/usr/bin/env bash
# target is available at https://ocp.rhtps.io

. config-resources-available-all.sh || { echo "FAILED: Could not load available resource index" && exit 1; }

[[ -v CONFIGURATION_DEMO_TARGET_RHTPSIO_COMPLETED ]] && echo "Using demo target RHTPSIO configuration" && { return || exit ; }
: ${CONFIGURATION_DEMO_TARGET_RHTPSIO_DISPLAY:=$CONFIGURATION_DISPLAY}

# variables marked as "PRIMARY", "SECONDARY", etc denote available alternatives 
OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY=rhtps.io
OPENSHIFT_DOMAIN_PRIMARY=${OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY}
OPENSHIFT_DOMAIN_RHTPSIO=${OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY}
OPENSHIFT_MASTER_RHTPSIO_PRIMARY=ocp.${OPENSHIFT_DOMAIN_RHTPSIO}
OPENSHIFT_MASTER_RHTPSIO_PRIMARY_PORT_HTTPS=443
OPENSHIFT_APPS_RHTPSIO_PRIMARY=apps.${OPENSHIFT_DOMAIN_RHTPSIO}
OPENSHIFT_LOGGING_RHTPSIO_PRIMARY=kibana.${OPENSHIFT_APPS_RHTPSIO_PRIMARY}
OPENSHIFT_PROXY_AUTH_RHTPSIO_PRIMARY=${OPENSHIFT_MASTER_RHTPSIO_PRIMARY}
OPENSHIFT_CHALLENGING_PROXY_AUTH_PRIMARY_DEFAULT=
OPENSHIFT_AUTH_METHOD_RHTPSIO_PRIMARY=token

OPENSHIFT_APPLICATION_NAME_MYPHP=myphp

OPENSHIFT_PRIMARY_CREDENTIALS_CLI_DEFAULT=

# get encryption/decryption key if one is not provided automatically
[[ -v SCRIPT_ENCRYPTION_KEY ]] || { read -t 10 -s -p "======> ENTER ENCRYPTION/DECRYPTION KEY:" SCRIPT_ENCRYPTION_KEY && echo "" ; }
# assume a default key if the user did not supply one in time
: ${SCRIPT_ENCRYPTION_KEY:=$OPENSHIFT_USER_PRIMARY_PASSWORD}


! [[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && ! [[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && { echo -n "Enter password for ${OPENSHIFT_MASTER_RHTPSIO_PRIMARY} : " && read -s OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT ; }
[[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] || { echo "FAILED: OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT must be set and match a valid password for the openshift cluster ${OPENSHIFT_MASTER_RHTPSIO_PRIMARY}" && exit 1 ; }
[[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && ! [[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "--> it is recommended to use an encrypted password; you may save the encrypted value OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT=${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT} or you may encrypt and store the token using the following: " && echo ' OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT=`echo ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} | openssl enc -e -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}`'
[[ -v OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "	--> Decrypting the script key" && { OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT=`echo "${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_CIPHERTEXT}" | openssl enc -d -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}` || { echo "FAILED: Could not validate the password" && exit 1; } ; }

# each user entry is an array of (username, password, auth-method default project, and any other projects)
OPENSHIFT_USER_RHTPSIO_ADMIN=(admin ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} password admin-default)
OPENSHIFT_USER_RHTPSIO_MEPLEY=(mepley ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} token mepley-default)
OPENSHIFT_USER_RHTPSIO_MEPLEY_DEV=(mepley ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} token mepley-development)
OPENSHIFT_USER_RHTPSIO_MEPLEY_TEST=(mepley ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} token mepley-testing)
OPENSHIFT_USER_RHTPSIO_MEPLEY_PROD=(mepley ${OPENSHIFT_RHTPSIO_USER_PASSWORD_DEFAULT_PLAINTEXT} token mepley-production)

# array of all users for this demo target
OPENSHIFT_USERS_RHTPSIO=(OPENSHIFT_USER_RHTPSIO_ADMIN OPENSHIFT_USER_RHTPSIO_MEPLEY OPENSHIFT_USER_RHTPSIO_MEPLEY_DEV OPENSHIFT_USER_RHTPSIO_MEPLEY_TEST OPENSHIFT_USER_RHTPSIO_MEPLEY_PROD)

if [ "$CONFIGURATION_DEMO_TARGET_RHTPSIO_DISPLAY" != "false" ]; then
	echo "Demo Target RHTPSIO Configuration__________________________"
	echo "	OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY           = ${OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_PRIMARY                    = ${OPENSHIFT_DOMAIN_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_RHTPSIO                   = ${OPENSHIFT_DOMAIN_RHTPSIO}"
	echo "	OPENSHIFT_MASTER_RHTPSIO_PRIMARY           = ${OPENSHIFT_MASTER_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_MASTER_RHTPSIO_PRIMARY_PORT_HTTPS= ${OPENSHIFT_MASTER_RHTPSIO_PRIMARY_PORT_HTTPS}"
	echo "	OPENSHIFT_APPS_RHTPSIO_PRIMARY             = ${OPENSHIFT_APPS_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_LOGGING_RHTPSIO_PRIMARY          = ${OPENSHIFT_LOGGING_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_PROXY_AUTH_RHTPSIO_PRIMARY       = ${OPENSHIFT_PROXY_AUTH_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_AUTH_METHOD_RHTPSIO_PRIMARY      = ${OPENSHIFT_AUTH_METHOD_RHTPSIO_PRIMARY}"
	echo "	OPENSHIFT_USERS_RHTPSIO = {"
	for OPENSHIFT_USER_RHTPSIO in ${!OPENSHIFT_USERS_RHTPSIO[@]}; do
		echo " OPENSHIFT_USER_RHTPSIO is ${OPENSHIFT_USER_RHTPSIO}"
		echo -n "		${OPENSHIFT_USERS_RHTPSIO[$OPENSHIFT_USER_RHTPSIO]} : "
		OPENSHIFT_USER_RHTPSIO_USERNAME_REF=${OPENSHIFT_USERS_RHTPSIO[$OPENSHIFT_USER_RHTPSIO]}[0] && echo -n "( username = ${!OPENSHIFT_USER_RHTPSIO_USERNAME_REF} , "
		OPENSHIFT_USER_RHTPSIO_PASSWORD_REF=${OPENSHIFT_USERS_RHTPSIO[$OPENSHIFT_USER_RHTPSIO]}[1] && echo -n "password (obfuscated) = ` echo ${!OPENSHIFT_USER_RHTPSIO_PASSWORD_REF} | md5sum`, "
		OPENSHIFT_USER_RHTPSIO_AUTHMETHOD_REF=${OPENSHIFT_USERS_RHTPSIO[$OPENSHIFT_USER_RHTPSIO]}[2] && echo -n "auth-method = ${!OPENSHIFT_USER_RHTPSIO_AUTHMETHOD_REF} , "
		OPENSHIFT_USER_RHTPSIO_PROJECT_REF=${OPENSHIFT_USERS_RHTPSIO[$OPENSHIFT_USER_RHTPSIO]}[3] && echo -n "project = ${!OPENSHIFT_USER_RHTPSIO_PROJECT_REF} )"
		echo ""
	done
	echo "	}"
	echo "____________________________________________________________"
	echo "	--> FYI: ssh access to OCP master available via ocp-master.rhtps.io via vpn.rhtps.io" && echo "	--> Use: ssh -vvv -i ~/.ssh/id_rsa_openshift -J vpn.rhtps.io mepley@ocp-master.rhtps.io"
	echo "	--> FYI: ssh access to maintenance node available via nicks-workstation.vrtx.rhtps.io via vpn.rhtps.io" && echo "	--> Use: ssh -i ~/.ssh/id_rsa_openshift -J vpn.rhtps.io nicks-workstation.vrtx.rhtps.io"
fi

# overwrite  generic configuration with RHSAMEMO specific configuration
OPENSHIFT_DOMAIN_DEFAULT=${OPENSHIFT_DOMAIN_RHTPSIO_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT=${OPENSHIFT_MASTER_RHTPSIO_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT_PORT_HTTPS=${OPENSHIFT_MASTER_RHTPSIO_PRIMARY_PORT_HTTPS}
OPENSHIFT_APPS_PRIMARY_DEFAULT=${OPENSHIFT_APPS_RHTPSIO_PRIMARY}
OPENSHIFT_LOGGING_PRIMARY_DEFAULT=${OPENSHIFT_LOGGING_RHTPSIO_PRIMARY}
OPENSHIFT_PROXY_AUTH_PRIMARY_DEFAULT=${OPENSHIFT_PROXY_AUTH_RHTPSIO_PRIMARY}
OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT="OPENSHIFT_USER_RHTPSIO_MEPLEY"
OPENSHIFT_USER_PRIMARY_DEFAULT=${OPENSHIFT_USER_RHTPSIO_MEPLEY[0]}
OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT=${OPENSHIFT_USER_RHTPSIO_MEPLEY[1]}
OPENSHIFT_AUTH_METHOD_PRIMARY_DEFAULT=${OPENSHIFT_USER_RHTPSIO_MEPLEY[2]}
OPENSHIFT_PROJECT_PRIMARY_DEFAULT=${OPENSHIFT_USER_RHTPSIO_MEPLEY[3]}
: ${OPENSHIFT_APPLICATION_NAME_DEFAULT:=default-app}
: ${OPENSHIFT_OUTPUT_FORMAT_DEFAULT:=json}


CONFIGURATION_DEMO_TARGET_RHTPSIO_COMPLETED=true
