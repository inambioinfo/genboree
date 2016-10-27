#!/usr/bin/env ruby
### No warning!
$VERBOSE = nil

# ##############################################################################
# PURPOSE
# ##############################################################################
# Simple: convert from UCSC Repeat Masker file to equivalent LFF version
# and output 1+ tracks

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

                ['--repeatMaskerFile', '-o', GetoptLong::REQUIRED_ARGUMENT],
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
  Convert from UCSC Repeat Masker file to equivalent LFF version.  

  COMMAND LINE ARGUMENTS:
    --trackName             | -t    => Track name for Repeat:Masker track.
                                       (type:subtype)
    --className             | -l    => Class name for Repeat:Masker track.
    --cDirectoryInput       | -i    => directory location of converting file 
    --fileToOutput          | -f    => converted file name
    --cDirectoryOutput      | -d    => directory location of converted file

    --repeatMaskerFile       | -o    => UCSC Repeat Masker file to convert
    --help                  | -h   => [optional flag] Output this usage
                                      info and exit.

  USAGE:
  i.e. BRL_UCSC_repeatMasker.rb -t 'Repeat:Masker'  -l 'Structural Variants' -i /users/ybai/work/Human_Project5/Repeat_Masker -f chr1_rmsk_LFF.txt -d /users/ybai/work/Human_Project5/Repeat_Masker -o chr1_rmsk.txt.gz
"
end

class MyConverter
  def initialize(inputsHash)
  end 
  def convert(inputsHash) 
    # Set the track type/subtype
    repeatMaskerFile = inputsHash['--repeatMaskerFile'].strip
    lffType, lffSubtype = inputsHash['--trackName'].strip.split(':')
    className = inputsHash['--className'].strip
    cDirectoryInput = inputsHash['--cDirectoryInput'].strip
    fileToOutput = inputsHash['--fileToOutput'].strip
    cDirectoryOutput = inputsHash['--cDirectoryOutput'].strip

    unless(File.size?("#{cDirectoryInput}/#{repeatMaskerFile}"))
      $stderr.puts "WARNING: the file '#{repeatMaskerFile}' is empty. Nothing to do."
      exit(FAILED)
    end

    # Set the track type/subtype
    lffType, lffSubtype = inputsHash['--trackName'].strip.split(':')

    # CONVERT cnpLocke TO LFF RECORDS USING WHAT WE HAVE SO FAR
    repeatMasker = Hash.new { |hh, kk| hh[kk] = 0 }

    # Open the file
    reader = BRL::Util::TextReader.new("#{cDirectoryInput}/#{repeatMaskerFile}")
    line = nil
    begin
      open("#{cDirectoryOutput}/#{fileToOutput}", 'w') do |f|
     # Go through each line
      reader.each { |line|
        next if(line =~ /^\s*#/ or line !~ /\S/)
        # Chop it up
        ff = line.chomp.split(/\t/)
        ff[1] = ff[1].to_i    #swScore
        ff[2] = ff[2].to_i      #milliDiv
        ff[3] = ff[3].to_i      #milliDel
        ff[4] = ff[4].to_i      #milliIns
        ff[5] = ff[5].to_sym      #geneName
        ff[6] = ff[6].to_i      #geneStart
        ff[7] = ff[7].to_i  #geneEnd
        ff[8] = ff[8].to_i  #geneLeft
        ff[9] = ff[9].to_sym  #strand
        ff[10].strip!  # name 
        repeatMasker[ff[10]] += 1
        ff[10] = ("#{ff[10]}.#{repeatMasker[ff[10]]}".to_sym) if(repeatMasker[ff[10]] > 1)
        ff[11] = ff[11].to_sym  #repClass
        ff[12] = ff[12].to_sym  #repFamily
        ff[13] = ff[13].to_i  #repStart
        ff[14] = ff[14].to_i  #repEnd
        ff[15] = ff[15].to_i  #repLeft
        ff[16] = ff[16].to_sym  #id
   
        # Dump each linked feature as LFF
        ### class, name, type, subtype, entry point(chr), start, stop, strand, phase, score, qStart, qStop, attri_comments, seq, free_comments
        f.print "#{className}\t#{ff[10]}\t#{lffType}\t#{lffSubtype}\t#{ff[5]}\t#{ff[6]+1}\t#{ff[7]}\t#{ff[9]}\t.\t1.0\t.\t.\t"
        ## attributes in order of useful information (in LFF anyway)
        f.print "swScore=#{ff[1]}; milliDiv=#{ff[2]}; milliDel=#{ff[3]}; milliIns=#{ff[4]}; geneLeft=#{ff[8]}; repClass=#{ff[11]}; repFamily=#{ff[12]}; repStart=#{ff[13]}; repEnd=#{ff[14]}; repLeft=#{ff[15]}; id=#{ff[16]}"
        # sequence (none)
        f.print "\t.\t"
        # summary (free form comments)
        f.print "."

        # done with record
        f.puts ""
      } # reader close
      reader.close
      end
    rescue => err
      $stderr.puts "ERROR: bad line found. Blank columns? Line num: #{reader.lineno}. Details: #{err.message}"
      $stderr.puts err.backtrace.join("\n")
      $stderr.puts "LINE: #{line.inspect}"
      exit(OK_WITH_ERRORS)
    end
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
