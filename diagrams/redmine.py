from diagrams import Cluster, Diagram
from diagrams.aws.database import RDS
from diagrams.aws.network import Route53
from diagrams.aws.compute import EC2
from diagrams.aws.storage import S3

with Diagram("Redmine", show=False):
    dns = Route53("dns")
    instance = EC2("redmine instance")
    rds_database = RDS("mysqldb")
    backups = S3("backups")

    dns >> instance >> rds_database
    instance >> backups
