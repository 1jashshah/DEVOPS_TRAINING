# resource "aws_s3_bucket" "static_assets" {
#   bucket = "static-assets-bucket-${random_string.unique_suffix.result}"
#   acl    = "private"

#   tags = {
#     Name = "StaticAssetsBucket"
#   }
# }

# resource "random_string" "unique_suffix" {
#   length  = 8
#   special = false
# }
# resource "aws_s3_bucket" "static_assets" {
#   bucket = "static-assets-bucket-${random_string.unique_suffix.result}"
#   acl    = "private"

#   tags = {
#     Name = "StaticAssetsBucket"
#   }
# }

# resource "random_string" "unique_suffix" {
#   length  = 8
#   special = false
#   upper   = false  
# }

resource "aws_s3_bucket" "static_assets" {
  bucket = "static-assets-bucket-${random_string.unique_suffix.result}"

  tags = {
    Name = "StaticAssetsBucket"
  }
}

resource "random_string" "unique_suffix" {
  length  = 8
  special = false
  upper   = false
}
