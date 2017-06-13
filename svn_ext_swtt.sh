#!/bin/bash

# switch branch to trunk in SVN externals
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

# SKV 17516

VER="1.0"

#<hb>#############################################################################
#
# switch branch to trunk in SVN externals
#
# ./svn_ext_swtt.sh <branch_top_name> <revision_in_trunk> <folder>
#
# Example: ./svn_ext_swtt.sh some_lib 123456 externals
#
#<he>#############################################################################

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -b3-    #"
}

BRANCH_TOP=$1
REV=$2
EXT_PATH=$3

[[ -z "$BRANCH_TOP" ]] && { echo; echo "ERROR: BRANCH_TOP is not defined"; show_help; exit; }
[[ -z "$REV" ]]        && { echo; echo "ERROR: REV is not defined"; show_help; exit; }
[[ -z "$EXT_PATH" ]]   && { echo; echo "ERROR: EXT_PATH is not defined"; show_help; exit; }

EXT_FILE=svn_${RANDOM}.txt

svn propget svn:externals $EXT_PATH > $EXT_FILE

old_name=$( grep $BRANCH_TOP $EXT_FILE )

sed -i "s~\s*\(.*\)\(/branches\)\(.*/$BRANCH_TOP\)\(/.*\) \(.*\)~-r $REV \1/trunk\3    \5~" $EXT_FILE

new_name=$( grep $BRANCH_TOP $EXT_FILE )

echo "old name = $old_name"
echo "new name = $new_name"

svn propset svn:externals $EXT_PATH -F $EXT_FILE

svn up $EXT_PATH
