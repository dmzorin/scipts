#!/bin/bash

echo ""

tf_sa=$(gcloud iam service-accounts list --format="table(EMAIL)" | grep tf)

echo $tf_sa


echo ""

project_sa=$(gcloud iam service-accounts list --format="table(EMAIL)" | grep project)

echo $project_sa


echo ""

buckets=( $(gsutil ls) )

echo "${buckets[@]}" | tr ' ' '\n'


echo ""

#dry-run

for i in "${buckets[@]}"; do echo "$i";gsutil iam get "$i";echo ""; done

#change Cloud IAM policy for bucket

#for i in "${buckets[@]}"; do echo "$i";gsutil -i "$tf_sa" iam ch serviceAccount:"$project_sa":roles/storage.objectViewer "$i";echo ""; done