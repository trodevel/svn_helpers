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

# 1.0 - 17516 - initial commit
# 1.1 - 17b04 - added support of many branches

VER="1.1"

#<hb>#############################################################################
#
# switch branches to trunk in SVN externals
#
# ./svn_ext_swtt.sh <branch_top_name>[,<branch_top_name_2>[,...]]  <revision_in_trunk> <folder>
#
# Example: ./svn_ext_swtt.sh some_lib 123456 externals
#
#          ./svn_ext_swtt.sh some_lib,another_lib 123456 externals
#
#<he>#############################################################################

show_help()
{
    sed -e '1,/^#<hb>/d' -e '/^#<he>/,$d' $0 | cut -b3-    #"
}

switch_branch()
{
    local BRANCH_TOP=$1
    local EXT_FILE=$2
    local REV=$3

    local old_name=$( grep $BRANCH_TOP $EXT_FILE )

    sed -i "s~\s*\(.*\)\(/branches\)\(.*/$BRANCH_TOP\)\(/.*\) \(.*\)~-r $REV \1/trunk\3    \5~" $EXT_FILE

    local new_name=$( grep $BRANCH_TOP $EXT_FILE )

    echo "old name = $old_name"
    echo "new name = $new_name"
}

BRANCHES_TOP_CSV=$1
REV=$2
EXT_PATH=$3

[[ -z "$BRANCHES_TOP_CSV" ]] && { echo; echo "ERROR: BRANCHES_TOP is not defined"; show_help; exit; }
[[ -z "$REV" ]]              && { echo; echo "ERROR: REV is not defined"; show_help; exit; }
[[ -z "$EXT_PATH" ]]         && { echo; echo "ERROR: EXT_PATH is not defined"; show_help; exit; }

EXT_FILE=svn_${RANDOM}.txt

svn propget svn:externals $EXT_PATH > $EXT_FILE

BRANCHES_TOP=$( echo $BRANCHES_TOP_CSV | tr ',' ' ' )

for s in $BRANCHES_TOP
do
    switch_branch $s "$EXT_FILE" $REV
done

svn propset svn:externals $EXT_PATH -F $EXT_FILE

svn up $EXT_PATH
