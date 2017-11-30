FROM node:8.2.1

RUN apt-get update && apt-get install jq
COPY test.sh /test.sh

ENTRYPOINT "/test.sh"
