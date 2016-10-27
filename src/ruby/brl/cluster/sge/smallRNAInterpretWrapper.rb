#!/usr/bin/env ruby

##############################################################################
# LIBRARIES
# - The first 3 are standard for all apps.
###############################################################################
#require 'brl/genboree/genboreeUtil'
require 'cgi'
require 'socket'
require 'fileutils'
require 'brl/util/util'
require 'brl/genboree/dbUtil'
require 'brl/cluster/clusterJob'
require 'brl/cluster/clusterJobUtils'
require 'brl/cluster/clusterJobRunner'

module BRL
module Cluster
  # == Overview
  # This ruby script is to be used as a wrapper to run the pash program on a cluster. It can be invoked from galaxy or any other programmatic context.
  # This script accepts command line arguments and flags that allow full specification of all aspects of the pash job to be run on the cluster

  class SmallRNAInterpretWrapper
    
    def initialize(optsHash)
      @optsHash = optsHash
      @sriwCommandString = ""
      @pashCommandString = ""
      @genomeName = ""
      @inputFileString = ""
      @outputDirString = ""
      @schedulerCommandString = ""
      @notificationEmail = ""
      setParameters()
    end

    def setParameters()
     
      
      genbConf = BRL::Genboree::GenboreeConfig.load()      
      @sriwCommandString = "smallRnaInterpretGalaxy.rb "
      readsFile = @optsHash['--readsFile']      
      readsFileName = readsFile.split(/\//).last
      @sriwCommandString += " -p ./#{readsFileName} "
      @genomeName = @optsHash['--genomeName']      
      genomeDir = genbConf.genomeFilesDir+@genomeName.to_s
      @sriwCommandString += " -d #{genomeDir} "
      @sriwCommandString += " -e #{@optsHash['--feature']} "
      
      fh = File.open("/tmp/galaxy.log","w")
      
      localHostName = Socket.gethostname
      outputFile = @optsHash['--outputFile']
      outputDirName = outputFile.split(/\//).slice(0..-2).join("/")+"/"
      outputFileName = outputFile.split(/\//).last
      @sriwCommandString += " -o ./#{outputFileName} "
      @sriwCommandString += " -s . "
      
      @outputDirString += localHostName.to_s+":"+outputDirName
      @outputDirString = CGI.escape(@outputDirString)
      
      @inputFileString += localHostName.to_s+":"+readsFile
      @inputFileString = CGI.escape(@inputFileString)      

      @clusterJobCommandString = CGI.escape(@sriwCommandString)      
      @clusterJobCommandString += ","+CGI.escape("rm ./#{readsFileName}")      
      
      fh.puts @sriwCommandString
      fh.puts @clusterJobCommandString
      
      @clusterJobCommandString = CGI.escape(@clusterJobCommandString)
      
      @notificationEmail = @optsHash['--email']
      
      @schedulerCommandString+="ruby #{genbConf.schedulerExecutable} "
      @schedulerCommandString+="-e #{@notificationEmail} "
      @schedulerCommandString+="-c #{@clusterJobCommandString} "
      @schedulerCommandString+="-i #{@inputFileString} "
      @schedulerCommandString+="-o #{@outputDirString} "
      @schedulerCommandString+="-r #{genbConf.rnaSeqResourceFlag}=1 "
      if(genbConf.retainRNASeqDir=="yes" or genbConf.retainRNASeqDir=="true")
        @schedulerCommandString+="-k "
      end      
      fh.puts @schedulerCommandString
      fh.close
    end
    
    def work()
      system(@schedulerCommandString)
    end
    
    def SmallRNAInterpretWrapper.processArguments()
      optsArray = [['--genomeName','-g', GetoptLong::REQUIRED_ARGUMENT],
                  ['--readsFile','-r', GetoptLong::REQUIRED_ARGUMENT],
                  ['--outputFile','-o', GetoptLong::REQUIRED_ARGUMENT],
                  ['--email', '-e', GetoptLong::REQUIRED_ARGUMENT],
                  ['--feature', '-f', GetoptLong::REQUIRED_ARGUMENT],
                  ['--help','-H', GetoptLong::NO_ARGUMENT]
                  ]

      progOpts = GetoptLong.new(*optsArray)
      optsHash = progOpts.to_hash
      if(optsHash.key?('--help')) then
        SmallRNAInterpretWrapperWrapper.usage()        
      end

      unless(progOpts.getMissingOptions().empty?)
        SmallRNAInterpretWrapper.usage("USAGE ERROR: some required arguments are missing")        
      end
      if(optsHash.empty?) then
        SmallRNAInterpretWrapperWrapper.usage()        
      end
      return optsHash
    end

    def SmallRNAInterpretWrapper.usage(msg='')
      unless(msg.empty?)
        puts "\n#{msg}\n"
      end
      puts "PROGRAM DESCRIPTION:
          This ruby script is to be used as a wrapper to run the pash program on a cluster. It can be invoked from galaxy or any other programmatic context.
          This script accepts command line arguments and flags that allow full specification of all aspects of the pash job to be run on the cluster          
            
          COMMAND LINE ARGUMENTS:
            -g or --genomeName  => This flag is required and indicates the species name of the genome against which mapping is to be done. The genome files are
                                   accessible from all cluster execution hosts. Hence the files need not be provided.
            -r or --readsFile   => This flag is required and specifies the location of the file containing reads to be pash mapped. An absolute filepath is necessary.                                 
            -o or --outputFile  => This flag is required and specifies the output file into which the results of the mapping should be copied. An absolute filepath is necessary.                                   
            -e or --email       => This flag is required and should be followed by the email to which notifications about the job should be sent
            
            The flags that follow are all optional. Default values when applicable are specified
            -d or --diagonals               <number of diagonals> default = 100
            -k or --patternWeight           <pattern weight> Number of sampled positions in the sampling pattern default = 13
            -n or --patternLength           total length of sampling pattern, including unsampled positions default = 21
            -m or --samplingPattern         sampling pattern (e.g. 11011 would sample the two positions, skip one position, then sample the next two
            -G or --verticalWordOffset      <vertical word offset gap - must be a multiple of diagonal offset gap> default = 2
            -s or --score                   -s <scoreCutoff>
            -z or --gzip                    request gzip-ed output (default is text)
            -A or --self                    Job is a self-comparison, so skip half the comparison to increase speed and avoid redundancy (note if this is turned on when not doing
                                            self-comparison, half the matches will not be found!)
            -M or --indexMemory             index of the vertical sequence hash in MB(default 1024)
            -L or --ignoreList              ignore the kmers present in the ignore list file
            -N or --maxMappings             maximum number of mappings per read
            -B or --bisulfiteSeq            perform mapping of bisulfite sequencing reads
            -h or --help                    print usage info and exit

          USAGE:
           pashWrapper.rb -g test -r /usr/local/brl/home/clusterUser/WORKSPACE/bin/myReads.fastq -o /usr/local/brl/home/clusterUser/WORKSPACE/output.txt -e raghuram@bcm.edu"
      
      exit(2);
    end
  end


########################################################################################
# MAIN
########################################################################################

  # Process command line options
  optsHash = SmallRNAInterpretWrapper.processArguments()
  smallRNAInterpretWrapper = SmallRNAInterpretWrapper.new(optsHash)
  smallRNAInterpretWrapper.work();


end
end # module BRL ; module Cluster ;