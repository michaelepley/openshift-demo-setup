#!/usr/bin/env bash

# See https://mojo.redhat.com/docs/DOC-1099943
# See https://open.paas.redhat.com/console/

. config-resources-available-all.sh || { echo "FAILED: Could not load available resource index" && exit 1; }

[[ -v CONFIGURATION_DEMO_TARGET_DAN_REDHATGOVIO_COMPLETED ]] && echo "Using demo target DAN_REDHATGOVIO configuration" && { return || exit ; }
: ${CONFIGURATION_DEMO_TARGET_DAN_REDHATGOVIO_DISPLAY:=$CONFIGURATION_DISPLAY}

# variables marked as "PRIMARY", "SECONDARY", etc denote available alternatives 
OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY=dan.redhatgov.io
OPENSHIFT_DOMAIN_PRIMARY=${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_DOMAIN_DAN_REDHATGOVIO=${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY=${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO}
OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY_PORT_HTTPS=443
OPENSHIFT_APPS_DAN_REDHATGOVIO_PRIMARY=apps.${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO}
OPENSHIFT_LOGGING_DAN_REDHATGOVIO_PRIMARY=logging.${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO}
OPENSHIFT_PROXY_AUTH_DAN_REDHATGOVIO_PRIMARY=proxy.${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO}
OPENSHIFT_AUTH_METHOD_DAN_REDHATGOVIO_PRIMARY=password

OPENSHIFT_APPPLICATION_DAN_REDHATGOVIO_REGISTRY_CONSOLE=registry-console-default.${OPENSHIFT_APPS_DAN_REDHATGOVIO_PRIMARY}

OPENSHIFT_APPLICATION_NAME_MYPHP=myphp

OPENSHIFT_PRIMARY_CREDENTIALS_CLI_DEFAULT=

# TODO: store default password as ciphertext, as is done with github auth token 
## OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT
if [[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT ]] ; then
	echo "--> Using DAN_REDHATGOVIO password for openshift"
	OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT=$OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT
else
	[[ ! -v OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT ]] && echo "Please set OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT to your openshift password" && exit 1
fi


# get encryption/decryption key if one is not provided automatically
[[ -v SCRIPT_ENCRYPTION_KEY ]] || { read -t 10 -s -p "======> ENTER ENCRYPTION/DECRYPTION KEY:" SCRIPT_ENCRYPTION_KEY && echo "" ; }
# assume a default key if the user did not supply one in time
: ${SCRIPT_ENCRYPTION_KEY:=$OPENSHIFT_USER_PRIMARY_PASSWORD}

! [[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && ! [[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && { echo -n "Enter password for ${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY} : " && read -s OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT ; }
[[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] || { echo "FAILED: OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT must be set and match a valid password for the openshift cluster ${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY}" && exit 1 ; }
[[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT ]] && ! [[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "--> it is recommended to use an encrypted password; you may save the encrypted value OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT=${OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT} or you may encrypt and store the token using the following: " && echo ' OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT=`echo ${OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT} | openssl enc -e -pbkdf2 -salt -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}`'
[[ -v OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT ]] && echo "	--> Decrypting the script key" && { OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT=`echo "${OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_CIPHERTEXT}" | openssl enc -d -pbkdf2 -salt -a -aes-256-cbc -k ${SCRIPT_ENCRYPTION_KEY}` || { echo "FAILED: Could not validate the password" && exit 1; } ; }

# each user entry is an array of (username, password, auth-method default project, and any other projects)
OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN=(admin ${OPENSHIFT_DAN_REDHATGOVIO_USER_PASSWORD_DEFAULT_PLAINTEXT} password mepley-default)
# array of all users for this demo target
OPENSHIFT_USERS_DAN_REDHATGOVIO=(OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN)


if [ "$CONFIGURATION_DEMO_TARGET_DAN_REDHATGOVIO_DISPLAY" != "false" ]; then
	echo "Demo Target DAN_REDHATGOVIO Configuration__________________________"
	echo "	OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY           = ${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_PRIMARY                    = ${OPENSHIFT_DOMAIN_PRIMARY}"
	echo "	OPENSHIFT_DOMAIN_DAN_REDHATGOVIO                   = ${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO}"
	echo "	OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY           = ${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY}"
	echo "	OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY_PORT_HTTPS= ${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY_PORT_HTTPS}"
	echo "	OPENSHIFT_APPS_DAN_REDHATGOVIO_PRIMARY             = ${OPENSHIFT_APPS_DAN_REDHATGOVIO_PRIMARY}"
	echo "	OPENSHIFT_PROXY_AUTH_DAN_REDHATGOVIO_PRIMARY       = ${OPENSHIFT_PROXY_AUTH_DAN_REDHATGOVIO_PRIMARY}"
	echo "	OPENSHIFT_AUTH_METHOD_DAN_REDHATGOVIO_PRIMARY      = ${OPENSHIFT_AUTH_METHOD_DAN_REDHATGOVIO_PRIMARY}"
	echo "	OPENSHIFT_USERS_DAN_REDHATGOVIO = {"
	for OPENSHIFT_USER_DAN_REDHATGOVIO in ${!OPENSHIFT_USERS_DAN_REDHATGOVIO[@]}; do
		echo " OPENSHIFT_USER_DAN_REDHATGOVIO is ${OPENSHIFT_USER_DAN_REDHATGOVIO}"
		echo -n "		${OPENSHIFT_USERS_DAN_REDHATGOVIO[$OPENSHIFT_USER_DAN_REDHATGOVIO]} : "
		OPENSHIFT_USER_DAN_REDHATGOVIO_USERNAME_REF=${OPENSHIFT_USERS_DAN_REDHATGOVIO[$OPENSHIFT_USER_DAN_REDHATGOVIO]}[0] && echo -n "( username = ${!OPENSHIFT_USER_DAN_REDHATGOVIO_USERNAME_REF} , "
		OPENSHIFT_USER_DAN_REDHATGOVIO_PASSWORD_REF=${OPENSHIFT_USERS_DAN_REDHATGOVIO[$OPENSHIFT_USER_DAN_REDHATGOVIO]}[1] && echo -n "password (obfuscated) = ` echo ${!OPENSHIFT_USER_DAN_REDHATGOVIO_PASSWORD_REF}`, "
		OPENSHIFT_USER_DAN_REDHATGOVIO_AUTHMETHOD_REF=${OPENSHIFT_USERS_DAN_REDHATGOVIO[$OPENSHIFT_USER_DAN_REDHATGOVIO]}[2] && echo -n "auth-method = ${!OPENSHIFT_USER_DAN_REDHATGOVIO_AUTHMETHOD_REF} , "
		OPENSHIFT_USER_DAN_REDHATGOVIO_PROJECT_REF=${OPENSHIFT_USERS_DAN_REDHATGOVIO[$OPENSHIFT_USER_DAN_REDHATGOVIO]}[3] && echo -n "project = ${!OPENSHIFT_USER_DAN_REDHATGOVIO_PROJECT_REF} )"
		echo ""
	done
	echo "	}"
	echo "____________________________________________________________"
fi

# overwrite  generic configuration with RHSAMEMO specific configuration
OPENSHIFT_DOMAIN_DEFAULT=${OPENSHIFT_DOMAIN_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT=${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_MASTER_PRIMARY_DEFAULT_PORT_HTTPS=${OPENSHIFT_MASTER_DAN_REDHATGOVIO_PRIMARY_PORT_HTTPS}
OPENSHIFT_APPS_PRIMARY_DEFAULT=${OPENSHIFT_APPS_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_LOGGING_PRIMARY_DEFAULT=${OPENSHIFT_LOGGING_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_PROXY_AUTH_PRIMARY_DEFAULT=${OPENSHIFT_PROXY_AUTH_DAN_REDHATGOVIO_PRIMARY}
OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT="OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN"
OPENSHIFT_USER_PRIMARY_DEFAULT=${OPENSHIFT_USER_DAN_REDHATGOVIO_MEPLEY[0]}
OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT=${OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN[1]}
OPENSHIFT_AUTH_METHOD_PRIMARY_DEFAULT=${OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN[2]}
OPENSHIFT_PROJECT_PRIMARY_DEFAULT=${OPENSHIFT_USER_DAN_REDHATGOVIO_ADMIN[3]}
: ${OPENSHIFT_APPLICATION_NAME_DEFAULT:=default-app}
: ${OPENSHIFT_OUTPUT_FORMAT_DEFAULT:=json}

CONFIGURATION_DEMO_TARGET_DAN_REDHATGOVIO_COMPLETED=true
