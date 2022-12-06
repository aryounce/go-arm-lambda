bats_require_minimum_version 1.5.0

load test_helper/bats-support/load.bash
load test_helper/bats-assert/load.bash

setup() {
	# Ensure our mock commands are found first
	export PATH="$(realpath ./test/test_helper/mocks):${PATH}"
}

@test "Boostrap succeeds" {
	export LAMBDA_TASK_ROOT=$(realpath ./test/handlers/)
	export _HANDLER=good-handler.sh
	export AWS_LAMBDA_RUNTIME_API=localhost

	run src/bootstrap

	assert_success
	assert_output "SUCCESS"
}

@test "Boostrap fails (missing LAMBDA_TASK_ROOT)" {
	export _HANDLER=good-handler.sh
	export AWS_LAMBDA_RUNTIME_API=localhost

	run src/bootstrap

	assert_failure
	assert_output --partial "LAMBDA_TASK_ROOT"
}

@test "Boostrap fails (missing _HANDLER)" {
	export LAMBDA_TASK_ROOT=$(realpath ./test/handlers/)
	export AWS_LAMBDA_RUNTIME_API=localhost

	run src/bootstrap

	assert_failure
	assert_output --partial "_HANDLER"
}

@test "Boostrap fails (missing AWS_LAMBDA_RUNTIME_API)" {
	# This test references a file that isn't executable this triggering error
	# output which should fail due to the missing AWS_LAMBDA_RUNTIME_API
	# environment variable.
	export LAMBDA_TASK_ROOT=$(realpath ./test/handlers/)
	export _HANDLER=bad-handler.sh

	run src/bootstrap

	assert_failure
	assert_output --partial "AWS_LAMBDA_RUNTIME_API"
}

@test "Boostrap fails (bad handler path, no such file)" {
	export LAMBDA_TASK_ROOT=$(realpath ./test/handlers/)
	export _HANDLER=not-a-handler.sh
	export AWS_LAMBDA_RUNTIME_API=localhost

	run src/bootstrap

	assert_failure 10
	assert_output --partial "Handler file not found at path"
}

@test "Boostrap fails (bad handler, not executable)" {
	export LAMBDA_TASK_ROOT=$(realpath ./test/handlers/)
	export _HANDLER=bad-handler.sh
	export AWS_LAMBDA_RUNTIME_API=localhost

	run src/bootstrap

	assert_failure 10
	assert_output --partial "Handler file not executable"
}
