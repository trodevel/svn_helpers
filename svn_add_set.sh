#!/bin/sh

FILE="$*"

svn add $FILE
svn propget svn:keywords $FILE
svn propset svn:keywords "Author Date Id Revision" $FILE