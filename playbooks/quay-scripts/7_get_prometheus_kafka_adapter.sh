export OCP_PULLSECRET_AUTHFILE='../.dockerconfigjson-upd'
export LOCAL_REGISTRY=quay1.apps.caumgmtocp.turkcell.tgc
export LOCAL_REGISTRY_IMAGE_TAG=tools
export TAG=1.8.0
export IMAGE_NAME=prometheus-kafka-adapter

echo "Change directory to LOGS"
mkdir -p LOGS
cd LOGS

#
# Pick the image
#
 oc -a $OCP_PULLSECRET_AUTHFILE image mirror \
        "docker.io/telefonica/${IMAGE_NAME}:${TAG}" \
        "$LOCAL_REGISTRY/$LOCAL_REGISTRY_IMAGE_TAG/${IMAGE_NAME}:${TAG}"

