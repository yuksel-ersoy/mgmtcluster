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

# Generate list of OpenStack container images 
podman search --limit 1000 "registry.redhat.io/rhosp-rhel9" --format="{{ .Name }}" | sort > satellite_images

# list of container images for Ceph
declare -a CEPH_IMAGES=(
registry.redhat.io/rhceph/rhceph-6-dashboard-rhel9
registry.redhat.io/rhceph/rhceph-6-rhel9
)

# list of container images for Prometheus for Ceph dashboard
declare -a PROM_IMAGES=(
registry.redhat.io/openshift4/ose-prometheus-node-exporter
registry.redhat.io/openshift4/ose-prometheus
registry.redhat.io/openshift4/ose-prometheus-alertmanager
)

#
# Upload images to Quay
#
LOCAL_REGISTRY='quay1.apps.caumgmtocp.turkcell.tgc
LOCAL_SECRET_JSON='../.dockerconfigjson-upd'

# OSP Images
while read IMAGE; do \
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f3 | sed "s/openstack-//g" | sed "s/:.*//g") ; \
  echo "Mirroring image $IMAGENAME \n" ; \
  oc -a $LOCAL_SECRET_JSON image mirror $IMAGE:17.1 $LOCAL_REGISTRY/openstack/$IMAGENAME;
done < satellite_images

# Ceph Images
for IMAGE in "${CEPH_IMAGES[@]}"; do
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f3) ; \
  echo "Mirroring image $IMAGENAME \n" ; \
  oc -a $LOCAL_SECRET_JSON image mirror $IMAGE:latest $LOCAL_REGISTRY/openstack/$IMAGENAME;
done

# Prometheus images for Ceph dashboard
for IMAGE in "${PROM_IMAGES[@]}"; do
  IMAGENAME=$(echo $IMAGE | cut -d"/" -f3) ; \
  echo "Mirroring image $IMAGENAME \n" ; \
  oc -a $LOCAL_SECRET_JSON image mirror $IMAGE:v4.6 $LOCAL_REGISTRY/openstack/$IMAGENAME;
done 

