FROM ubuntu:latest
MAINTAINER janmir

ARG pass=password
ENV PASSWORD ${pass}

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y sudo \
	nano \
	ca-certificates \
	openssl \
	net-tools \
	git \
	locales \
	make \
	htop \
	curl \
	gnupg2 \
	build-essential

RUN locale-gen en_US.UTF-8

WORKDIR /root

# Install code-server
ADD https://github.com/cdr/code-server/releases/download/1.1119-vsc1.33.1/code-server1.1119-vsc1.33.1-linux-x64.tar.gz .
RUN tar -xvzf code-server1.1119-vsc1.33.1-linux-x64.tar.gz && \
	rm -f code-server1.1119-vsc1.33.1-linux-x64.tar.gz && \
	mv code-server1.1119-vsc1.33.1-linux-x64 code-server && \
	cd code-server && \
	chmod +x code-server

# install golang
ADD https://dl.google.com/go/go1.12.5.linux-amd64.tar.gz .
RUN tar -xvzf go1.12.5.linux-amd64.tar.gz && \
	rm -f go1.12.5.linux-amd64.tar.gz && \
	mv go /usr/local && \
	mkdir -p ${HOME}/go/src && \
	mkdir ${HOME}/go/bin
ENV GOROOT /usr/local/go
ENV	GOPATH ${HOME}/go
ENV PATH ${GOPATH}/bin:${GOROOT}/bin:${PATH}

# install google cloud cli
RUN CLOUD_SDK_REPO="cloud-sdk-$(grep VERSION_CODENAME /etc/os-release | cut -d '=' -f 2)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install google-cloud-sdk -y

#VOLUME ["/root/go/src"]
WORKDIR /root/go/src
EXPOSE 8443

CMD ["/root/code-server/code-server", "-d", "/root/go/src/codeserver/data", "-e", "/root/go/src/codeserver/ext", "-p", "8443"]