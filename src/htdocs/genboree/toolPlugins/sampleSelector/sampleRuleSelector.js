// Uses prototype.js standard library file
// Uses util.js genboree library file
// Uses querytool.js genboree library file for query-tool support

// STANDARD HELPER FUNCTIONS are at the bottom. Generally they don't need
// changing unless you've mis-named standard fields or something else
// bad/special.

//-------------------------------------------------------------------
// INITIALIZE your page/javascript once it loads if needed.
//-------------------------------------------------------------------
addEvent(window, "load", init_toolPage) ;
function init_toolPage()
{
  // Prime selection criteria UI with 1 rule
  resetQueryUI() ;
  return ;
}

//-------------------------------------------------------------------
// RESET implementation
//-------------------------------------------------------------------
// OPTIONAL: Implement a toolReset() function that will correctly reset your
// tool's form to its initial state.
function toolReset()
{
  $('expname').value = '' ;
  // reset the selection criteria
  resetQueryUI() ;
  return ;
}

//-------------------------------------------------------------------
// VALIDATE *WHOLE* FORM
// - Call *each* specific validator method from here
//-------------------------------------------------------------------
// REQUIRED: Implement a validate() function that will validate your form and
// decide whether to submit (return true) or not (return false).
function validate()
{
  // Standard validations:
  if(validate_expname() == false) { return false; }
  if(unique_expname() == false) { return false; }
  // Custom validations:
  if(prepAVPsubmit('pdw', 'rulesJson') == false) { return false ; }
  // alert("JSON:\n\n" + $('rulesJson').value) ;
  return true ;
}

//-------------------------------------------------------------------
// IMPLEMENT EACH VALIDATION
// - keep each validation method focused to 1 field...maybe 2 for special validations
//-------------------------------------------------------------------

//-----------------------------------------------------------------------------
// POP-UP HELP: in this function, make a pop-up help for each parameter/field in the form.
// This is done by supplying a helpSection arg indicating what help info to display.
//-----------------------------------------------------------------------------
function overlibHelp(helpSection)
{
  var overlibCloseText = '<FONT COLOR=white><B>X&nbsp;</B></FONT>' ;
  var leadingStr = '&nbsp;<BR>' ;
  var trailingStr = '<BR>&nbsp;' ;
  var helpText;

  if(helpSection == "expname")
  {
    overlibTitle = "Help: Job Name" ;
    helpText = "\n<UL>\n" ;
    helpText += "  <LI>Give this sample selection job a name.</LI>" ;
    helpText += "  <LI>You will use this name to retrieve your results later!</LI>" ;
    helpText += "</UL>\n\n" ;
  }
  else if(helpSection == "criteria" )
  {
    overlibTitle = 'Help: Selection Criteria' ;
    helpText = "\n<UL>\n" ;
    helpText += "  <LI>Enter the criteria for selecting the samples.</LI>\n" ;
    helpText += "  <LI>You can enter criteria based on your unique Sample ID or on your custom sample attributes.</LI>\n" ;
    helpText += "  <LI>The <i>Data Type</i> you choose for the attribute will determine which operations are available.\n" ;
    helpText += "  <LI>Use the <font size='+1'>+</font> and <font size='+1'>&ndash;</font> buttons to add and remove criteria.</LI>\n" ;
    helpText += "  <LI>By default, samples must meet <b>All</b> of your criteria to be placed in the output track. But you can change this to require <b>Any</b> of the conditions to be matched.</LI>\n" ;
    helpText += "  <LI>Only 100 sample attributes from the database are listed. However, you can always indicate attribute names <u>manually</u> using the <b>**User Entered**</b> option at the bottom of the attribute list.</LI>\n" ;
    helpText += "</UL>\n\n";
  }
  overlibBody = helpText;
  return overlib( overlibBody, STICKY, DRAGGABLE, CLOSECLICK, FGCOLOR, '#CCF8FF', BGCOLOR, '#9F833F',
                  CAPTIONFONTCLASS, 'capFontClass', CAPTION, overlibTitle, CLOSEFONTCLASS, 'closeFontClass',
                  CLOSETEXT, overlibCloseText, WIDTH, '300');
}

//-----------------------------------------------------------------------------
// HELPERS: These are standard and should be left alone. Unless you need
// some special changes for your tool.
//-----------------------------------------------------------------------------
// Displays an error msg and highlights/selects the problem field and label.
function showFormError(labelId, elemId, msg)
{
  alert(msg) ;
  highlight(labelId) ;
  var elem = $(elemId) ;
  if(elem.focus) elem.focus() ;
  if(elem.select) elem.select() ;
  return false ;
}

function highlight( id )
{
  $(id).style["color"] = "#FF0000";
}

function unHighlight( id )
{
  $(id).style["color"] = "#000000";
}

// Verify that expname is unique.
function unique_expname()
{
   var expname = $F('expname') ;
   for( var ii=0; ii<=USED_EXP_NAMES.length; ii++ )
   {
     if(expname == USED_EXP_NAMES[ii])
     {
       return showFormError( 'expnameLabel', 'expname', ( "'" + expname + "' is already used as an experiment name in this group.\nPlease select another.") );
     }
   }
   return true;
}

// Verify the expname looks ok..
function validate_expname()
{
  var expname = $F('expname');
  if( !expname || expname.length == 0 )
  {
    return showFormError( 'expnameLabel', 'expname', "You must enter a job name!" ) ;
  }
  else
  {
    var newExpname = expname.replace(/\`|\|\!|\@|\#|\$|\%|\^|\&|\*|\(|\)|\+|\=|\||\;|\'|\>|\<|\/|\?/g, '_')
    if(newExpname != expname)
    {
      $('expname').value = newExpname ;
      return showFormError( 'expnameLabel', 'expname', "Unacceptable letters in Experiment Name have been replaced with '_'.\n\nNew Experiment Name is: '" + newExpname + "'.\n");
    }
    else
    {
      unHighlight( 'expnameLabel' );
    }
  }
  return true ;
}

//-----------------------------------------------------------------------------
