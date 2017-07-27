GET=wget

clean:
	rm -rf test/lib

test_lib:
	mkdir -p test/lib
	# Get bats
	"${GET}" https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz
	tar xavf v0.4.0.tar.gz -C test/lib
	rm v0.4.0.tar.gz
	mv test/lib/bats-0.4.0 test/lib/bats
	# Get bats-support
	"${GET}" https://github.com/ztombol/bats-support/archive/v0.3.0.tar.gz
	tar xavf v0.3.0.tar.gz -C test/lib
	mv test/lib/bats-support* test/lib/bats-support
	rm v0.3.0.tar.gz
	# Get bats-assert
	"${GET}" https://github.com/ztombol/bats-assert/archive/v0.3.0.tar.gz
	tar xavf v0.3.0.tar.gz -C test/lib
	mv test/lib/bats-assert* test/lib/bats-assert
	rm v0.3.0.tar.gz
