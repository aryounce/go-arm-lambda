package main

import (
	"github.com/aws/aws-lambda-go/lambda"
)

func lambdaEntrypoint() (string, error) {
	return "Hello, friend.", nil
}

func main() {
	lambda.Start(lambdaEntrypoint)
}
