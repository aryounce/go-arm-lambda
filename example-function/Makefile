.PHONY: build-setup build clean

#
# This file assumes the only needed build is for Linux on ARM.
#
export GOARCH=arm64
export GOOS=linux

CODE_S3_BUCKET ?= ary.pub-lambda-community
CODE_S3_KEY ?= go-arm-lambda/example-function.zip

.DEFAULT_GOAL := build

clean:
	rm -rf build

build-setup:
	@mkdir -p build

build: build-setup
	cd src/ && go build -o ../build/example-func
	zip --temp-path ./build --junk-paths --no-dir-entries build/example-func.zip build/example-func

publish: build
	aws s3 cp build/example-func.zip s3://${CODE_S3_BUCKET}/${CODE_S3_KEY}

deploy:
	aws cloudformation deploy \
		--template-file function.yaml \
		--stack-name go-arm-lambda-example \
		--capabilities CAPABILITY_IAM
