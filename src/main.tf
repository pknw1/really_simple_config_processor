resource "local_file" "example" {
  content  = "${var.module_variable1}"
  filename = "/tmp/${var.module_variable2}"
}