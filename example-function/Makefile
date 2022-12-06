.PHONY: build-setup build clean

#
# This file assumes the only needed build is for Linux on ARM.
#
export GOARCH=arm64
export GOOS=linux

.DEFAULT_GOAL := build

build-setup:
	@mkdir -p build

build: build-setup
	cd src/ && go build -o ../build/example-func
	zip --temp-path ./build --junk-paths --no-dir-entries build/example-func.zip build/example-func

clean:
	rm -rf build
