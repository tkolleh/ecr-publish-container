#
# Build and test container of Java applicaiton
#
FROM openjdk:12-jdk-oracle

LABEL maintainer="tkolleh@vitalnotes.com"
LABEL lang="java"
# Build tool (java, mvn, gradle, wrapper)
LABEL build-tool="wrapper"
LABEL registry="ecr"

ENV MAVEN_CLI_OPTS "-s .m2/settings.xml --batch-mode"
ENV MAVEN_OPTS "-Dmaven.repo.local=.m2/repository"

# Install the following packages
RUN yum upgrade && yum install yum-utils && yum-config-manager --enable *addons
RUN yum install -y python36 docker-engine nodejs curl unzip bash
RUN python3 -m ensurepip && pip3 install --upgrade pip setuptools && if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && rm -r /root/.cache
RUN yum install nodejs && npm install -g dockerlint

# Install AWS CLI
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

RUN mkdir /app

WORKDIR /app

#
# TODO Create two separate containers one for development and one for publish
#

# # Lint images
# RUN find ./ -name Dockerfile -exec dockerlint {} \;

# # Build and test app
# RUN ./mvnw $MAVEN_CLI_OPTS $MAVEN_OPTS compile
# # TODO Remove -DskipTests
# RUN ./mvnw $MAVEN_CLI_OPTS $MAVEN_OPTS package -DskipTests

# # Enable docker
# RUN systemctl start docker
# RUN systemctl enable docker

# # Publish image to registry
# RUN $(aws ecr get-login --no-include-email --region ${AWS_REGION})
# RUN docker build -t vitalnotes/vn-to-fhir:latest .
# RUN docker tag vitalnotes/vn-to-fhir:latest 048029308026.dkr.ecr.us-east-1.amazonaws.com/vitalnotes/vn-to-fhir:latest
# RUN docker push 048029308026.dkr.ecr.us-east-1.amazonaws.com/vitalnotes/vn-to-fhir:latest

# RUN aws ecs update-service --cluster vitalnotes-mobile-app --service vn-to-fhir-service --force-new-deployment

EXPOSE 8080/tcp

CMD ["/bin/bash"]
