weave:
	srcweave --formatter srcweave-format --weave docs/ ReadMe.md Building.md Dependencies.md EnvironmentVariables.md LICENSE.md \
	security/Authentication.md security/ThreatModel.md Plumbing.md server/Server.md server/Streaming.md server/Sendkeys.md server/XdotoolCommands.md \
	Client.md tools/Tools.md tools/Editor.md tools/Input.md tools/RawCapture.md
	util/clean.py
tangle:
	srcweave --formatter srcweave-format --tangle smartkeyboard/ ReadMe.md Plumbing.md security/Authentication.md EnvironmentVariables.md Dependencies.md \
	server/Server.md server/Streaming.md server/Sendkeys.md server/XdotoolCommands.md ThreatModel.md Client.md tools/Tools.md tools/Editor.md tools/Input.md \
	tools/RawCapture.md
clean:
	rm -rf docs
	find smartkeyboard/ -type f -not -name "*_test.go" -delete
	rm go.mod
	rm go.sum

build: tangle
	- cd smartkeyboard/server && go mod init keyboard.voidnet.tech
	- cd smartkeyboard/server && go mod tidy
	- cd smartkeyboard/server && go build -tags osusergo,netgo -o ../../bin/keyboard
	- cd smartkeyboard/client && go mod init keyboard.voidnet.tech
	- cd smartkeyboard/client && go mod tidy
	- cd smartkeyboard/client && go build -tags osusergo,netgo -o ../../bin/keyboard-client

test: tangle
	-cd smartkeyboard && go mod init keyboard.voidnet.tech
	-cd smartkeyboard && go mod tidy
	-cd smartkeyboard && go test -v ./...

all: weave tangle