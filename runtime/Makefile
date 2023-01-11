.PHONY: \
	default clean build-setup build-layer-content publish-layer-content \
	lint test

CONTENT_S3_BUCKET ?= ary.pub-lambda-community
CONTENT_S3_KEY ?= go-arm-lambda/runtime-layer.zip

default:
	@echo "There is no default target for this Makefile" && exit 1

lint:
	shellcheck --norc src/*

clean:
	rm -rf build

test-setup:
	git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
	git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert

test:
	bats --show-output-of-passing-tests --print-output-on-failure test/*.bats

build-setup: clean
	@mkdir -p build

build-layer-content: build-setup
	cd src && zip --temp-path ../build ../build/$$(basename ${CONTENT_S3_KEY}) *

publish-layer-content: build-layer-content
	aws s3 cp \
		build/$$(basename ${CONTENT_S3_KEY}) \
		s3://${CONTENT_S3_BUCKET}/${CONTENT_S3_KEY}

update-layer-content: publish-layer-content
	aws lambda publish-layer-version \
		--layer-name golang-arm-runtime \
		--content S3Bucket=${CONTENT_S3_BUCKET},S3Key=${CONTENT_S3_KEY}
