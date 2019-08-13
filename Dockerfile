#
# Publish images to ECR repositories
#
FROM tkolleh/java-dev-base-container:latest

LABEL maintainer="http://kolleh.com"
LABEL registry="ecr"

# Install AWS CLI
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

WORKDIR /app

# Publish image to registry
RUN $(aws ecr get-login --no-include-email --region ${AWS_REGION})
RUN docker build -t $IMAGE_NAME .
RUN docker tag $IMAGE_NAME $ECR_SERVICE_HOST/$IMAGE_NAME
RUN docker push $ECR_SERVICE_HOST/$IMAGE_NAME

CMD ["/bin/bash"]
