#!/usr/bin/env bash

[[ -v CONFIGURATION_RESOURCES_AVAILABLE_ALL_COMPLETED ]] && echo "	--> Using resources available configuration" && { return || exit ; }
: ${CONFIGURATION_RESOURCES_AVAILABLE_ALL_DISPLAY:=$CONFIGURATION_DISPLAY}

# Configuration

. config-demo-default.sh

: ${OPENSHIFT_USER_PRIMARY_DEFAULT?"FAILED: must specify the OPENSHIFT_USER_PRIMARY_DEFAULT"}

OPENSHIFT_PROJECT_PRIMARY_DEMO_HELLOWORLD_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-helloworld
OPENSHIFT_PROJECT_PRIMARY_DEMO_SIMPLE_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-simple
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_BUILDIMAGESDEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-buildimages
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_IMAGE_PROMOTION_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-image-promotion
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_DEVTESTPROD_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-devtestprod
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_COMPLEX_BUILDS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-complex-builds
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_PIPELINES_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-pipelines
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_TEAMING_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-teaming
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_TEMPLATES_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-templates
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_RBAC_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-workflow-rbac

OPENSHIFT_PROJECT_PRIMARY_DEMO_EAP_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-eap
OPENSHIFT_PROJECT_PRIMARY_DEMO_EWS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-ews
OPENSHIFT_PROJECT_PRIMARY_DEMO_JDG_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-jdg
OPENSHIFT_PROJECT_PRIMARY_DEMO_AMQ_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-amq
OPENSHIFT_PROJECT_PRIMARY_DEMO_FUSE_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-fuse
OPENSHIFT_PROJECT_PRIMARY_DEMO_JDV_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-jdv
OPENSHIFT_PROJECT_PRIMARY_DEMO_BRMS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-brms
OPENSHIFT_PROJECT_PRIMARY_DEMO_BPMS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-bpms

OPENSHIFT_PROJECT_PRIMARY_DEMO_DOTNET_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-demo-dotnet

OPENSHIFT_PROJECT_PRIMARY_TEST_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-test
OPENSHIFT_PROJECT_PRIMARY_MYSQLPHP_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-myphp
OPENSHIFT_PROJECT_PRIMARY_GEOPAAS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-geopaas
OPENSHIFT_PROJECT_PRIMARY_RADANALYTICS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-radanalytics
OPENSHIFT_PROJECT_PRIMARY_RHOAR_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-rhoar
OPENSHIFT_PROJECT_PRIMARY_PROMETHEUS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-prometheus
OPENSHIFT_PROJECT_PRIMARY_MANAGEIQ_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-manageiq
OPENSHIFT_PROJECT_PRIMARY_OPENBROKERAPI_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-openbrokerapi
OPENSHIFT_PROJECT_PRIMARY_DEVNATIONFEDERAL2017_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-devnation-federal-2017
OPENSHIFT_PROJECT_PRIMARY_RHSUMMIT2017_DATASERVICES_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-rhsummit-2017-dataservices
OPENSHIFT_PROJECT_PRIMARY_EAP_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-eap
OPENSHIFT_PROJECT_PRIMARY_AMQ_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-fuse-amq
OPENSHIFT_PROJECT_PRIMARY_FUSE_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-fuse
OPENSHIFT_PROJECT_PRIMARY_BRMS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-brms
OPENSHIFT_PROJECT_PRIMARY_BPMS_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-bpms
OPENSHIFT_PROJECT_PRIMARY_JDG_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-jdg
OPENSHIFT_PROJECT_PRIMARY_JDV_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-jdv
OPENSHIFT_PROJECT_PRIMARY_VAULT_DEFAULT=${OPENSHIFT_USER_PRIMARY_DEFAULT}-vault

OPENSHIFT_PROJECTS_DEFAULT=(
OPENSHIFT_PROJECT_PRIMARY_DEMO_HELLOWORLD_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_SIMPLE_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_BUILDIMAGESDEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_IMAGE_PROMOTION_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_DEVTESTPROD_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_COMPLEX_BUILDS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_PIPELINES_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_TEAMING_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_TEMPLATES_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_WORKFLOW_RBAC_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_EAP_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_EWS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_JDG_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_AMQ_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_FUSE_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_JDV_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_BRMS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEMO_BPMS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_TEST_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_MYSQLPHP_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_GEOPAAS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_RADANALYTICS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_RHOAR_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_PROMETHEUS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_MANAGEIQ_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_OPENBROKERAPI_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_DEVNATIONFEDERAL2017_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_RHSUMMIT2017_DATASERVICES_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_EAP_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_AMQ_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_FUSE_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_BRMS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_BPMS_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_JDG_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_JDV_DEFAULT
OPENSHIFT_PROJECT_PRIMARY_VAULT_DEFAULT
)

GITHUB_USERS=(michaelepley)

if [ "$CONFIGURATION_RESOURCES_AVAILABLE_ALL_DISPLAY" != "false" ]; then
	echo "Resources Available Configuration___________________________"
	echo "	OPENSHIFT_PROJECTS_DEFAULT = {"
	for OPENSHIFT_PROJECT_DEFAULT in ${!OPENSHIFT_PROJECTS_DEFAULT[@]}; do
		echo -n "		${OPENSHIFT_PROJECTS_DEFAULT[$OPENSHIFT_PROJECT_DEFAULT]} : "
		OPENSHIFT_PROJECT_DEFAULT_REF=${OPENSHIFT_PROJECTS_DEFAULT[$OPENSHIFT_PROJECT_DEFAULT]}[0] && echo -n "( ${!OPENSHIFT_PROJECT_DEFAULT_REF} )"
		echo ""
	done
	echo "	}"
	echo "____________________________________________________________"
fi

CONFIGURATION_RESOURCES_AVAILABLE_ALL_COMPLETED=true