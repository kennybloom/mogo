#                                                         -*- Ruby -*-
# Copyright (C) 1998, 2001  Motoyuki Kasahara
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#

#
# Traverse a file tree, replacement of `find.rb'.
#
class Find2
  #
  # Constatnts
  #
  FIND1 = 1
  FIND2 = 2

  #
  # Initializer.
  #
  def initialize(mode = FIND1)
    @mode   = mode
    @depth  = false
    @follow = false
    @xdev   = false

    @dirname_stats = Array.new
    @found_files = Array.new
    @target_device = 0
  end

  #
  # Methods for accessing instances.
  #
  attr :depth
  attr :follow
  attr :xdev

  #
  # Find the directory `dirname'. (private)
  #
  def find(*arguments, &block)
    #
    # Parse options if specified.
    #
    if arguments[0].class == Hash
      parse_options(arguments.shift)
    end

    #
    # If a block is not given to the `find' method, found files are
    # recorded in this array.
    #
    @dirname_stats.clear
    @found_files.clear

    #
    # Loop for each file in `files'.
    #
    arguments.each do |file|
      catch(:prune) do
	@dirname_stats.clear

	#
	# Get `stat' or `lstat' of `file'.
	#
	begin
	  if @follow
	    begin
	      stat_result = File.stat(file)
	    rescue Errno::ENOENT, Errno::EACCES
	      stat_result = File.lstat(file)
	    end
	  else
	    stat_result = File.lstat(file)
	  end
	rescue Errno::ENOENT, Errno::EACCES
	  next
	end

	#
	# Push `file' to the found stack, or yield with it,
	# if the depth flag is enabled.
	#
	if !@depth
	  if block == nil
	    @found_files.push(file)
	  elsif @mode == FIND1
	    block.call(file)
	  else
	    block.call(file, stat_result)
	  end
	end

	#
	# If `file' is a directory, find files recursively.
	#
	if stat_result.directory?
	  @xdev_device = stat_result.dev if @xdev
	  @dirname_stats.push(stat_result)
	  find_directory(file, block)
	end

	#
	# Push `file' to the found stack, or yield with it.
	# if the depth flag is disabled.
	#
	if @depth
	  if block == nil
	    @found_files.push(file)
	  elsif @mode == FIND1
	    block.call(file)
	  else
	    block.call(file, stat_result)
	  end
	end
      end

      if block == nil
	return @found_files
      else
	return nil
      end
    end
  end

  #
  # Find the directory `dirname'. (private)
  #
  def find_directory(dirname, block)
    #
    # Open the directory `dirname'.
    #
    begin
      dir = Dir.open(dirname)
    rescue
      return
    end

    #
    # Read all directory entries except for `.' and `..'.
    #
    entries = Array.new
    loop do
      begin
	entry = dir.read
      rescue
	break
      end
      break if entry == nil
      next if entry == '.' || entry == '..'
      entries.push(entry)
    end

    #
    # Close `dir'.
    #
    dir.close

    #
    # Loop for each entry in this directory.
    #
    catch(:prune) do
      entries.each do |entry|
	#
	# Set `entry_path' to the full path of `entry'.
	#
	if dirname[-1, 1] == File::Separator
	  entry_path = dirname + entry
	else
	  entry_path = dirname + File::Separator + entry
	end

	#
	# Get `stat' or `lstat' of `entry_path'.
	#
	begin
	  if @follow
	    begin
	      stat_result = File.stat(entry_path)
	    rescue Errno::ENOENT, Errno::EACCES
	      stat_result = File.lstat(entry_path)
	    end
	  else
	    stat_result = File.lstat(entry_path)
	  end
	rescue Errno::ENOENT, Errno::EACCES
	  next
	end

	#
	# Push `entry_path' to the found stack, or yield with it,
	# if the depth flag is enabled.
	#
	if !@depth
	  if block == nil
	    @found_files.push(entry_path)
	  elsif @mode == FIND1
	    block.call(entry_path)
	  else
	    block.call(entry_path, stat_result)
	  end
	end

	#
	# If `entry_path' is a directory, find recursively.
	#
	if stat_result.directory? \
	  && (!@xdev || @xdev_device == stat_result.dev) \
	  && (!@follow || !visited?(stat_result))
	  @dirname_stats.push(stat_result)
	  find_directory(entry_path, block)
	  @dirname_stats.pop
	end

	#
	# Push `entry_path' to the found stack, or yield with it,
	# if the depth flag is disabled.
	#
	if @depth
	  if block == nil
	    @found_files.push(entry_path)
	  elsif @mode == FIND1
	    block.call(entry_path)
	  else
	    block.call(entry_path, stat_result)
	  end
	end
      end
    end
  end
  private :find_directory

  #
  # Find the directory `dirname'. (class method)
  #
  def Find2.find(*arguments, &block)
    Find2.new.find(*arguments, &block)
  end

  #
  # Find the directory `dirname'. (class method)
  #
  def Find2.find2(*arguments, &block)
    Find2.new(FIND2).find(*arguments, &block)
  end

  #
  # Parse options.
  #
  def parse_options(options)
    return if options == nil

    options.each_pair do |key, value|
      case key
      when 'depth'
	@depth = value
      when 'follow'
	@follow = value
      when 'xdev'
	@xdev = value
      else
	raise ArgumentError, "unknown option - #{key}"
      end
    end
  end
  private :parse_options

  #
  # Prune the current visited directory.
  #
  def Find2.prune
    throw :prune
  end

  #
  # Did we visit the directory with the resouce `stat'? (private)
  #
  def visited?(stat_result)
    dev = stat_result.dev
    ino = stat_result.ino
    @dirname_stats.each do |i|
      return TRUE if i.dev == dev && i.ino == ino
    end
    return FALSE
  end
  private :visited?
end
