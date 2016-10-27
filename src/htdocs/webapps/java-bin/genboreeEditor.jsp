<%@ include file="include/genboreeEditor.incl" %>
<HTML>
<head>
<title>Genboree - Genomic DNA Download</title>
<link rel="stylesheet" href="/styles/jsp.css<%=jsVersion%>" type="text/css">
<meta HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'>
</head>
<BODY>
<%@ include file="include/header.incl" %>
<table width="100%" border="0" cellpadding="2" cellspacing="2">
<tbody>
    <tr>
        <td>
            <p>&nbsp; <CENTER>
            <FONT SIZE="4"><B>Edit Annotation</B></FONT>
          </CENTER><P>
             <p>&nbsp;</p>

            <table BGCOLOR="navy" width="100%" border="0" cellpadding="0" cellspacing="1">
                <TR>
                    <TD>
                        <table width="100%" border="0" cellpadding="2" cellspacing="1">
                            <tr>
                                <form name="deleteAnnotation" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="deleteAnnotation">
                                <input type="hidden" name="fid" id="fid" value="<%=fid%>">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right"> <FONT SIZE="2"><B>Delete
                                Annotation :</B></FONT> </TD>

                                <td  BGCOLOR="white" > <br>
                                <input type="submit" name="SubmitDeleteAnnotation" value="Submit">
                                <br>
                                </td>
                                </form>
                            </tr>
                            <tr>
                                <form name="deleteGroupAnnotation" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="deleteGroupAnnotation">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <input type="hidden" name="groupName" id="groupName" value="<%=groupName%>">
                                <input type="hidden" name="typeId" id="typeId" value="<%=typeId%>">
                                <input type="hidden" name="rid" id="rid" value="<%=rid%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right">
                                    <FONT SIZE="2"><b>Delete Group of Annotations</b></FONT>
                                </TD>
                                <td  BGCOLOR="white" >
                                    <input type="submit" name="SubmitDeleteGroupAnnotation" value="Submit">
                                </td>
                                </form>
                            </TR>
                            <tr>
                                <form name="moveAnnotation" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="moveAnnotation">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <input type="hidden" name="fid" id="fid" value="<%=fid%>">
                                <input type="hidden" name="chromosomeLength" id="chromosomeLength" value="<%=chromosomeLength%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right">
                                    <FONT SIZE="2"><B>Move Annotation :</B></FONT>
                                </TD>
                                <td BGCOLOR="white">
                                    &nbsp;<FONT SIZE="2"><B>Start:</B></FONT>
                                    <input type="text" name="annotationStart" class="txt" value="<%=from1%>" size="20" maxlength="55" >
                                    &nbsp;&nbsp; <FONT SIZE="2"><B>End:</B></FONT>
                                    <input type="text" name="annotationEnd" class="txt" value="<%=to1%>" size="20" maxlength="55" >
                                    <input type="submit" name="SubmitMoveAnnotation" value="Submit">
                                </td>
                                </form>
                            </tr>

                            <tr>
                                <form name="moveGroupAnnotation" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="moveGroupAnnotation">
                                <input type="hidden" name="groupName" id="groupName" value="<%=groupName%>">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <input type="hidden" name="groupInitialStart" id="groupInitialStart" value="<%=from2%>">
                                <input type="hidden" name="groupInitialEnd" id="groupInitialEnd" value="<%=to2%>">
                                <input type="hidden" name="chromosomeLength" id="chromosomeLength" value="<%=chromosomeLength%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right">
                                    <b><font size="2">Move group of Annotations</font></b><FONT SIZE="2"><B>:</B></FONT>
                                </TD>
                                <td  BGCOLOR="white" >
                                            <FONT SIZE="2"><B>&nbsp;Start:</B></FONT>
                                            <input type="text" name="groupFinalStart" class="txt" value="<%=from2%>" size="20" maxlength="55" >
                                            &nbsp;&nbsp;<FONT SIZE="2"><B>End:</B></FONT>
                                            <input type="text" name="groupFinalEnd" class="txt" value="<%=to2%>" size="20" maxlength="55" >
                                            <input type="submit" name="SubmitMoveGroupAnnotation" value="Submit">
                                </TD>
                                </form>
                            </TR>

                            <tr>
                                <form name="assignGroupToAnnotation" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="assignGroupToAnnotation">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <input type="hidden" name="fid" id="fid" value="<%=fid%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right">
                                    <b><font size="2">Change Annotation Group Assignment</font></b><FONT SIZE="2"><B>:</B></FONT>
                                </TD>
                                <td  BGCOLOR="white" >
                                    <FONT SIZE="2"><B>&nbsp;New Name:</B></FONT>
                                    <input type="text" name="newGroupName" class="txt" value="<%=groupName%>" size="30" maxlength="55" >
                                    <input type="submit" name="SubmitAssignGroupToAnnotation" value="Submit">
                                </TD>
                                </form>
                            </TR>
                 <tr>
                                <form name="changeGroupName" action="genboreeEditor.jsp" method="post">
                                <input type="hidden" name="actionType" id="actionType" value="changeGroupName">
                                <input type="hidden" name="uploadId" id="uploadId" value="<%=uploadId%>">
                                <input type="hidden" name="groupName" id="groupName" value="<%=groupName%>">
                                <TD WIDTH="20%" class="form_body" ALIGN="right">
                                    <b><font size="2">Change Group Name</font></b><FONT SIZE="2"><B>:</B></FONT>
                                </TD>
                                <td  BGCOLOR="white" >
                                    <FONT SIZE="2"><B>&nbsp;New Name:</B></FONT>
                                    <input type="text" name="newGroupName" class="txt" value="<%=groupName%>" size="30" maxlength="55" >
                                    <input type="submit" name="SubmitAssignGroupToAnnotation" value="Submit">
                                </TD>
                                </form>
                            </TR>

                         </TABLE>
                    </td>
                    </TR>
                    </TABLE>
                         <P>
                    <TABLE BORDER="0">
                    <TR>
                        <td>
                            <input type="button" name="btnClose" id="btnClose" value="Close Window"
                            class="btn" onClick="window.close();">
                        </td>
                    </tr>
                   </TABLE>
</table>

            </td>
            <td width=10></td>
  					<td class="shadow"></td>
        </tr>


<%@ include file="include/footer.incl" %>

</BODY>
</HTML>
