oc -n quay-enterprise extract configmap/kube-root-ca.crt --confirm
sudo cp ca.crt /etc/pki/ca-trust/source/
sudo cp ca.crt /etc/pki/ca-trust/source/anchors
sudo cp ca.crt /etc/pki/ca-trust/source/whitelist
sudo update-ca-trust
sudo rm ca.crt

