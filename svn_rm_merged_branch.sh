#!/bin/bash

# remove SVN branch automatically
#
# Copyright (C) 2016 Sergey Kolevatov
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

# SKV 16c28

# 1.0 - 16c28 - initial commit
# 1.1 - 17c22 - bugfix for SVN version greater than 1.8

VER="1.0"

#<hb>#############################################################################
#
# remove SVN branch automatically
#
# ./svn_rm_merged_branch.sh <path_to_folder>
#
# Example: ./svn_rm_merged_branch.sh externals/some_lib
#
#<he>#############################################################################

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -b3-    #"
}


gl_res=""

get_svn_url()
{
    local folder=$1

    local res=""

    res=$( LANG=C; svn info $folder | grep "^Relative URL:" | awk '{ print $3; }' )

    if [ -n "$res" ]
    then
        gl_res="$res"
        return
    fi

    res=$( LANG=C; svn info $folder | grep "^URL:" | awk '{ print $2; }' )

    if [ -n "$res" ]
    then
        gl_res="$res"
        return
    fi

    gl_res="";
}

is_branch()
{
    local folder=$1

    local s=$( echo $folder | grep "/branches/" )

    if [ -z "$s" ]
    then
        return 0
    fi

    return 1
}

FOLDER=$1

[[ -z "$FOLDER" ]]      && { echo; echo "ERROR: FOLDER is not defined"; show_help; exit; }
[[ ! -d "$FOLDER" ]]    && { echo; echo "ERROR: folder '$FOLDER' doesn't exist"; show_help; exit; }


echo "folder            = $FOLDER"

GEN_COMMENT="removed branch. Reason: merged w/ trunk."

echo "generated comment = $GEN_COMMENT"

get_svn_url "$FOLDER"

url="$gl_res"

if [ -z "$url" ]
then
    echo "ERROR: cannot get SVN URL for forlder '$FOLDER'"
    exit
fi

echo "svn path          = $url"

is_branch $url
res=$?

if [ $res -eq 0 ]
then
    echo "ERROR: path '$url' is not a branch"
    exit
fi

svn rm $url -m "$GEN_COMMENT"
