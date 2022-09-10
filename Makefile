weave:
	srcweave --formatter srcweave-format --weave docs/ ReadMe.go.md security/Authentication.md Dependencies.md
tangle:
	srcweave --formatter srcweave-format --tangle smartkeyboard/ ReadMe.go.md security/Authentication.md EnvironmentVariables.md Dependencies.md
clean:
	rm -rf docs
	find smartkeyboard/ -type f -not -name "*_test.go" -delete
	rm go.mod
	rm go.sum

test: tangle
	-go mod init voidnet.tech/m/v2
	go mod tidy
	go test -v ./...

all: weave tangle