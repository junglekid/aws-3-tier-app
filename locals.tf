locals {
  # AWS Provider 
  aws_region  = "us-west-2"
  aws_profile = "bsisandbox"

  # Tags
  owner       = "Dallin Rasmuson"
  environment = "sandbox"
  project     = "AWS 3-Tier App Lab"

  # Define Shirt Colors
  shirt_colors = [
    "Red",
    "Blue",
    "Green",
    "Yellow",
    "Black",
    "White",
    "Grey"
  ]
}
