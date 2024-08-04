sudo dnf install -y pip
ansible-galaxy collection install kubernetes.core
ansible-galaxy collection install community.general
pip install kubernetes
pip install pyYAML
pip install jsonpatch

# Satellite playbook requirements
ROLE_PATH="${HOME}/.ansible/collections/ansible_collections/oasis_roles/satellite"
rm -rf ${ROLE_PATH}
mkdir -p ${ROLE_PATH}
git clone https://github.com/RedHatSatellite/satellite-ansible-compilation ${ROLE_PATH}
ansible-galaxy install -r ${ROLE_PATH}/requirements.yml

ansible-galaxy collection install ansible.posix
ansible-galaxy collection install community.crypto
