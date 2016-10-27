package org.genboree.tabular;

import java.util.HashMap;

/**
 * User: tong
 * Date: Jan 16, 2007
 * Time: 9:35:05 AM
 */
public class LffConstants {
public static final String[] modeIds =  { "DownLoad", "View"};
public static final String[] modeLabs =  { "DownLoad", "View"};  
public static final int DOWNLOAD = 0;
public static final int  VIEW = 1;
public static final int  String_TYPE = 1;
public static final int  Long_TYPE = 2;     
public static final int  Double_TYPE = 3; 
public static final int  Date_TYPE = 4; 
/**
 * number of elements grouped into a block for fb retrieving  
 */ 
public static final int  BLOCK_SIZE = 1000; 
public static final int  Display_Limit = 300000; 
public static final int [] DISPLAY_SELECTION = new int []{20, 25,  50, 100, 200}; 
/** 
 * max limit of file size in bytes;
  */    

public static final long MAX_FILE_SIZE =    100000000;  

  
    public static final  String Q1000 = "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?"; 
    

public static final int CHROMOSOME_SORT = 4;
public static final int  CLASS_SORT = 1;
    
public static HashMap lffName2fdataName ;

    public static HashMap getLffName2fdataName() {
        return lffName2fdataName;
    }

    public static void setLffName2fdataName(HashMap lffName2fdataName) {
        LffConstants.lffName2fdataName = lffName2fdataName;
    }

public static final int  DEFAULT = -1;
public static final String [] LFF_COLUMNS  =  new String[] {"Anno. Name", "Anno. Class", "Anno. Type", "Anno. Subtype",  "Anno. Chr", "Anno. Start", "Anno. Stop", "Anno. Strand", "Anno. Phase", "Anno. Score", "Anno. QStart", "Anno. QStop", "Anno. Seq", "Anno. FreeComments"};
public static final String [] LFF_NAMES =  new String[] { "#class", "name",  "type",  "subtype",  "chrom", "start", "stop", "strand", "phase", "score", "qStart", "qStop", "attribute-comments", "sequence",  "freeform-comments"};
     
    
    
    public static HashMap getDisplay2downloadNames() {
        return display2downloadNames;
    }

    public static void setDisplay2downloadNames(HashMap display2downloadNames) {
        LffConstants.display2downloadNames = display2downloadNames;
    }

    public static  HashMap  display2downloadNames =  new HashMap () ;

public static void setHash () {
  for (int i=2; i<11; i++) 
     display2downloadNames.put(LFF_COLUMNS[i], LFF_NAMES[i]);  
    display2downloadNames.put(LFF_COLUMNS[0], LFF_NAMES[1]); 
    display2downloadNames.put(LFF_COLUMNS[1], LFF_NAMES[0]); 
    display2downloadNames.put(LFF_COLUMNS[12], LFF_NAMES[13]); 
    display2downloadNames.put(LFF_COLUMNS[13], LFF_NAMES[14]);   
}

    public static  void poulateLffMap () { 
   lffName2fdataName = new HashMap (); 
    lffName2fdataName.put (LFF_COLUMNS[1], "gclass");     
    lffName2fdataName.put (LFF_COLUMNS[2], "fmethod"); 
    lffName2fdataName.put (LFF_COLUMNS[3], "fsource");
    lffName2fdataName.put (LFF_COLUMNS[4], "refname"); 
    lffName2fdataName.put (LFF_COLUMNS[13], "comments"); 
    lffName2fdataName.put (LFF_COLUMNS[12], "sequence"); 
    lffName2fdataName.put (LFF_COLUMNS[0], "gname"); 
    lffName2fdataName.put (LFF_COLUMNS[5], "fstart"); 
    lffName2fdataName.put (LFF_COLUMNS[6], "fstop"); 
    lffName2fdataName.put (LFF_COLUMNS[7], "fstrand"); 
    lffName2fdataName.put (LFF_COLUMNS[8], "fphase"); 
    lffName2fdataName.put (LFF_COLUMNS[9], "fscore"); 
    lffName2fdataName.put (LFF_COLUMNS[10], "ftarget_start"); 
    lffName2fdataName.put (LFF_COLUMNS[11], "ftarget_stop");   
    }

}
