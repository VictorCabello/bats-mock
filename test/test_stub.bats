#!./test/libs/bats/bin/bats

load '../stub'
load 'lib/bats-support/load'
load 'lib/bats-assert/load'

@test "stub_001: Simple Plan" {
    # Prepare
    stub 'mycommand' ' echo "all good!" '

    # Execute
    run 'mycommand'

    # Verify
    assert_success
    assert_output 'all good!'
    unstub 'mycommand'
}
