#!/usr/bin/ruby

require 'rubygems'
require 'trollop'
require 'bio'


class FastaFileManipulate

  def initialize(file)
    @fpath = file
  end

  def open
    Bio::FlatFile.open(Bio::FastaFormat, @fpath).each do |fas|
      yield fas
    end

  end

  def show_descriptions
    open do |fas|
      puts fas.definition
    end
  end

  def show_ids
    open do |fas|
      puts fas.definition.split[0]
    end
  end

  def show_length
    open do |fas|
      puts [fas.definition.split[0], fas.seq.size].join("\t")
    end
  end

  def count_entries
    n = 0
    open do |fas|
      n += 1
    end
    n
  end

  def count_total_bases
    n = 0
    open do |fas|
      n += fas.seq.length
    end
    n
  end

  def translate
    open do |fas|
      nuc = Bio::Sequence::NA.new(fas.seq)
      pep = nuc.translate
      puts pep.to_fasta(fas.definition, 60)
    end
  end

  def filter(conditions={})
    passed = false
    minlen = conditions[:minlen]
    maxlen = conditions[:maxlen]
    open do |fas|
      passed = true if minlen && fas.length >= minlen
      puts fas if passed
    end
  end

end


SUB_COMMANDS = %w{desc ids length count countnuc translate filter}

global_opts = Trollop::options do
  banner "fast is a toolbox to manipulate maltifasta file"
  opt :quiet, "quiet mode", :short => "-q"
  stop_on SUB_COMMANDS
end

cmd = ARGV.shift


## Parse subcommand options
cmd_opts = case cmd
when "desc"
  Trollop::options do   
  end
when "ids"
  Trollop::options do
  end
when "length"
  Trollop::options do
  end
when "count"
  Trollop::options do
  end
when "countnuc"
  Trollop::options do
 #   puts ffm.count_total_bases
  end
when "translate"
  Trollop::options do 
  end
when "filter"
  Trollop::options do
    opt :minlen, "min length to show", :type => :integer 
  end
else
end


=begin
## for debugging use
puts "Global options: #{global_opts.inspect}"
puts "Subcommand: #{cmd.inspect}"
puts "Subcommand options: #{cmd_opts.inspect}"
puts "Remaining arguments: #{ARGV.inspect}"
=end

case cmd
when "desc"
  ffm = FastaFileManipulate.new(ARGV.shift)
  ffm.show_descriptions
when "ids"
  ffm = FastaFileManipulate.new(ARGV.shift)
  ffm.show_ids
when "length"
  ffm = FastaFileManipulate.new(ARGV.shift)
  ffm.show_length
when "translate"
  ffm = FastaFileManipulate.new(ARGV.shift)
  ffm.translate
when "count"
  ffm = FastaFileManipulate.new(ARGV.shift)
  puts ffm.count_entries
when "countnuc"
  ffm = FastaFileManipulate.new(ARGV.shift)
  puts ffm.count_total_bases
when "filter"
  ffm = FastaFileManipulate.new(ARGV.shift)
  ffm.filter({:minlen => cmd_opts[:minlen]})
else
end
