#!/bin/bash

if [ -z "$1" ] 
    then
        echo "Script to Build and Deploy Lambda function to AWS\n"
        echo "  -a          build and deploy all lambdas"
fi

function build_and_deploy_aws_lambda_in_go_lang {
    echo "> Start build: AWS lambda in go lang"
    GOOS=linux go build -o build/main cmd/main.go
    echo "> End build: AWS lambda in go lang"
    echo "> Start zip: AWS lambda in go lang"
    zip -jrm build/main.zip build/main
    echo "> End zip: AWS lambda in go lang"
}


case $1 in 
    "-a")
        build_and_deploy_aws_lambda_in_go_lang
        ;;
esac


#echo "> Start Deploy: AWS lambda in go lang"
#    aws lambda update-function-code --function-name lambda-in-go-lang --zip-file fileb://build/main.zip >> logs/deploy-sendnotification.txt
#    echo "> End Deploy: AWS lambda in go lang"