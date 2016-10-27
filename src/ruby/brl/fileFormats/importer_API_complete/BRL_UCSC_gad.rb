#!/usr/bin/env ruby
### No warning!
$VERBOSE = nil

# ##############################################################################
# PURPOSE
# ##############################################################################
# Simple: convert from UCSC GAD files (Genetic Association Studies of Complex Diseases and Disorders) to equivalent LFF version

# ##############################################################################
# REQUIRED LIBRARIES
# ##############################################################################
require 'brl/util/textFileUtil'
require 'brl/util/util'
require 'brl/genboree/genboreeUtil'

# ##############################################################################
# CONSTANTS
# ##############################################################################
FATAL = BRL::Genboree::FATAL
OK = BRL::Genboree::OK
OK_WITH_ERRORS = BRL::Genboree::OK_WITH_ERRORS
FAILED = BRL::Genboree::FAILED
USAGE_ERR = BRL::Genboree::USAGE_ERR

# ##############################################################################
# HELPER FUNCTIONS AND CLASS
# ##############################################################################

def processArguments()
  optsArray = [
                ['--trackName', '-t', GetoptLong::REQUIRED_ARGUMENT],
                ['--className', '-l', GetoptLong::REQUIRED_ARGUMENT],
                ['--cDirectoryInput', '-i', GetoptLong::REQUIRED_ARGUMENT],
                ['--fileToOutput', '-f', GetoptLong::REQUIRED_ARGUMENT],
                ['--cDirectoryOutput', '-d', GetoptLong::REQUIRED_ARGUMENT],
                ['--gadFile', '-o', GetoptLong::REQUIRED_ARGUMENT],
                ['--help', '-h', GetoptLong::NO_ARGUMENT]
              ]
  progOpts = GetoptLong.new(*optsArray)
  optsHash = progOpts.to_hash
  # Try to use getMissingOptions() from Ruby's standard GetoptLong class
  optsMissing = progOpts.getMissingOptions()
  # If no argument given or request help information, just print usage...
  if(optsHash.empty? or optsHash.key?('--help'))
    usage()
    exit(USAGE_ERR)
  # If there is NOT any required argument file missing, then return an empty array; otherwise, report error
  elsif(optsMissing.length != 0)
    usage("Error: the REQUIRED args are missing!")
    exit(USAGE_ERR)
  else
    return optsHash
  end
end

def usage(msg='')
  puts "\n#{msg}\n" unless(msg.empty?)
  puts "

PROGRAM DESCRIPTION:
  Convert from UCSC gad file (Genetic Association Studies of Complex Diseases and Disorders) to equivalent LFF version.  

  COMMAND LINE ARGUMENTS:
    --trackName             | -t    => Track name for DIS:GAD track.
                                       (type:subtype)
    --className             | -l    => Class name for DIS:GAD track.
    --cDirectoryInput       | -i    => directory location of converting file 
    --fileToOutput          | -f    => converted file name
    --cDirectoryOutput      | -d    => directory location of converted file
    --gadFile               | -o    => UCSC gad file to convert
    --help                  | -h   => [optional flag] Output this usage
                                      info and exit.

  USAGE:
  i.e. BRL_UCSC_gad.rb -t DIS:GAD -l 'Phenotype Disease Ass' -i /users/ybai/work/Project3/DIS_GAD -f DIS_GAD_LFF.txt -d /users/ybai/work/Project3/DIS_GAD -o gad.txt.gz 
"
end

class MyConverter
  def initialize(inputsHash)
  end 
  def convert(inputsHash) 
    # Set the track type/subtype
    lffType, lffSubtype = inputsHash['--trackName'].strip.split(':')
    className = inputsHash['--className'].strip
    cDirectoryInput = inputsHash['--cDirectoryInput'].strip
    fileToOutput = inputsHash['--fileToOutput'].strip
    cDirectoryOutput = inputsHash['--cDirectoryOutput'].strip

    open("#{cDirectoryOutput}/#{fileToOutput}", 'w') do |f|
      gadFile = inputsHash['--gadFile'].strip
      unless(File.size?("#{cDirectoryInput}/#{gadFile}"))
        $stderr.puts "WARNING: the file '#{gadFile}' is empty. Nothing to do."
        exit(FAILED)
      end
      # CONVERT  TO LFF RECORDS USING WHAT WE HAVE SO FAR
      gad = Hash.new { |hh, kk| hh[kk] = 0 }
      # Open the file
      reader = BRL::Util::TextReader.new("#{cDirectoryInput}/#{gadFile}")
      line = nil
      begin
        # Go through each line
        reader.each { |line|
          next if(line =~ /^\s*#/ or line !~ /\S/)
          #chrom_info = []
          # Chop it up
          # chrom chromStart val 
          ff = line.chomp.split(/\t/)
          ff[0] = ff[0].to_sym    #chrom
          ff[1] = ff[1].to_i      #chromStart
          ff[2] = ff[2].to_i      #chromEnd
          ff[3] = ff[3].to_sym    #name
          gad[ff[3]] += 1
          ff[3] = ("#{ff[3]}.#{gad[ff[3]]}".to_sym) if(gad[ff[3]] > 1)
          # Dump each linked feature as LFF
          ### class, name, type, subtype, entry point(chr), start, stop, strand, phase, score, qStart, qStop, attri_comments, seq, free_comments
          f.print "#{className}\t#{ff[3]}\t#{lffType}\t#{lffSubtype}\t#{ff[0]}\t#{ff[1]}\t#{ff[2]}\t+\t.\t1.0\t.\t.\t"
          # attributes in order of useful information (in LFF anyway)
          ### attri_comments
          f.print "."
          # sequence (none)
          f.print "\t.\t"
          # summary (free form comments)
          f.print "."

          # done with record
          f.puts ""
        } # reader close
        reader.close
      rescue => err
        $stderr.puts "ERROR: bad line found. Blank columns? Line num: #{reader.lineno}. Details: #{err.message}"
        $stderr.puts err.backtrace.join("\n")
        $stderr.puts "LINE: #{line.inspect}"
        exit(OK_WITH_ERRORS)
      end #begin
    end #open
  end
end


# ##############################################################################
# MAIN
# ##############################################################################
$stderr.puts "#{Time.now} BEGIN (Mem: #{BRL::Util::MemoryInfo.getMemUsageStr()})"
begin
  optsHash = processArguments()
  converter = MyConverter.new(optsHash)
  converter.convert(optsHash)
  $stderr.puts "#{Time.now} DONE"
  exit(OK)
rescue => err
  $stderr.puts "Error occurs... Details: #{err.message}"
  $stderr.puts err.backtrace.join("\n")
  exit(FATAL)
end
