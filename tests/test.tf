variable "string" {
  default = "tfc-workspace-sandbox_dev"
}

output "replace_string" {
  value = "${replace(var.string,"/^(ADMIN-)?([0-9A-Za-z-]+)(_.*)?$/","$2")}"
}
