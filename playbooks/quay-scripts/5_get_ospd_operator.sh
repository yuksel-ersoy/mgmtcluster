
mkdir -p LOGS
cd LOGS

export OSPD_rhel8_RELEASE=1.3.0-17
export OSPD_rhel9_RELEASE=1.3.1
export OCP_PULLSECRET_AUTHFILE='../.dockerconfigjson-upd'
export LOCAL_REGISTRY=quay1.apps.caumgmtocp.turkcell.tgc
export LOCAL_REGISTRY_INDEX_TAG_RHEL8=ospd/osp-director-operator-index:$OSPD_rhel8_RELEASE
export LOCAL_REGISTRY_INDEX_TAG_RHEL9=ospd/osp-director-operator-index:$OSPD_rhel9_RELEASE
export LOCAL_REGISTRY_IMAGE_TAG=ospd

# Get the SHA256 value for the OSPD operator bundle using the following command:
# skopeo inspect docker://registry.redhat.io/rhosp-rhel8/osp-director-operator-bundle:1.3.0-17 | grep Digest
#
# use the SHA value in the opm command below
#
# The SHA value for v1.3.0-17 is:
#  --bundles registry.redhat.io/rhosp-rhel8/osp-director-operator-bundle@sha256:d16319790b471590d05d1e37a14c83438d2a40230f83d292242c696248e39270
#
# The SHA value for v1.3.1 (rhel9) is:
#  --bundles registry.redhat.io/rhosp-rhel9/osp-director-operator-bundle@sha256:ddea5e07f70228c3a23a34a92291138961b41a28147cf029bf6b769a50e94a6d
#
echo "(rhel 8) Adding to index \n"
opm index add \
  --bundles registry.redhat.io/rhosp-rhel8/osp-director-operator-bundle@sha256:d16319790b471590d05d1e37a14c83438d2a40230f83d292242c696248e39270 \
  --tag $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL8

#
# Push the updated index image rhel 8
#
echo "Running podman push\n"
podman push $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL8 --authfile $OCP_PULLSECRET_AUTHFILE

# 
echo "Mirorring catalog for rhel 8\n"
oc adm catalog mirror $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL8 $LOCAL_REGISTRY/$LOCAL_REGISTRY_IMAGE_TAG --registry-config=$OCP_PULLSECRET_AUTHFILE --insecure --index-filter-by-os='Linux/x86_64'

echo "(rhel 9) Adding to index \n"
opm index add \
  --bundles registry.redhat.io/rhosp-rhel9/osp-director-operator-bundle@sha256:ddea5e07f70228c3a23a34a92291138961b41a28147cf029bf6b769a50e94a6d \
  --tag $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL9

#
# Push the updated index image rhel 9
#
echo "Running podman push\n"
podman push $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL9 --authfile $OCP_PULLSECRET_AUTHFILE

# 
echo "Mirorring catalog for rhel 9\n"
oc adm catalog mirror $LOCAL_REGISTRY/$LOCAL_REGISTRY_INDEX_TAG_RHEL9 $LOCAL_REGISTRY/$LOCAL_REGISTRY_IMAGE_TAG --registry-config=$OCP_PULLSECRET_AUTHFILE --insecure --index-filter-by-os='Linux/x86_64'

