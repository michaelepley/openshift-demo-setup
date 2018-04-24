#!/bin/bash

# Configuration

#                                0     1        2        3          4      5            6
DEMO_TARGET_OPENSHIFT_INSTANCES=(local rhsademo rhtps-io fortnebula itpaas nsabine-vrtx hattrick1)

for DEMO_TARGET_OPENSHIFT_INSTANCE in ${DEMO_TARGET_OPENSHIFT_INSTANCES[*]} ; do
	echo"	--> checking openshift instance ${DEMO_TARGET_OPENSHIFT_INSTANCE}"
	TEST_SCRIPT=setup-test-${DEMO_TARGET_OPENSHIFT_INSTANCE}.sh
	[ -f ${TEST_SCRIPT} ] && ./${TEST_SCRIPT}
done

echo "Done."
