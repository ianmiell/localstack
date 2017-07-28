FROM localstack/java-maven-node-python

MAINTAINER Waldemar Hummer (waldemar.hummer@gmail.com)
LABEL authors="Waldemar Hummer (waldemar.hummer@gmail.com), Gianluca Bortoli (giallogiallo93@gmail.com)"

# add files required to run "make install"
ADD Makefile requirements.txt ./
RUN mkdir -p localstack/utils/kinesis/ && touch localstack/__init__.py localstack/utils/__init__.py localstack/utils/kinesis/__init__.py
ADD localstack/constants.py localstack/config.py localstack/
ADD localstack/utils/compat.py localstack/utils/common.py localstack/utils/
ADD localstack/utils/kinesis/ localstack/utils/kinesis/
ADD localstack/ext/ localstack/ext/

# install dependencies
RUN make install

# add files required to run "make init"
ADD localstack/package.json localstack/package.json
ADD localstack/services/__init__.py localstack/services/install.py localstack/services/

# initialize installation (downloads remaining dependencies)
RUN make init

# add rest of the code
ADD localstack/ localstack/
ADD bin/localstack bin/localstack

# fix some permissions and create local user
RUN mkdir -p /.npm && \
    mkdir -p localstack/infra/elasticsearch/data && \
    mkdir -p localstack/infra/elasticsearch/logs && \
    chmod 777 . && \
    chmod 755 /root && \
    chmod -R 777 /.npm && \
    chmod -R 777 localstack/infra/elasticsearch/config && \
    chmod -R 777 localstack/infra/elasticsearch/data && \
    chmod -R 777 localstack/infra/elasticsearch/logs && \
    chmod -R 777 /tmp/localstack && \
    chown -R `id -un`:`id -gn` . && \
    adduser -D localstack && \
    ln -s `pwd` /tmp/localstack_install_dir

# expose default environment (required for aws-cli to work)
ENV AWS_ACCESS_KEY_ID=foobar \
    AWS_SECRET_ACCESS_KEY=foobar \
    AWS_DEFAULT_REGION=us-east-1 \
    MAVEN_CONFIG=/opt/code/localstack \
    USER=localstack

# expose service & web dashboard ports
EXPOSE 4567
EXPOSE 4568
EXPOSE 4569
EXPOSE 4570
EXPOSE 4570
EXPOSE 4571
EXPOSE 4572
EXPOSE 4573
EXPOSE 4574
EXPOSE 4575
EXPOSE 4576
EXPOSE 4577
EXPOSE 4578
EXPOSE 4579
EXPOSE 4580
EXPOSE 4581
EXPOSE 4582
EXPOSE 8080

# install supervisor daemon & copy config file
ADD bin/supervisord.conf /etc/supervisord.conf

# define command at startup
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

# run tests (to verify the build before pushing the image)
ADD tests/ tests/
RUN make test
