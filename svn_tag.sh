#!/bin/bash

# create SVN tag automatically
#
# Copyright (C) 2017 Sergey Kolevatov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#

# SKV 17228

# 17228 - 1.0 - initial version

VER="1.0"

#<hb>#############################################################################
#
# create SVN tag automatically
#
# ./svn_tag.sh <path_to_folder> <tag_name> <comment>
#
# Example: ./svn_tag.sh externals/some_lib release_version "new release"
#
#<he>#############################################################################

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -b3-    #"
}


gl_res=""

source svn_tools_lib.sh

FOLDER=$1
TAG_NAME=$2
COMMENT=$3

[[ -z "$FOLDER" ]]      && { echo; echo "ERROR: FOLDER is not defined"; show_help; exit; }
[[ -z "$TAG_NAME" ]]    && { echo; echo "ERROR: TAG_NAME is not defined"; show_help; exit; }
[[ -z "$COMMENT" ]]     && { echo; echo "ERROR: COMMENT is not defined"; show_help; exit; }

[[ ! -d "$FOLDER" ]]    && { echo; echo "ERROR: folder '$FOLDER' doesn't exist"; show_help; exit; }


echo "folder      = $FOLDER"
echo "tag_name    = $TAG_NAME"
echo "comment     = $COMMENT"

GEN_COMMENT="$COMMENT"

echo "generated comment = $GEN_COMMENT"

get_svn_url "$FOLDER"

url="$gl_res"

if [ -z "$url" ]
then
    echo "ERROR: cannot get trunk URL for forlder '$FOLDER'"
    exit
fi

echo "svn path          = $url"

is_trunk $url
res=$?

if [ $res -eq 0 ]
then
    echo "ERROR: path '$url' is not a trunk"
    exit
fi

create_tag_url "$url" "$TAG_NAME"
new_url="$gl_res"

echo "tag path          = $new_url"

svn cp $url $new_url -m "$GEN_COMMENT"
