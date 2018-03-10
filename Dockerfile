FROM alpine:3.7 as builder

# @arg terraform version
ARG TERRAFORM_VERSION=0.11.3

# @run update and upgrade
RUN apk update && apk upgrade

# @run add unzip
RUN apk add python3 python3-dev unzip alpine-sdk libffi-dev openssl-dev && \
    ln -s /usr/bin/python3 /usr/bin/python

# @run install terraform
RUN curl -L "https://releases.hashicorp.com/terraform/0.11.3/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o terraform.zip && \
    unzip terraform.zip && rm terraform.zip

# @run install ansible
RUN pip3 install ansible



# @from actual image
FROM alpine:3.7

# @arg define user
ARG USER=ops

# @run add python3
RUN apk add --update python3

# @copy terraform
COPY --from=builder /terraform /usr/bin/terraform

# @copy ansible
COPY --from=builder /usr/bin/ansible* /usr/bin/

# @add localhost to ansible hosts
RUN mkdir /etc/ansible && \
    echo "[local]" > /etc/ansible/hosts && \
    echo "localhost     ansible_connection=local" >> /etc/ansible/hosts

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