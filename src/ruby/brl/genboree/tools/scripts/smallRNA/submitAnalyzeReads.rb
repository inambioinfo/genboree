#!/usr/bin/env ruby

# Program for submitting analyzeReads.rb to the cluster

#Author: Sameer Paithankar

#Loading Libraries

require 'brl/util/textFileUtil'
require 'brl/util/util'

class SubmitAnalyzeReads
  
  attr_accessor :readsFile, :outputDir, :targetGenome, :kWeight, :maxMapping
  attr_accessor :scratch, :diagonals, :gap, :topPercent, :ignorePercent, :usableReads
  attr_accessor :nodes, :kspan, :refGenome, :basename, :lffFile, :readName
  
  def initialize(readsFile, outputDir, targetGenome, kWeight, refGenome, lffFile, maxMapping, scratch, diagonals, gap, topPercent, ignorePercent, nodes, kspan, usableReads)
  
    @readsFile = readsFile
    @refGenome = refGenome
    if(outputDir)
      @outputDir = outputDir
    else
      @outputDir = Dir.pwd
    end
    @readName = File.basename(@readsFile)
    @readName = @readName.split(".")
    @readName = readName[0]
    @targetGenome = targetGenome
    @lffFile = lffFile
    if(kWeight)
      @kWeight = kWeight.to_i
    else
      @kWeight = 11
    end
    
    if(maxMapping)
      @maxMapping = maxMapping.to_i
    else
      @maxMapping = 100
    end
    
    @scratch = scratch
    
    if(diagonals)
      @diagonals = diagonals.to_i
    else
      @diagonals = 100
    end
    
    if(gap)
      @gap = gap.to_i
    else
      @gap = 2
    end
    
    if(topPercent)
      @topPercent = topPercent.to_i
    else
      @topPercent = 1
    end
    
    if(ignorePercent)
      @ignorePercent = ignorePercent.to_i
    end
    
    if(nodes)
      @nodes = nodes.to_i
    else
      @nodes = 1
    end
    
    if(kspan)
      @kspan = kspan.to_i
    else
      @kspan = 11
    end
    
    @usableReads = usableReads
    puts @usableReads
      
    
    @baseName = File.basename(@readsFile)
    
    system("mkdir -p #{@outputDir}")
    
    submit()
      
  end
  
  def submit
    
    begin
    
    
      scriptName="submitAccountForMappings_job.pbs"	
      scriptFile = File.open("#{scriptName}", "w")
      scriptFile.puts "#!/bin/bash";
      scriptFile.puts "#PBS -q dque";
      scriptFile.puts "#PBS -l nodes=1:ppn=#{@nodes}\n";
      scriptFile.puts "#PBS -l walltime=24:00:00\n";
      scriptFile.puts "#PBS -l cput=24:00:00\n";
      #scriptFile.puts "#PBS -l ppn=1\n";
      scriptFile.puts "#PBS -M #{ENV["USER"]}\@bcm.tmc.edu\n";
      scriptFile.puts "#PBS -m ea\n";
      scriptFile.puts "#PBS -N submitAnalyzeReads.rb\n"
      scriptFile.puts "cd $PBS_O_WORKDIR\n\n"
      scriptFile.print "ruby analyzeReads.rb -r #{@readsFile} -o #{@outputDir} -t #{@targetGenome} -k #{@kWeight} "
      scriptFile.print "-R #{@refGenome} -L #{@lffFile} -n #{@maxMapping} -s . -d #{@diagonals} "
      scriptFile.print "-G #{@gap} -P #{@topPercent} -N #{@nodes} -l #{@kspan} -u #{@usableReads} \n\n"
      scriptFile.puts "sleep 2"
      scriptFile.close()
    
    # Submitting script on cluster
    
    command="qsub #{scriptName}"
   # system(command)
    
    
    rescue => err
        
      $stderr.puts "Details: #{err.message}"
      return -1
      
    end
  
  end
  
end


class RunScript

  VERSION_NUMBER="1.0"
  DEFAULTUSAGEINFO="
    
  Program description: # Program for submitting AnalyzingReads.rb to the cluster
  
  #Note : use . as scratch

  
        
     
  Mandatory Arguments: 
    
    -r  --readsFile  #reads file 
    -o  --outputDir #output directory
    -t  --targetGenome #reference genome
    -k  --kWeight #kmer weight (default 11)
    -R  --refGenome # chromosome offset file
    -L  --lffFile # lff File for intersection
    -n  --maxMapping  #[optional] maximum number of mappings within
                              top percent of best score  (default 100). Reads
                              with a larger number of mappings that this
                              value are discarded from mapping results
    -i  --ignorePercent #Ignore percentage default 95
    -s  --scratch # scratch directory
    -d  --diagonals #number of diagonals, default 100
    -G  --gap #gap, default 6
    -P  --topPercent  #[optional] top percent of mappings to be kept
                              (default 1)
    -N  --nodes # processors per node, default 11
    -l  --kspan # kmer length (default 11)
    -v  --version #Version of the program
    -u  --usableReads (Y|N) selected reads having lenght of >=10 and < =30
                              occur at least 4 times
                              ends up with A,T,G and C wiht streak of lenght <=9
    -h  --help #Display help 
    
    Usage: 
    
  "
  def self.printUsage(additionalInfo=nil)
      puts DEFAULTUSAGEINFO
      puts additionalInfo unless(additionalInfo.nil?)
      if(additionalInfo.nil?)
        exit(0)
      else
        exit(15)
      end
    end
    
  def self.printVersion()
    puts VERSION_NUMBER
    exit(0)
  end
    
  def self.parseArgs()
    methodName="performAnalyzeReads"
    optsArray=[
      ['--readsFile','-r',GetoptLong::REQUIRED_ARGUMENT],
      ['--outputDir','-o',GetoptLong::OPTIONAL_ARGUMENT],
      ['--targetGenome','-t',GetoptLong::REQUIRED_ARGUMENT],
      ['--kWeight','-k',GetoptLong::OPTIONAL_ARGUMENT],
      ['--refGenome','-R',GetoptLong::REQUIRED_ARGUMENT],
      ['--lffFile','-L',GetoptLong::OPTIONAL_ARGUMENT],
      ['--maxMapping','-n',GetoptLong::OPTIONAL_ARGUMENT],
      ['--ignorePercent','-i',GetoptLong::OPTIONAL_ARGUMENT],
      ['--scratch','-s',GetoptLong::REQUIRED_ARGUMENT],
      ['--diagonals','-d',GetoptLong::OPTIONAL_ARGUMENT],
      ['--gap','-G', GetoptLong::OPTIONAL_ARGUMENT],
      ['--topPercent','-P', GetoptLong::OPTIONAL_ARGUMENT],
      ['--nodes','-N', GetoptLong::OPTIONAL_ARGUMENT],
      ['--kspan','-l', GetoptLong::OPTIONAL_ARGUMENT],
      ['--version','-v',GetoptLong::NO_ARGUMENT],
      ['--usableReads' ,'-u', GetoptLong::REQUIRED_ARGUMENT],
      ['--help','-h',GetoptLong::NO_ARGUMENT],
    ]
    progOpts=GetoptLong.new(*optsArray)
    optsHash=progOpts.to_hash
    if(optsHash.key?('--help'))
      printUsage()
    elsif(optsHash.key?('--version'))
      printVersion()
    end
    printUsage("USAGE ERROR: some required arguments are missing") unless(progOpts.getMissingOptions().empty?)
    return optsHash
  end
    
  def self.performAnalyzeReads(optsHash)
    SubmitAnalyzeReads.new(optsHash['--readsFile'], optsHash['--outputDir'], optsHash['--targetGenome'], optsHash['--kWeight'], optsHash['--refGenome'], optsHash['--lffFile'], optsHash['--maxMapping'], optsHash['--scratch'], optsHash['--diagonals'], optsHash['--gap'], optsHash['--topPercent'], optsHash['--ignorePercent'], optsHash['--nodes'], optsHash['--kspan'], optsHash['--usableReads'])
  end
    
end


optsHash = RunScript.parseArgs()
RunScript.performAnalyzeReads(optsHash)
