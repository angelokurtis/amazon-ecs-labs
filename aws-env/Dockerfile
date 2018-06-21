FROM python:3-jessie

RUN apt-get -y update && \
    apt-get install -y libgdbm-dev libncurses5-dev automake libtool bison libffi-dev jq

RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - && \
    curl -sSL https://get.rvm.io | bash -s stable

RUN echo 'export PATH=~/.local/bin:$PATH' >> /root/.bashrc && \
    pip install awscli --upgrade --user && \
    curl -o /usr/local/bin/ecs-cli https://s3.amazonaws.com/amazon-ecs-cli/ecs-cli-linux-amd64-latest && \
    chmod +x /usr/local/bin/ecs-cli && \
    mkdir /home/aws-solutions

WORKDIR /home/aws-env

CMD ["bash"]