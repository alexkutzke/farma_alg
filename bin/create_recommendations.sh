#!/bin/bash

cd /home/alex/dev/farma-alg/current
echo "aaaaa" > /tmp/a
rails runner "Recommender::create_recommendations 0.3"