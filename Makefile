weave:
	srcweave --formatter srcweave-format --weave docs/ ReadMe.md security/Authentication.md EnvironmentVariables.md Dependencies.md Server.md Streaming.md ThreatModel.md Client.md
	util/removefencedcode.py
tangle:
	srcweave --formatter srcweave-format --tangle smartkeyboard/ ReadMe.md security/Authentication.md EnvironmentVariables.md Dependencies.md Server.md Streaming.md ThreatModel.md Client.md
clean:
	rm -rf docs
	find smartkeyboard/ -type f -not -name "*_test.go" -delete
	rm go.mod
	rm go.sum

build: tangle
	- cd smartkeyboard && go mod init keyboard.voidnet.tech
	- cd smartkeyboard && go mod tidy
	- cd smartkeyboard && go build -o ../bin/keyboard


test: tangle
	-cd smartkeyboard && go mod init keyboard.voidnet.tech
	-cd smartkeyboard && go mod tidy
	-cd smartkeyboard && go test -v ./...

all: weave tangle