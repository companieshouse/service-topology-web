#!/usr/bin/env bash

# Copy views
echo "Copying views to dist/views"
cp -r ./src/views ./dist/views
echo "Views copied to dist/views"

# Copy public
echo "Copying public to dist/public"
cp -r ./src/public ./dist/public
echo "Public copied to dist/public"
