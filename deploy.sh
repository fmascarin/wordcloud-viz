#!/bin/bash
set -euo pipefail

BUCKET="gs://artplan-wordcloud-1773759106"
FILES=("manifest.json" "myViz.js" "myViz.json")

echo "Uploading files to GCS..."
for file in "${FILES[@]}"; do
  gcloud storage cp "$file" "$BUCKET/$file"
done

echo "Setting public read access..."
# roles/storage.objectViewer is a bucket-level role and cannot be applied to
# individual objects. Use roles/storage.legacyObjectReader for object-level IAM.
for file in "${FILES[@]}"; do
  gcloud storage objects add-iam-policy-binding "$BUCKET/$file" \
    --member=allUsers \
    --role=roles/storage.legacyObjectReader
done

echo "Done. Files are publicly accessible at:"
for file in "${FILES[@]}"; do
  echo "  https://storage.googleapis.com/artplan-wordcloud-1773759106/$file"
done
