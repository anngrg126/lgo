Searchkick.aws_credentials = {
 access_key_id: ENV["AWS_ACCESS_KEY_ID"],
 secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
 region: "us-west-2"
}
# run this after deploying to AWS
# rake searchkick:reindex CLASS=Story