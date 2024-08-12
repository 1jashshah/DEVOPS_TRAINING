#!/bin/bash

#Variables
URL="https://myapp.local/frontend"
REQUESTS=3000
CONCURRENCY=10

echo"SENDING TRAFFIC"
siege -c$CONCURRENT_USERS -r$REQUESTS $URL
