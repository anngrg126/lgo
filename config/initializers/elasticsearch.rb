#ENV["ELASTICSEARCH_URL"] = "https://es-domain-1234.us-east-1.es.amazonaws.com"
#
#Searchkick.aws_credentials = {
#  access_key_id: ENV["AWS_ACCESS_KEY_ID"],
#  secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
#  region: "us-east-1"
#}
# run this after deploying to AWS
# rake searchkick:reindex CLASS=Story