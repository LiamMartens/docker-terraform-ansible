FROM alpine:3.7

# @arg terraform version
ARG TERRAFORM_VERSION=0.11.3
ARG USER=ops

# @run update and upgrade
RUN apk update && apk upgrade

# @run add unzip
RUN apk add python3 python3-dev unzip alpine-sdk libffi-dev openssl-dev && \
    ln -s /usr/bin/python3 /usr/bin/python

# @run install terraform
RUN curl -L "https://releases.hashicorp.com/terraform/0.11.3/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip && rm terraform.zip && mv terraform /usr/bin

# @run install ansible
RUN pip3 install ansible

# @run remove build packages
RUN apk del python3-dev alpine-sdk libffi-dev openssl-dev

# @run add devops user
RUN adduser -D ${USER}

# @user switch to ops user
USER ${USER}

# @workdir Set workdir to home
WORKDIR /home/${USER}

# @volume Define volume
VOLUME /home/${USER}

# @cmd define sh as defualt command
CMD [ "/bin/sh" ]