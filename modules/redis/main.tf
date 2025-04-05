resource "null_resource" "ensure_vpc_exists" {
  count = var.resource_type == "redis" && try(data.terraform_remote_state.vpc[0].outputs.vpc_id, "") == "" ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'VPC not found! Cannot deploy Redis.' && exit 1"
  }
}
