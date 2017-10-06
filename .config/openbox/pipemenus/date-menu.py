#!/usr/bin/env python3
#
# TIME-DATE written by Version Dependency
# A simple python script that creates an openbox pipemenu that displays time and date.
#
# This program is free software: you can redistribute it and/or modify it under the terms of
# the GNU General Public License version 3 as published by the Free Software Foundation.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see: http://www.gnu.org/licenses

# SETTINGS
 
import datetime

dt = datetime.datetime.now()
theDate = dt.strftime('%A, %B %d, %Y')
theTime = dt.strftime('%I:%M %p %Z')
theDay = dt.strftime('%j')
theWeek = dt.strftime('%U')

# OPENBOX PIPEMENU

print ('<?xml version=\"1.0\" encoding=\"UTF-8\"?>')
print ('<openbox_pipe_menu>')
print ('<separator />')
print ('<item label="DATE AND TIME" />')
print ('<separator />')
print ('<item label="'+theTime+'"/>')
print ('<item label="'+theDate+'"/>')
print ('<item label="'+'Day '+theDay+'"/>')
print ('<item label="'+'Week '+theWeek+'"/>')
print ('</openbox_pipe_menu>')
