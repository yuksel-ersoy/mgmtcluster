#!/usr/bin/env bash

#
# First get the list of container images for OpenStack
# Requires jq to be installed
#
UPSTREAM_URL="registry.redhat.io"
#

echo "Change directory to LOGS"
mkdir -p LOGS
cd LOGS

# Generate new file
curl -s https://${UPSTREAM_URL}/v1/search?q=%27rhosp-rhel8%20OR%20rhceph-4%20OR%20ose-grafana%20OR%20ose-prometheus%27|jq -r .results[].name > all_images

cat all_images | grep -v "openstack\|rhosp" > non_openstack_images
cat all_images | grep -i "openstack\|rhosp" > openstack_images

#
# Upload images to Quay
#
LOCAL_REGISTRY='quay1.apps.caumgmtocp.turkcell.tgc'
LOCAL_SECRET_JSON='../.dockerconfigjson-upd'

while read IMAGE; do \
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f2 | sed "s/openstack-//g" | sed "s/:.*//g") ; \
  echo "Mirroring image $IMAGENAME \n" ; \
  oc -a $LOCAL_SECRET_JSON image mirror ${UPSTREAM_URL}/$IMAGE:16.2 $LOCAL_REGISTRY/openstack/$IMAGENAME;
done < openstack_images

while read IMAGE; do \
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f2 | sed "s/openstack-//g" | sed "s/:.*//g") ; \
  echo "Mirroring image $IMAGENAME \n" ; \
  oc -a $LOCAL_SECRET_JSON image mirror ${UPSTREAM_URL}/$IMAGE:latest $LOCAL_REGISTRY/openstack/$IMAGENAME;
done < non_openstack_images

