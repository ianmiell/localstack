FROM localstack/java-maven-node-python

RUN pip install localstack
RUN chmod -R 777 /
CMD localstack start
