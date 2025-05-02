# Storage bucket for the sandbox test
resource "aws_s3_bucket" "sandbox_test" {
  bucket = local.pj_name
}

output "bucket_arn" {
  value = aws_s3_bucket.sandbox_test.arn
}






# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Deny",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Action": "s3:*",
#             "Resource": [
#                 "arn:aws:s3:::amplify-amplifyvitereactt-amplifytestbucket1d7fbd2-lroh1qlpc91x",
#                 "arn:aws:s3:::amplify-amplifyvitereactt-amplifytestbucket1d7fbd2-lroh1qlpc91x/*"
#             ],
#             "Condition": {
#                 "Bool": {
#                     "aws:SecureTransport": "false"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "arn:aws:iam::910676727589:role/amplify-amplifyvitereactt-CustomS3AutoDeleteObjects-ACxLn3JuX4dq"
#             },
#             "Action": [
#                 "s3:PutBucketPolicy",
#                 "s3:GetBucket*",
#                 "s3:List*",
#                 "s3:DeleteObject*"
#             ],
#             "Resource": [
#                 "arn:aws:s3:::amplify-amplifyvitereactt-amplifytestbucket1d7fbd2-lroh1qlpc91x",
#                 "arn:aws:s3:::amplify-amplifyvitereactt-amplifytestbucket1d7fbd2-lroh1qlpc91x/*"
#             ]
#         }
#     ]
# }