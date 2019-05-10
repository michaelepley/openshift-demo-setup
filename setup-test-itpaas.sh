#!/usr/bin/env bash

# Note: requires bash 4.2 or later

# assume the demo is interactive
: ${DEMO_INTERACTIVE:=true}
: ${DEMO_INTERACTIVE_PROMPT_TIMEOUT_SECONDS:=30}

#                                0     1        2        3          4      5            6         7         8
DEMO_TARGET_OPENSHIFT_INSTANCES=(local rhsademo rhtps-io fortnebula itpaas nsabine-vrtx hattrick1 hattrick2 hattrick3)
# Target HATTRICK1
DEMO_TARGET_OPENSHIFT_INSTANCE=${DEMO_TARGET_OPENSHIFT_INSTANCES[4]}

# assume we don't need to expressly verify the clusters operational status
: ${OPENSHIFT_CLUSTER_VERIFY_OPERATIONAL_STATUS:=false}

# Configuration
pushd config >/dev/null 2>&1
. ./config.sh || { echo "FAILED: Could not configure generic demo environment" && exit 1 ; }
# we will be using github for this demo, so load these configuration resources 
. ./config-resources-github.sh || { echo "FAILED: Could not configure github demo resources" && exit 1 ; }
popd >/dev/null 2>&1

[[ -v CONFIGURATION_DEMO_SETUP_TEST_ITPAAS_COMPLETED ]] && echo "Using openshift demo setup test configuration" && { return || exit ; }
: ${CONFIGURATION_DEMO_OPENSHIFT_SIMPLE_DISPLAY:=$CONFIGURATION_DISPLAY}
# uncomment to force these scripts to display coniguration information
CONFIGURATION_OPENSHIFT_SETUP_TEST_DISPLAY=true

# Demo specific configuration items
# modify the user, or copy to new reference, then modify
#OPENSHIFT_USER_PROJECT_REF="OPENSHIFT_USER_ITPAAS_MEPLEY[3]" && eval "${OPENSHIFT_USER_PROJECT_REF}=mepley-test-setup"
: ${OPENSHIFT_PROJECT_TEST_SETUP_DEFAULT:=${OPENSHIFT_USER_ITPAAS_MEPLEY[0]}-test-setup}
OPENSHIFT_PROJECT_TEST_SETUP=${OPENSHIFT_PROJECT_TEST_SETUP_DEFAULT}

#OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT
# Set the base configuration variables for the openshift-demo-simple
: ${OPENSHIFT_DOMAIN:=$OPENSHIFT_DOMAIN_DEFAULT}
: ${OPENSHIFT_MASTER:=$OPENSHIFT_MASTER_PRIMARY_DEFAULT}
: ${OPENSHIFT_APPS:=$OPENSHIFT_APPS_PRIMARY_DEFAULT}
: ${OPENSHIFT_PROXY_AUTH:=$OPENSHIFT_PROXY_AUTH_PRIMARY_DEFAULT}
OPENSHIFT_USER_REFERENCE=${OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT}
: ${OPENSHIFT_USER:=$OPENSHIFT_USER_PRIMARY_DEFAULT}
: ${OPENSHIFT_USER_PASSWORD:=$OPENSHIFT_USER_PRIMARY_PASSWORD_DEFAULT}
: ${OPENSHIFT_AUTH_METHOD:=$OPENSHIFT_AUTH_METHOD_PRIMARY_DEFAULT}
OPENSHIFT_PROJECT=${OPENSHIFT_PROJECT_TEST_SETUP}
: ${OPENSHIFT_OUTPUT_FORMAT:=$OPENSHIFT_OUTPUT_FORMAT_DEFAULT}

if [ "$CONFIGURATION_OPENSHIFT_SETUP_TEST_DISPLAY" != "false" ]; then
	echo "Demo Openshift Simple Configuration_________________________"
	echo "	OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT = ${OPENSHIFT_USER_REFERENCE_PRIMARY_DEFAULT}"
	echo "	OPENSHIFT_USER_ITPAAS_MEPLEY           = ${OPENSHIFT_USER_ITPAAS_MEPLEY[@]}"
	echo "	OPENSHIFT_PROJECT_TEST_SETUP_DEFAULT     = ${OPENSHIFT_PROJECT_TEST_SETUP_DEFAULT}"
	echo "	OPENSHIFT_PROJECT_TEST_SETUP             = ${OPENSHIFT_PROJECT_TEST_SETUP}"
	echo "	OPENSHIFT_DOMAIN                         = ${OPENSHIFT_DOMAIN}"
	echo "	OPENSHIFT_MASTER                         = ${OPENSHIFT_MASTER_PRIMARY_DEFAULT}"
	echo "	OPENSHIFT_APPS                           = ${OPENSHIFT_APPS}"
	echo "	OPENSHIFT_PROXY_AUTH                     = ${OPENSHIFT_PROXY_AUTH}"
	echo "	OPENSHIFT_USER_REFERENCE                 = ${OPENSHIFT_USER_REFERENCE}"
	echo "	OPENSHIFT_USER                           = ${OPENSHIFT_USER}"
	echo "	OPENSHIFT_USER_PASSWORD                  = `echo ${OPENSHIFT_USER_PASSWORD} | md5sum` (obfuscated)"
	echo "	OPENSHIFT_AUTH_METHOD                    = ${OPENSHIFT_AUTH_METHOD}"
	echo "	OPENSHIFT_PROJECT                        = ${OPENSHIFT_PROJECT}"
	echo "	OPENSHIFT_OUTPUT_FORMAT                  = ${OPENSHIFT_OUTPUT_FORMAT}"
	echo "____________________________________________________________"
fi

CONFIGURATION_DEMO_SETUP_TEST_ITPAAS_COMPLETED=true


echo -n "Verifying configuration ready..."
: ${DEMO_INTERACTIVE?}
: ${DEMO_INTERACTIVE_PROMPT?}
: ${DEMO_INTERACTIVE_PROMPT_TIMEOUT_SECONDS?}
: ${OPENSHIFT_USER_REFERENCE?}
: ${OPENSHIFT_PROJECT?}
echo "OK"
echo "Setup PHP Configuration_____________________________________"
echo "	OPENSHIFT_USER_REFERENCE             = ${OPENSHIFT_USER_REFERENCE}"
echo "	OPENSHIFT_PROJECT                    = ${OPENSHIFT_PROJECT}"
echo "____________________________________________________________"

echo "Test demo setup for rhsademo"
echo "	--> Make sure we are logged in (to the right instance and as the right user)"
pushd config >/dev/null 2>&1
. ./setup-login.sh -r OPENSHIFT_USER_REFERENCE -n ${OPENSHIFT_PROJECT} || { echo "FAILED: Could not login" && exit 1; }
popd >/dev/null 2>&1

[ "x${OPENSHIFT_CLUSTER_VERIFY_OPERATIONAL_STATUS}" != "xfalse" ] || { echo "	--> Verify the openshift cluster is working normally" && oc status -v >/dev/null || { echo "FAILED: could not verify the openshift cluster's operational status" && exit 1; } ; }

oc logout || { echo "FAILED: Could not logout" && exit 1; }

echo "Done."
