FROM localstack/java-maven-node-python

RUN pip install localstack
CMD localstack start
