#colors:
B = \033[1;94m#   BLUE
G = \033[1;92m#   GREEN
Y = \033[1;93m#   YELLOW
R = \033[1;31m#   RED
M = \033[1;95m#   MAGENTA
K = \033[K#       ERASE END OF LINE
D = \033[0m#      DEFAULT
A = \007#         BEEP

APP=$(shell basename -s .git $(shell git remote get-url origin))
REGISTRY=gcr.io/devops-prom
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETARCH=amd64
TARGETOS=linux
BASEPATH=${REGISTRY}/${APP}:${VERSION}-${TARGETOS}-${TARGETARCH}

format: 
	gofmt -s -w ./

get:
	go get

lint:
	golint

test: 
	go test -v

build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/obezsmertnyi/kbot/cmd.appVersion=${VERSION}

image:
	@echo "$MBuilding image for Version: ${VERSION}, OS: ${TARGETOS}, Architecture: ${TARGETARCH}$D\n"
	docker build . -t ${BASEPATH} --build-arg TARGETOS=${TARGETOS} --build-arg TARGETARCH=${TARGETARCH}

linux: TARGETOS=linux
linux: image

windows: TARGETOS=windows
windows: image

macos: TARGETOS=darwin
macos: image

arm: TARGETARCH=arm64
arm: image

push:
	docker push ${BASEPATH}

clean: 
	rm -rf kbot
	@if docker images ${BASEPATH} -q | grep -q '.' ; then \
		docker rmi ${BASEPATH}; \
		else printf "$RImage not found$D\n"; \
	fi
