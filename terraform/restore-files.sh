TIME="${1:-"now"}"
HOST="$(terraform output -raw redmine-ip)"
ansible-playbook -u ubuntu --private-key ./conjunto.pem -i $HOST, restore-scripts/files.yml --extra-vars "time=$TIME"
