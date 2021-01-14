TIME="${1:-"now"}"
HOST="ec2-34-235-139-173.compute-1.amazonaws.com"
ansible-playbook -u ubuntu --private-key ./conjunto.pem -i $HOST, restore-scripts/files.yml --extra-vars "time=$TIME"
