variable "length" {
  type = number
}

resource "random_string" "example" {
  length  = var.length
  upper   = false
  lower   = true
  numeric  = true
  special = false
}

output "res" {
  value = random_string.example.result
}