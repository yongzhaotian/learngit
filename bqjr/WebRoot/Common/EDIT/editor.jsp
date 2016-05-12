<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   
 * Tester:
 * Content: 
 * Input Param:
 *	                            
 * Output param:
 *                             	
 * History Log:  
 *
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.io.*"%>
<%
	//获取参数：
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));
	String sDocID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DocID"));
	String sOrderID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OrderID"));	
	String sDirID = DataConvert.toRealString(iPostChange,(String)request.getParameter("DirID"));
	String sSerialNo1 = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo1"));	
	String sContentLength = DataConvert.toRealString(iPostChange,(String)request.getParameter("ContentLength"));	
	SqlObject so = null;
	String sNewSql = "";	
		
	ASResultSet rs0 = null;
	int iContentLength = 0;
	if(sContentLength!=null)
		iContentLength = Integer.valueOf(sContentLength).intValue();
		
	//定义变量	
	String sSimpleTips = "",sTips = "",sEditTemplate="";//存放提示信息(简单提示和复杂提示)
	String sReportData = ""; //存放数据
	String sMethod = "";// 第一次打开:1   保存:2
	
	sMethod = DataConvert.toRealString(iPostChange,(String)request.getParameter("Method"));
	sReportData = DataConvert.toRealString(iPostChange,(String)request.getParameter("ReportData"));

	//得到提示信息
	sNewSql = "select simpletips,tips,attribute1 from FORMATDOC_DEF where DocID=:DocID and DirID=:DirID ";
	so = new SqlObject(sNewSql).setParameter("DocID",sDocID).setParameter("DirID",sDirID);
	rs0 = Sqlca.getResultSet(so);
	if(rs0.next()){
		sSimpleTips = DataConvert.toString(rs0.getString("SimpleTips"));
		sTips = DataConvert.toString(rs0.getString("Tips"));
		sTips = sTips.trim();
		sEditTemplate = DataConvert.toString(rs0.getString("attribute1"));
	}
	rs0.getStatement().close();	
	
	if(sMethod.equals("1")){ //如果是第一次打开
		if(iContentLength==0){ //如果数据表中没有存放该特定数据
			//modify by xdhou in 2004/05/19 for template
			//sReportData = "";
			//从template读入
			///*
			String sFileName = request.getRealPath("/"+sEditTemplate);
			System.out.println(sFileName);
	        java.io.File file = new java.io.File(sFileName);
	        java.io.FileInputStream fileIn = new java.io.FileInputStream(file);
	        long lSize = file.length();
	        Long LSize = new Long(lSize);
	        int  iSize = LSize.intValue();
	        
			sReportData = "";
			byte buf[] = new byte[512000];
			int n;
			while ((n = fileIn.read(buf,0,iSize)) != -1) 
				sReportData = sReportData + new String(buf,0,n,"GBK");
				//sReportData = sReportData + new String(buf,0,n,"ISO8859-1");
			fileIn.close();

			sReportData = StringFunction.replace(sReportData,"\n","");
			sReportData = StringFunction.replace(sReportData,"\r","");
			sReportData = StringFunction.replace(sReportData,"\"","&quot;");
			//sReportData = "";
			//*/
		}else if(iContentLength>0){ //如果数据表中已经存放了该特定数据
			ASResultSet rs1 = Sqlca.getResultSet(new SqlObject("select HtmlData from FORMATDOC_DATA where SerialNo=:SerialNo and OrderID=:OrderID").setParameter("SerialNo",sSerialNo).setParameter("OrderID",sOrderID));	
			byte bb[] = new byte[iContentLength];
			int iByte = 0;		
			sReportData = "";
			java.io.InputStream inStream = null;
			
			if(rs1.next())	
				inStream = rs1.getBinaryStream("HtmlData");

			while(true){
				iByte = inStream.read(bb);
				if(iByte<=0)
					break;
	            sReportData = sReportData + new String(bb, "GBK");
			}
			rs1.getStatement().close();	
		}
	}else if(sMethod.equals("2")){ //如果是保存
		byte abyte0[] = sReportData.getBytes("GBK");

		String sUpdate = " update FORMATDOC_DATA set HtmlData=?,ContentLength=? " +
					     " where SerialNo='"+sSerialNo+"' and OrderID='"+sOrderID+"'";
        PreparedStatement pre1 = Sqlca.getConnection().prepareStatement(sUpdate);
        pre1.clearParameters();
        pre1.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
        pre1.setInt(2, abyte0.length);
        pre1.executeUpdate();
        pre1.close();
%>
<script type="text/javascript">
	alert("保存成功！");
</script>        	
<%
	}
%>	

<html>
<head>
	<title>HTML在线编辑器</title>
	<meta http-equiv="Content-Type" content="text/html; charset=GBK">
	<link rel="STYLESHEET" type="text/css" href="editor.css">
	<script type="text/javascript" src="editor.js"> </script> 		
</head>

<body bgcolor="#FFFFFF" leftmargin='0' topmargin='0' >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >

<tr height=1 valign=top >
	<td valign=center align=left>
		<span title="<%=sTips%>"> 
			&nbsp;<%=sSimpleTips%>
		</span>
	</td>
</tr>

<tr height=1 valign=top >
	<td width=10 align=left>
		<table>
			<tr>
				<td >
			        <%=HTMLControls.generateButton("保存","保存","javascript:save()",sResourcesPath)%>
				</td>
				<td >
			        <%=HTMLControls.generateButton("插入图片","插入图片，支持格式为：jpg、gif、bmp、png等","javascript:uploadImg()",sResourcesPath)%>
				</td>
				<td >
			        <%=HTMLControls.generateButton("预览","预览","javascript:my_preview()",sResourcesPath)%>
				</td>				
				<td >
			        <%=HTMLControls.generateButton("帮助","帮助","javascript:help()",sResourcesPath)%>
				</td>
				<%
				if(sDocID.equals("01")||sDocID.equals("02")||sDocID.equals("03")||sDocID.equals("04")||sDocID.equals("05")||sDocID.equals("06")||sDocID.equals("07")||sDocID.equals("08")||sDocID.equals("09")||sDocID.equals("10"))
				{
				  	if(sDirID.equals("dir08")||sDirID.equals("dir14")||sDirID.equals("dir20")){
				%>
				<td >
			        <%=HTMLControls.generateButton("在线说明","在线说明","javascript:my_help()",sResourcesPath)%>
				</td>
				<%
				  	}
				}
				%>

				<td nowrap valign=center  >
					&nbsp;
					<!--
					<a TITLE="保存" href="javascript:save()"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/save.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					-->
					<a TITLE="全部选择" href="javascript:format('selectall')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/selectall.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="撤消" href="javascript:format('undo')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/undo.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="恢复" href="javascript:format('redo')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/redo.gif" WIDTH="18" HEIGHT="18"> 
					</a>
			
				   <select id="FontName" onchange="format('fontname',this[this.selectedIndex].value);this.selectedIndex=0">
				    <option selected>字体</option>
				    <option value="宋体">宋体</option>
				    <option value="黑体">黑体</option>
				    <option value="楷体_GB2312">楷体</option>
				    <option value="仿宋_GB2312">仿宋</option>
				    <option value="隶书">隶书</option>
				    <option value="幼圆">幼圆</option>
				    <option value="Arial">Arial</option>
				    <option value="Arial Black">Arial Black</option>
				    <option value="Arial Narrow">Arial Narrow</option>
				    <option value="Brush Script	MT">Brush Script MT</option>
				    <option value="Century Gothic">Century Gothic</option>
				    <option value="Comic Sans MS">Comic Sans MS</option>
				    <option value="Courier">Courier</option>
				    <option value="Courier New">Courier New</option>
				    <option value="MS Sans Serif">MS Sans Serif</option>
				    <option value="Script">Script</option>
				    <option value="System">System</option>
				    <option value="Times New Roman">Times New Roman</option>
				    <option value="Verdana">Verdana</option>
				    <option value="Wide	Latin">Wide Latin</option>
				    <option value="Wingdings">Wingdings</option>
				  </select>
				  <select id="FontSize" onchange="format('fontsize',this[this.selectedIndex].value);this.selectedIndex=0">
				    <option selected>字号</option>
				    <option value="7">一号</option>
				    <option value="6">二号</option>
				    <option value="5">三号</option>
				    <option value="4">四号</option>
				    <option value="3">五号</option>
				    <option value="1">六号</option>
				    <option value="2">七号</option>
				  </select>
				</td>				
			</tr>
			<tr>	
				<td nowrap valign=center colspan=8 >
					&nbsp;
					<a TITLE="加粗" href="javascript:format('bold')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/bold.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="斜体" href="javascript:format('italic')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/italic.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="下划线" href="javascript:format('underline')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/underline.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="左对齐" NAME="Justify" href="javascript:format('justifyleft')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/aleft.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="居中" NAME="Justify" href="javascript:format('justifycenter')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/acenter.gif" WIDTH="18" HEIGHT="18">
					</a>
					<a TITLE="右对齐" NAME="Justify" href="javascript:format('justifyright')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/aright.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="编号" href="javascript:format('insertorderedlist')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/num.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="项目符号" href="javascript:format('insertunorderedlist')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/list.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="减少缩进量" href="javascript:format('outdent')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/outdent.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="增加缩进量" href="javascript:format('indent')"> 
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/indent.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="插入图片，支持格式为：jpg、gif、bmp、png等" href="javascript:uploadImg()">
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/img.gif" WIDTH="18" HEIGHT="18"> 
					</a>
					<a TITLE="查看帮助:换行请按Shift+Enter,另起一段请按Enter,插入的图片不在中央，选中图片后，请按Ctrl+X，然后把光标停留在要插入的位置，再按Ctrl+V。" href="javascript:help()">
						<img border=0 valign=center src="<%=sWebRootPath%>/Edit/Images/Editor/help.gif" WIDTH="18" HEIGHT="18"> 
					</a>
				</td>
			</tr>
		</table>
	</td>
</tr>

<tr valign="top">
	<td >
			<iframe class="HtmlEdit" ID="HtmlEdit" src="" MARGINHEIGHT="1" MARGINWIDTH="1" style="width=100%; height=100%"> </iframe>
			<iframe class="HtmlEdit" ID="HtmlPreview" MARGINHEIGHT="1" MARGINWIDTH="1" style="width=100%; height=100%; display:none"> </iframe>
	</td>
</tr>
<!--
<tr height=1 valign=top >
<td>
		<img id="setMode0" src="<%=sWebRootPath%>/Edit/Images/Editor/Editor2.gif" width="59" height="20" onClick="setMode(0)">
		<img id="setMode1" src="<%=sWebRootPath%>/Edit/Images/Editor/html.gif" width="59" height="20" onClick="setMode(1)">
		<img id="setMode2" src="<%=sWebRootPath%>/Edit/Images/Editor/browse.gif" width="59" height="20" onClick="setMode(2)">
</td>
</tr>
-->

</table>

<table align='center' cellspacing=0 cellpadding=0 width='100%' style='display=none;'>
	<tr>
		<td height=30 valign='middle' style='BORDER-bottom: #000000 0px solid;'>
			<form method='post' action='editor.jsp' name='reportInfo'>
				<input type='hidden' name='DocID' value='<%=sDocID%>'>
				<input type='hidden' name='DirID' value='<%=sDirID%>'>
				<input type='hidden' name='SerialNo' value='<%=sSerialNo%>'>
				<input type='hidden' name='Method' value='0'>
				<input type='hidden' name='ReportData' value=''>
				<input type='hidden' name='Rand' value=''>
				<input type='hidden' name='OrderID' value='<%=sOrderID%>'>
				<input type='hidden' name='SerialNo1' value='<%=sSerialNo1%>'>
			</form>
		</td>
	</tr>
</table>

</body>


<script type="text/javascript">
	SEP_PADDING = 5;
	HANDLE_PADDING = 7;

	var yToolbars =	new Array();
	var YInitialized = false;
	var bLoad=false;
	var pureText=true;
	var bodyTag="<head><style type=\"text/css\">body {font-size:	9pt}</style><meta http-equiv=Content-Type content=\"text/html; charset=GBK\"></head><BODY bgcolor=\"#FFFFFF\" MONOSPACE>";
	var EditMode=true;
	var SourceMode=false;
	var PreviewMode=false;
	var CurrentMode=0;

	document.onreadystatechange = function(){
	  	if (YInitialized) return;
	  	YInitialized = true;
	
	  	var i, s, curr;
	  	for (i=0; i<document.body.all.length;	i++){
	    	curr=document.body.all[i];
	    	if (curr.className == "yToolbar"){
	      		InitTB(curr);
	      		yToolbars[yToolbars.length] = curr;
			}
		}
	
	  	DoLayout();
	  	window.onresize = DoLayout;
	  	HtmlEdit.document.designMode="On";
	};
		
	function uploadImg(){
		window.open("FileAdd.jsp?SerialNo=<%=sSerialNo%>&rand="+randomNumber(),"_blank","Left=200,Top=200,Width=340,Height=200;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
	}
	
	function validateMode(){
	  if (EditMode) 
	  	return true;
	  
	  alert("请先点编辑器下方的“编辑”按钮，进入“编辑”状态，然后再使用系统编辑功能!");
	  HtmlEdit.focus();
	  
	  return false;
	}
	
	function help(){
	  var arr = showModalDialog("editor_help.jsp?rand="+randomNumber(), "", "dialogWidth:580px; dialogHeight:460px; help: no; scroll: no; status: no");
	}
	
	function setMode(newMode){
	  var cont;
	  if (CurrentMode==newMode){
	    return false;
	  }
	  
	  if (newMode==0){
		setMode0.src="<%=sWebRootPath%>/Edit/Images/Editor/Editor2.gif";
		setMode1.src="<%=sWebRootPath%>/Edit/Images/Editor/html.gif";
		setMode2.src="<%=sWebRootPath%>/Edit/Images/Editor/browse.gif";
		if (PreviewMode){
		  document.all.HtmlEdit.style.display="";
		  document.all.HtmlPreview.style.display="none";
		}
		if(SourceMode){
		  cont=HtmlEdit.document.body.innerText;
	      HtmlEdit.document.body.innerHTML=cont;
		}
	    EditMode=true;
		SourceMode=false;
		PreviewMode=false;
	  }else if (newMode==1){
		setMode0.src="<%=sWebRootPath%>/Edit/Images/Editor/Editor.gif";
		setMode1.src="<%=sWebRootPath%>/Edit/Images/Editor/html2.gif";
		setMode2.src="<%=sWebRootPath%>/Edit/Images/Editor/browse.gif";
		if (PreviewMode){
		  document.all.HtmlEdit.style.display="";
		  document.all.HtmlPreview.style.display="none";
		}
		if(EditMode){
		  cleanHtml();
	      cleanHtml();
	      cont=HtmlEdit.document.body.innerHTML;
	      HtmlEdit.document.body.innerText=cont;
		}
	    EditMode=false;
		SourceMode=true;
		PreviewMode=false;
	  }else if (newMode==2){
		setMode0.src="<%=sWebRootPath%>/Edit/Images/Editor/Editor.gif";
		setMode1.src="<%=sWebRootPath%>/Edit/Images/Editor/html.gif";
		setMode2.src="<%=sWebRootPath%>/Edit/Images/Editor/browse2.gif";
		var str1="<head><style type=\"text/css\">body {font-size:	9pt}</style><meta http-equiv=Content-Type content=\"text/html; charset=GBK\"></head><BODY bgcolor=\"#F6F6F6\" MONOSPACE>";
		if(CurrentMode==0){
		  str1=str1+HtmlEdit.document.body.innerHTML;
		}else{
		  str1=str1+HtmlEdit.document.body.innerText;
		}
	    HtmlPreview.document.open();
		HtmlPreview.document.write(str1);
	    HtmlPreview.document.close();
	    document.all.HtmlEdit.style.display="none";
		document.all.HtmlPreview.style.display="";
		PreviewMode=true;
	  }
	  CurrentMode=newMode;
	  HtmlEdit.focus();
	}
	
	function my_preview(){
		window.open("<%=sWebRootPath%>/FormatDoc/preview.jsp?SerialNo=<%=sSerialNo%>&DocID=<%=sDocID%>&DirID=<%=sDirID%>&OrderID=<%=sOrderID%>&OrderIDDown2=<%=sOrderID%>&rand"+randomNumber(),"_blank",OpenStyle);
	}

	function my_help(){
		if(<%=sDocID.equals("06")%>){
		  window.open("<%=sWebRootPath%>/FormatDoc/Report6/Html/fina_help7.htm","_blank",OpenStyle);
		}else if(<%=sDocID.equals("04")%>){
		  window.open("<%=sWebRootPath%>/FormatDoc/Report4/Html/fina_help8.htm","_blank",OpenStyle);
		}else if(<%=sDocID.equals("05")%>){
		  window.open("<%=sWebRootPath%>/FormatDoc/Report5/Html/fina_help9.htm","_blank",OpenStyle);
		}
		if(<%=sDirID.equals("dir14")%>){
		  window.open("<%=sWebRootPath%>/FormatDoc/Report/Html/fina_help3.htm","_blank",OpenStyle);
		}else if(<%=sDirID.equals("dir20")%>){
		  window.open("<%=sWebRootPath%>/FormatDoc/Report/Html/fina_help3.htm","_blank",OpenStyle);
		}
	}

	function save(){
	  reportInfo.Method.value = "2"; //save
	  temp = HtmlEdit.document.body.innerHTML;
	  temp = temp.replace(/"/g,"&quot;");
	  temp = temp.replace(/\n/g,"");
	  temp = temp.replace(/\r/g,"");

	  reportInfo.ReportData.value = temp;
	  reportInfo.submit();
	}

	HtmlEdit.document.open();
	temp = "<%=sReportData%>";	
	if(temp=="") temp = "&nbsp;&nbsp;";
	HtmlEdit.document.write(temp.replace(/&quot;/g,"\""));
	HtmlEdit.document.close();
	
	//alert(CurrentMode);
	//alert(parent.OWC.document.body.innerHTML);
</script>

</html>
<%@ include file="/IncludeEnd.jsp"%>