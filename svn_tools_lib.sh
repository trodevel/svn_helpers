#!/bin/bash

# SVN tools
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

get_svn_url()
{
    local folder=$1

    local res=""

    res=$( LANG=C; svn info $folder | grep "^Relative URL:" | awk '{ print $2; }' )

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

is_trunk()
{
    local folder=$1

    local s=$( echo $folder | grep "/trunk/" )

    if [ -z "$s" ]
    then
        return 0
    fi

    return 1
}

create_branch_url()
{
    local folder=$1
    local branch_name=$2

    local s=$( echo $folder | sed "s#/trunk/#/branches/#" )

    s="$s/$branch_name"

    gl_res="$s"
}

create_tag_url()
{
    local folder=$1
    local tag_name=$2

    local s=$( echo $folder | sed "s#/trunk/#/tags/#" )

    s="$s/$tag_name"

    gl_res="$s"
}
