#
# Add credentials for the new Quay to pull secret
#
echo "Extract the current pull secret"
oc extract secret/pull-secret -n openshift-config --confirm --to=.

echo "Add new quay credentials to pull secret"

#
# Add new quay repository username:password to pull secret
# username: quay, passwd: registry
#
QUAY1=quay1.apps.caumgmtocp.turkcell.tgc
QUAY2=quay2.apps.caumgmtocp.turkcell.tgc
QUAY_USER=quay
QUAY_PASS=registry

INP='%s:%s'
printf -v CRED $INP $QUAY_USER $QUAY_PASS
b64auth=$(echo -n $CRED | base64 -w0); echo $b64auth
AUTHSTRING="{\"$QUAY1\": {\"auth\": \"$b64auth\",\"email\": \"dummy@quay.npss\"},\"$QUAY2\": {\"auth\": \"$b64auth\",\"email\": \"dummy@quay.npss\"}}"; echo $AUTHSTRING

jq -c ".auths += $AUTHSTRING" < .dockerconfigjson > .dockerconfigjson-upd

echo "Push updated pull secret back to the cluster"
oc -n openshift-config set data secret/pull-secret --from-file=.dockerconfigjson=.dockerconfigjson-upd

#
# Copy pull secret to docker config (for oc-mirror)
#
mkdir -p ~/.docker
cp .dockerconfigjson-upd ~/.docker/config.json

echo "Delete the local dockerconfigjson files"
rm .dockerconfigjson
