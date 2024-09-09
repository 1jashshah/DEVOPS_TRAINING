cidr_block          = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
public_subnet_az    = "us-east-1a"
private_subnet_cidr = "10.0.2.0/24"
private_subnet_az   = "us-east-1b"

instance_count = 1
ami_id         = "ami-0e86e20dae9224db8"
instance_type  = "t2.micro"

bucket_name = "test-new-bucket-name-222"

iam_role_name             = "my-iam-role"
iam_policy_arn            = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
iam_instance_profile_name = "instance-profile"

instance_class = "db.t3.micro"
db_name        = "mydatabase"
username       = "admin"
password       = "password"
