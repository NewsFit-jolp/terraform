#################################
# 로컬 환경에 DynamoDB 테이블 생성하기 #
#################################


# set up environment
docker pull amazon/dynamodb-local
docker run -d -p 8000:8000 amazon/dynamodb-local -jar DynamoDBLocal.jar -inMemory -sharedDb

#  ddb_url_variables.tf
aws dynamodb create-table \
    --table-name test_ddb \
    --attribute-definitions \
        AttributeName=id,AttributeType=S \
    --key-schema AttributeName=id,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 \
    --endpoint-url http://localhost:8000
