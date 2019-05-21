#!/usr/bin/env bash

# Configuration

#                                0     1        2        3          4      5            6               7                  8                   9         10        11 
DEMO_TARGET_OPENSHIFT_INSTANCES=(local rhsademo rhtps-io fortnebula itpaas nsabine-vrtx dan-redhatgovio mepley-demo-redhatgovio geoint-redhatgovio  hattrick1 hattrick2 hattrick3)

for DEMO_TARGET_OPENSHIFT_INSTANCE in ${DEMO_TARGET_OPENSHIFT_INSTANCES[*]} ; do
	echo"	--> checking openshift instance ${DEMO_TARGET_OPENSHIFT_INSTANCE}"
	TEST_SCRIPT=setup-test-${DEMO_TARGET_OPENSHIFT_INSTANCE}.sh
	[ -f ${TEST_SCRIPT} ] && ./${TEST_SCRIPT}
done

echo "Done."
