<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.app.accounting.product.ProductManage"%>
<%@page import="com.amarsoft.app.accounting.config.loader.ProductConfig"%>
<%
	//产品编号
	String ProductID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ProductID"));	
	if(ProductID == null)ProductID = "";
	String versionID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("VersionID"));	
	if(versionID == null) versionID = "";
%>
<html> 
<head>
<title></title>
</head>
<body class=pagebackground leftmargin="0" topmargin="0" >
<div id="Layer1" style="position:absolute;width:99.9%; height:99.9%; z-index:1; overflow: auto">
<table align='center' width='98%'  cellspacing="4" cellpadding="0">

<%
	ASValuePool termSet =ProductConfig.getTermLibrary();
	if(termSet==null) throw new Exception("未找到业务组件定义");
	ASValuePool termTypeSet = ProductConfig.getTermTypeSet();
	int i=0;
	Object[] keys = termTypeSet.getKeys();
	for(Object key:keys){
		String termType = (String)key;
		String termTypeName = ProductConfig.getTermTypeAttribute(termType, "TermTypeName");
		ArrayList termList = ProductConfig.getTermList(termType);
%>
  <tr > 
    <td colspan="4"> 
      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
		<tr>
		<td>
		  <table border=0 cellpadding=0  cellspacing=0 style='CURSOR: hand' width='100%'>
			<tbody> 
			<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
			  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent('ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='CURSOR: hand' width='15' height='15'> 
			  </td>
			  <td align=left width='100%' valign='middle' onClick="javascript:ConditonMap<%=i%>Tab3.click();"> 
				<table>
				  <tr> 
					<td width='40%'> <font color=#000000 id=ConditonMap<%=i%>Tab2 ><%=termTypeName%></font> 
					</td>
				  </tr>
				</table>
			  </td>
			</tr>
			</tbody> 
		  </table>
		</td>
	  </tr>
      </table>
    </td>
  </tr>
  <tr> 
    <td colspan="4"> 
      <div id=ConditonMap<%=i%>Content style=' WIDTH: 100%;display:none'> 
	<table class='conditionmap' width='100%' align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
	<tr>
		<td>
			<table>
				<tr>
					<%
					int cnt = 0;
					for(int j=0;j<termList.size();j++){
						ASValuePool term = (ASValuePool)termList.get(j);
						String termID = term.getString("TermID");
						String setFlag = term.getString("SetFlag");
						String termName = term.getString("TermName");
						if(!setFlag.equals("SET")&&!setFlag.equals("BAS")) continue;
						
						//修改，避免新增产品时无法取到
						String selected = Sqlca.getString("select TermID from PRODUCT_TERM_LIBRARY where SetFlag in ('SET','BAS') and TermID='"+termID+"' and ObjectType='Product' and ObjectNo='"+ProductID+"-"+versionID+"'");
						cnt++;
					%>
					<td width='20%'>
					<input type="checkbox" name="<%=termID%>_CheckBox" value="<%=termID%>" <%=selected==null||selected.length()==0?"":"checked"%> onclick=doSelect("<%=termID%>","<%=termType%>")>
					<%=termName%>
					<a name="<%=termID%>_Link" onclick=editProductTermPara("<%=termID%>","<%=setFlag%>") style={display:<%=selected==null||selected.length()==0?"none":""%>}>
					<font color=blue><b>编辑参数</b></font></a>
					<td>
					<%
						if((cnt)%5==0 )
						{
							%>
								</tr>
								<tr>
							<%
						}
					}
					%>
					</tr>
			</table>
		</td>
	</tr>
	</table>
      </div>
    </td>
  </tr>


<%
		i++;
	}
%>

</table>
</div>
</body>
</html>

<script language="javascript">
//用以控制几个条件区的显示或隐藏
	function showHideContent(id,iStrip)
	{
		var bMO = false;
		var bOn = false;
		var oTab    = document.all.item(id+"Tab");
		var oTab2   = document.all.item(id+"Tab2");
		var oImage   = document.all.item(id+"Tab3");
		var oContent = document.all.item(id+"Content");
		var oEmptyTag = document.all.item(id+"EmptyTag");
	
		if (!oTab || !oTab2 || !oImage || !oContent) 
		return;
	
		if (event.srcElement)
		{
			bMO = (event.srcElement.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}
	
		if (bOn == false)
		{
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag){
				oEmptyTag.style.display = "";
			}
		
			oImage.src = "<%=sResourcesPath%>/expand" + (bMO? ".gif" : ".gif");
		}
		else
		{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag){
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sResourcesPath%>/collapse" + (bMO? "_mo.gif" : "_mo.gif");
		}
	
	}

	function doSelect(termID,termType){
		var isCheck = document.all(termID+"_CheckBox").checked;
		if(isCheck){
			document.all(termID+"_Link").style.display='';
			sReturn=RunMethod("ProductManage","UpdateProductTerm","importTermToProduct,<%=ProductID%>,<%=versionID%>,"+termID);
			if(typeof(sReturn) != "undefined" && sReturn.length != 0)
			{
				var arr = sReturn.split("@");
				var binding = arr[0].split("#");
				for(var i = 0; i < binding.length; i ++)
				{
					try
					{
						document.all(binding[i]+"_CheckBox").checked=true;
						document.all(binding[i]+"_Link").style.display='';
					}catch(e)
					{}
				}
				var mutex = arr[1].split("#");
				for(var i = 0; i < mutex.length; i ++)
				{
					try
					{
						document.all(mutex[i]+"_CheckBox").checked=false;
						document.all(mutex[i]+"_Link").style.display='none';
					}
					catch(e)
					{}
				}
			}
		}else{
			document.all(termID+"_Link").style.display='none';
			sReturn=RunMethod("ProductManage","UpdateProductTerm","deleteTermFromProduct,<%=ProductID%>,<%=versionID%>,"+termID);
		}
	}
	
	function editProductTermPara(termID,setFlag){
		if(setFlag=="SET")
			sReturn=AsControl.PopView("/Accounting/Config/TermParaView2.jsp","ObjectType=Product&ObjectNo=<%=ProductID%>-<%=versionID%>&TermID="+termID,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=yes;status:yes;maximize:no;help:no;");
		else
			sReturn=AsControl.PopView("/Accounting/Config/TermParaView.jsp","ObjectType=Product&ObjectNo=<%=ProductID%>-<%=versionID%>&TermID="+termID,"dialogWidth=50;dialogHeight=30;resizable=no;scrollbars=yes;status:yes;maximize:no;help:no;");
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>