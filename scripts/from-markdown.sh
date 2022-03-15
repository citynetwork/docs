#!/bin/bash
#
# from-markdown.sh — a wrapper script to convert Markdown to
# Pandoc-supported output formats

set -e

usage() {
    echo "Usage: $0 [-t format] [-o outfile] infile..." >&2
}

output="-"
format="docx"

while getopts "o:t:h" opt; do
    case "${opt}" in
        o)
            output=${OPTARG}
            ;;
        t)
            format=${OPTARG}
            ;;
        h)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done
shift $((OPTIND-1))

# Concatenate all input files and preprocess them with Jinja2, then
# feed the result to pandoc on stdin
tempmd=`mktemp --suffix .md`
cat $* > $tempmd
jinja2 $tempmd mkdocs.yml \
    | pandoc \
        --data-dir=pandoc \
        --no-highlight \
        -f gfm \
        -t ${format} \
        -o ${output} \
        -i -

# Clean up
rm $tempmd
