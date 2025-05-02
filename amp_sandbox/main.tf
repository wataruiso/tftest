provider "aws" {}

resource "random_id" "id" {
  byte_length = 4
}

locals {
  pj_name    = "sandbox-test-${random_id.id.dec}"
  target_dir = "logs"
}
