
			       Find2.rb

                          Motoyuki Kasahara
                         (m-kasahr@sra.co.jp)


Copyright 1998, 2001  Motoyuki Kasahara

Permission is granted to make and distribute verbatim copies of
this manual provided the copyright notice and this permission notice
are preserved on all copies.

Permission is granted to copy and distribute modified versions of this
manual under the conditions for verbatim copying, provided that the entire
resulting derived work is distributed under the terms of a permission
notice identical to this one.

Permission is granted to copy and distribute translations of this manual
into another language, under the above conditions for modified versions,
except that this permission notice may be stated in a translation approved
by Free Software Foundation, Inc.


Introduction
============
`Find2.rb' is a Ruby library that recursively traverse a file tree
like the `find' command on UNIX.  This library runs on Ruby version
1.6 and later versions.

This is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 2, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.


Comparison with `find.rb'
=========================
`Find2.rb' is similar to `find.rb' which is distributed with Ruby, but
`Find2.rb' has following advantages against `find.rb'.

  * supports `-follow' option
    follows symbolic link.

  * supports `-depth' option
    all entires in a sub-directory are examined before the
    sub-directory itself.    

  * supports `-xdev' option
    doesn't descend directories on other file systems.

  * privides the `find2' method
    Both filename and File::Stat of the found entry are passed to an
    iteration block.


Details about the `Find2' class
===============================

Super Class
-----------
Object


Class Methods
-------------
find(filename...)
find(options, filename...)
find(filename...) {|name| ...}
find(options, filename...) {|name| ...}
    Recursively traverse a file tree for each `filename' listed.

    If a block is not given (i.e. 1st and 2nd forms), this method
    returns a list of found  filenames as an Array object.  Otherwise
    (i.e. 3rd and 4th forms), the method evaluates the block for each
    found entry.  The value of `name' is filename of the found entry.

    If first argument is Hash object (i.e. 2nd and 4th forms), `find'
    recognizes it as options.  The possible keys for the hash are:

    `follow'
	If its value is `true', the `find' method follows symbolic
	links.
    `depth'
	If its value is `true', the method examines all entires in a
	sub-directory before the sub-directory itself.
    `xdev'
	If its value is `true', the method doesn't descend directories
	on other file systems.

find2(filename...)
find2(options, filename...)
find2(filename...) {|name, stat| ...}
find2(options, filename...) {|name, stat| ...}
    This method is very similar to `find', but also passes the `stat'
    argument to a block.  `stat' is File::Stat object which is status
    of the found entry.

    If block is not given (i.e. 1st and 2nd forms), there is no
    difference between `find' and `find2'.

prune
    If the method is called in a block passed to the `find' or `find2'
    method, `find' or `find2' doesn't examine any entires in the
    visited directory.


Examples
--------
    $list = Find2.find("/usr/local", "/usr/X11")
    $list = Find2.find2("/usr/local", "/usr/X11")

    $list = Find2.find({"follow" => true, "depth" => true}, "/usr")
    $list = Find2.find2("follow" => true, "depth" => true, "/usr")

    Find2.find({"xdev" => true}, "/opt", "/prj") do |name|
        print "#{name}\n"
    end

    Find2.find2({"xdev" => true}, "/opt", "/prj") do |name, stat|
        print "#{name}\n" if stat.directory?
    end
