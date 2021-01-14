HOST=123
DATABASE_HOST=123

ansible-playbook -u ubuntu --private-key ./conjunto.pem -i $HOST',' restore-scripts/update-database.yml --extra-vars 'database_host='$DATABASE_HOST'
