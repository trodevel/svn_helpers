#!/bin/bash

# print SVN log for a branch
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

# SKV 16c27

# 1.0 - 16c27 - initial commit
# 1.1 - 18627 - corrected handling of comments containing new lines

VER="1.1"

# http://stackoverflow.com/questions/3194534/joining-two-consecutive-lines-using-awk-or-sed

# https://stackoverflow.com/questions/15930960/remove-eols-and-spaces-between-two-tags-in-xml-files
# https://stackoverflow.com/a/15933785

x='msg'

svn up --depth=files; svn log --xml --stop-on-copy | sed -e '/<'"$x"'>/{:next;/<\/'"$x"'>/!{N;bnext;};s/\n//g;}' | grep -o "revision=\"[0-9]*\"\|<msg>.*</msg>" | sed -e "s/<[\/]*msg>//g" -e "s/revision=\"\([0-9]*\)\"/\1/" | awk '!(NR%2){print p " - " $0 }{p=$0}'

