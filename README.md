# go-arm-lambda

<img src="docs/go-arm-lambda.jpg"
     alt="Gopher Working Out"
     style="float: left; vertical-align:center;" />More easily run Golang ARM (`arm64`) binaries as Lambda functions.

## Why?

This project is an overwrought shell one-liner that solves the very specific problem of normalizing the specification, in CloudFormation or otherwise, of Golang AWS Lambda functions that use the `arm64` (Graviton2) architecture.

1. Lambda [does not directly support](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) (as of December 2022) the combination of the `go1.x` runtime and the `arm64` architecture.
2. Using the AWS Graviton2 processor for Lambda workloads potentially saves double-digit percentages on Lambda costs and has a positive performace impact.
3. Go is a special case in that it is compiled and contains both the function code and [runtime](https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html) in a single executable. See more below under **Prerequisites**.
4. Hacking around the issue repeatedly is annoying.

## How?

A [`bootstrap`](runtime/src/bootstrap) script is provided as a Lambda layer to make use of the Lambda's specified handler. When included in deployed Lambda functions this layer provides the "runtime" for the Go binary and does some basic error checking before executing the script. This ensures:

- You can specify a "handler" like you would for X86 (Intel) Golang binaries.
- Clear error logs are emitted when the handler is an invalid path.

That's basically it.

## Prerequisites

To make use of this project the following must be true for your Lambda deployments:

- Your Lambda must use the `arm64` [architecture](https://docs.aws.amazon.com/lambda/latest/dg/foundation-arch.html) and the `provided.al2` runtime (only Amazon Linux 2 supports the `arm64` architecture).
- Your Lambda function must include the provided [Lambda layer](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-concepts.html#gettingstarted-concepts-layer).
- The Golang executable *must* use the[ `aws-lambda-go` module](https://github.com/aws/aws-lambda-go).

## Installation

There are two methods of installation:

1. Use the pre-packaged layer content from my `ary.pub-lambda-community` S3 bucket. This is the default in the provided CloudFormation stack template.
   ```shell
   aws cloudformation deploy --template-file runtime/layer.yaml --stack-name go-arm-runtime
   ```

2. Host the layer content yourself by overriding the `ContentS3Bucket` and `ContentS3Key` parameters in the [layer stack template](runtime/layer.yaml) when deploying into your AWS account(s).
   ```shell
   aws cloudformation deploy \
   	--template-file runtime/layer.yaml --stack-name go-arm-runtime \
   	--parameter-overrides 'ContentS3Bucket=my-s3-bucket,ContentS3Key=my/path/layer-content.zip'
   ```

Once installed the Lambda layer ARN is availalble as the `<stack-name>:runtime-layer-arn` output.

## Usage

TODO

## Related Reading

- [Making your Go workloads up to 20% faster with Go 1.18 and AWS Graviton](https://aws.amazon.com/blogs/compute/making-your-go-workloads-up-to-20-faster-with-go-1-18-and-aws-graviton/)
- [AWS Lambda Functions Powered by AWS Graviton2 Processor](https://aws.amazon.com/blogs/aws/aws-lambda-functions-powered-by-aws-graviton2-processor-run-your-functions-on-arm-and-get-up-to-34-better-price-performance/)
- [Go on Graviton](https://github.com/aws/aws-graviton-getting-started/blob/main/golang.md)
- [Migrating AWS Lambda functions to Arm-based AWS Graviton2 processors](https://aws.amazon.com/blogs/compute/migrating-aws-lambda-functions-to-arm-based-aws-graviton2-processors/)
- [cgo for ARM64 Lambda Functions](https://awsteele.com/blog/2021/10/17/cgo-for-arm64-lambda-functions.html)
- [Deploying Golang Lambdas on ARM with AWS Serverless Application Model (SAM)](https://github.com/aws-samples/sessions-with-aws-sam/tree/master/go-al2)
