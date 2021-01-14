DATABASE_SNAPSHOT=123123

terraform apply -var="use_rds=true" -var="backup_snapshot=$DATABASE_SNAPSHOT"

HOST=$(terraform output -raw redmine-ip)
DATABASE_HOST=$(terraform output -raw database-ip)

ansible-playbook -u ubuntu --private-key ./conjunto.pem -i $HOST, restore-scripts/update-database.yml --extra-vars "database_host=$DATABASE_HOST"
