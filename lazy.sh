#!/bin/bash


changes=$(git status --porcelain | awk '{print $2}' | head -n 3 | tr '\n' ' ')


branch=$(git rev-parse --abbrev-ref HEAD)


git add .

git commit -m "Auto-commit: updated $changes at $date +'%Y-%m-%d %H-%M-%S')"

git push origin "$branch"

