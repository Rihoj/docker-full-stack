#!/bin/sh
sleep 10
for i in $(echo $BUCKETS | tr "," "\n")
do
  # process
  aws --endpoint=http://$LOCALSTACK_HOST:4572 s3 mb s3://$i
done

for i in $(echo $QUEUES | tr "," "\n")
do
  # process
  aws --endpoint=http://$LOCALSTACK_HOST:4576 sqs create-queue --queue-name $i
done
