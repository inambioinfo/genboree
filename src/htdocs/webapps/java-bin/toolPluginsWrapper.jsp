<%
  // GENBOREE ARBITRARY CONTENT WRAPPER *TEMPLATE*
%>
<%!
    // --------------------------------------------------------------------------
    // TEMPLATE CONFIGURATION
    // --------------------------------------------------------------------------
    // 1) Assign access limitation: *either* a group-name OR a refSeqId:
    String groupAllowed = "";            // Specify a group name OR
    String refSeqId = null;                         // RefSeqId as a string // TODO
    // 2) Specify the external URL that has the content. If you will put the
    //    static content on *this* page itself, make this string null (i.e.
    //    there is NO external URL to go to, this page has everything).
    //    EX: urlStr = myBase + "/java-bin/MyProj/index.rhtml"
    //String urlStr = request.getServerName() + "/genboree/toolPlugins/accessWrapper.rhtml";
    // 3) If there is an external URL, decide whether you want the content as
    //    a single String object, else you get a Vector of lines.
    boolean singleString = true;
    // 4) Do you want the template to suck in and present your external page
    //    *automatically* for you?? This will allow the template to show the
    //    Genboree logos, the navbar, and the footer. Otherwise, ALL the HTML
    //    will come from the external page (if there is one).
    boolean autoExternalPage = true;
    // 5) If autoExternalPage, then specify the title for the page, else put empty string.
    String pageTitle = "Genboree Discovery System";
    // 6) If autoExternalPage, do you want it to strip the html, head, body, etc
    //    tags that might mess things up a bit?
    boolean doHtmlStripping = true ;

    // --------------------------------------------------------------------------
    // TEMPLATE VARIABLES
    // --------------------------------------------------------------------------
    String contentUrl = null;                       // String to store the entire content of an URL using getContentOfUrl(urlStr )
    Vector urlLines = null;                         // Vector to store lines of contentUrl using splitBlockIntoLines(contentUrl);
    Enumeration lineOfUrl = null;                   // Enumeration to loop over the urlLines
%>

<%@ include file="include/toolPluginsStaticContent.incl" %>

<%
  // Grab http parameters for reuse later when we pass to RHTML templates
  String urlStr = GenboreeUtils.returnFullURL(request, "/genboree/toolPlugins/accessWrapper.rhtml");
  // REBUILD the request params we will pass to RHTML side (via a POST)
  Map paramMap = request.getParameterMap() ; // "key"=>String[]
  StringBuffer postContentBuff = new StringBuffer() ;
  // 1.a Send the userId, whether on form or not
  postContentBuff.append("userId=").append(Util.urlEncode(userInfo[2])) ;
  // 1.b Loop over request key-value pairs:
  Iterator paramIter = paramMap.entrySet().iterator() ;
  while(paramIter.hasNext())
  {
    Map.Entry paramPair = (Map.Entry) paramIter.next() ;
    String pName = Util.urlEncode((String) paramPair.getKey()) ;
    String[] pValues = (String[]) paramPair.getValue() ; // <-- Array!
    if(pValues != null)
    { // then there is 1+ actual values
      for(int ii = 0; ii < pValues.length; ii++)
      { // Add all of the values to the POST
        postContentBuff.append("&").append(pName).append("=").append(Util.urlEncode(pValues[ii])) ;
      }
    }
    else // no value, just a key? ok...
    {
      postContentBuff.append("&").append(pName).append("=") ;
    }
  }
  // 1.c Get the string we will post IF that's what we will be doing
  String postContentStr = postContentBuff.toString() ;

%>
<% if(urlStr != null && autoExternalPage) {  // (A) We have an external url with content and want to auto-wrap its content
  // ------------------------------------------------------------------------
  // (A) AUTOPROCESS AN EXTERNAL PAGE:
  // ------------------------------------------------------------------------
%>
  <HTML>
  <head>
  <title><%=pageTitle%></title>
  <meta HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'>
  <link rel="stylesheet" href="/styles/jsp.css<%=jsVersion%>" type="text/css" >
  <SCRIPT type="text/javascript" src="/javaScripts/prototype-1.6.js<%=jsVersion%>"></SCRIPT>
  <SCRIPT type="text/javascript" src="/javaScripts/util.js<%=jsVersion%>"></SCRIPT>
  <SCRIPT type="text/javascript" src="/javaScripts/json.js<%=jsVersion%>"></SCRIPT>
  <SCRIPT type="text/javascript" src="/javaScripts/toolPlugins/toolPluginsWrapper.js<%=jsVersion%>"></SCRIPT>
  </head>
  <BODY>
      <%@ include file="include/header.incl" %>
      <%@ include file="include/navbar.incl" %>
      <%@ include file="include/toolBar.incl" %>


  <BR><BR>
  <%  // TEMPLATE: grab the external page and present its contents:
      HashMap resultHdrsMap = new HashMap() ;
      // Do as a POST
      contentUrl = GenboreeUtils.postToURL(urlStr, postContentStr, doHtmlStripping, resultHdrsMap, mys ) ;

      if(singleString)                // We sucked in the page as a single string
      {
        // Add extra parsing of the String content here, if needed.
        out.write(contentUrl);
      }
      else                            // We have a Vector of lines to loop over...modify if you want...
      {
        urlLines = GenboreeUtils.splitBlockIntoLines(contentUrl);
        for( lineOfUrl = urlLines.elements(); lineOfUrl.hasMoreElements(); )
        {
          String singleLine = (String)lineOfUrl.nextElement();
          // Add extra parsing of the line here, if needed.
          out.println(singleLine);
        }
      }
  %>
  <BR>
  <%@ include file="include/footer.incl" %>
  </BODY>
  </HTML>
<% } %>