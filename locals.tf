locals {
  current_time = timestamp()
  az_names = data.aws_availability_zones.azs.names
}
