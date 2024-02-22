module "example" {
  source = "PUT-MODULE-PATH-HERE"

  use_ipam_pool-02f0            = "PUT-VALUE-HERE"
  cidr-02f                      = "PUT-VALUE-HERE"
  iam_role_name                 = "PUT-VALUE-HERE"
  use_ipam_pool                 = "PUT-VALUE-HERE"
  iam_role_use_name_prefix      = "PUT-VALUE-HERE"
  vpc_tags                      = "PUT-VALUE-HERE"
  iam_role_tags                 = "PUT-VALUE-HERE"
  cidr                          = "PUT-VALUE-HERE"
  iam_role_description          = "Allows access to other AWS service resources that are required to run Amazon EKS pods on AWS Fargate."
  iam_role_name-e00d            = "PUT-VALUE-HERE"
  iam_role_use_name_prefix-e00d = "PUT-VALUE-HERE"
  tags                          = "PUT-VALUE-HERE"
}

