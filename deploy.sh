#!/bin/bash
set -euo pipefail

BUCKET="gs://artplan-wordcloud-1773759106"
FILES=("manifest.json" "myViz.js" "myViz.json")

echo "Uploading files to GCS..."
for file in "${FILES[@]}"; do
  gcloud storage cp "$file" "$BUCKET/$file"
done

echo "Setting public read access..."
# Grant allUsers objectViewer at the bucket level so all uploaded objects are
# publicly readable. Object-level add-iam-policy-binding requires a gs:// URL
# and cannot use local file paths.
gcloud storage buckets add-iam-policy-binding "$BUCKET" \
  --member=allUsers \
  --role=roles/storage.objectViewer

echo "Done. Files are publicly accessible at:"
for file in "${FILES[@]}"; do
  echo "  https://storage.googleapis.com/artplan-wordcloud-1773759106/$file"
done
