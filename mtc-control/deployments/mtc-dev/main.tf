//--------------------------------------------------------------------
// Variables



//--------------------------------------------------------------------
// Modules
module "compute" {
  source  = "app.terraform.io/isekai/compute/aws"
  version = "2.0.0"

  aws_region          = "us-east-1"
  public_key_material = ""
  public_sg           = module.networking.public_sg
  public_subnets      = module.networking.public_subnets
}

module "networking" {
  source  = "app.terraform.io/isekai/networking/aws"
  version = "1.0.0"

  access_ip  = "x.x.x.x/32" #set to IP of Cloud9 EC2 Instance
  aws_region = "us-east-1"
}
