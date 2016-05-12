<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: 集团家谱复核意见选择框
		Input Param:
		Output Param:
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<% 
	//获取参数：
	String sGroupID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GroupID"));
	String sFamilySeq = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("FamilySeq"));//更新后家谱版本号（新）
	String sOldFamilySeq = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OldFamilySeq"));//更新前家谱版本号（旧）
	String sRight = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("EditRight"));
	String sUserID =CurUser.getUserID();
	String sOrgID=CurUser.getOrgID();
	
	//将空值转化成空字符串
	if(sGroupID == null) sGroupID = "";
	if(sFamilySeq == null) sFamilySeq = "";	
	if(sOldFamilySeq == null) sOldFamilySeq = "";
	
	//定义变量：
	String sSubmitOpinion = "",sOpinion = "",sSerialNo = "";
	
	//定义变量：动作、动作列表、阶段的类型、动作提示、阶段的属性
	ASResultSet rsTemp = null;
	String sSql="";
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义业务逻辑主体;]~*/%>
<%	
	//从
	sSql = "select SerialNo,SubmitOpinion,Opinion from GROUP_FAMILY_OPINION where GroupID = :GroupID and FamilySeq = :FamilySeq";
%>
<%/*~END~*/%>	


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义选择提交动作界面风格;]~*/%>
	<html>
	<head>
		<title></title>
	</head>
	<body class="ListPage" leftmargin="0" topmargin="0" >
	<div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
	
	<%
	int i=0;
	%>
	  <tr> 
	    <td colspan="4"> 
	      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
			<tr>
			<td>
			  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
				<tbody> 
				<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
				  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
				  </td>
				  <td align=left width='100%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
					<table>
					  <tr> 
						<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >集团家谱复核</font> 
						</td>
					  </tr>
					</table>
				  </td>
				  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
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
	    	<div id="ConditonMap<%=i%>Content" style="height: 400px; width: 100%; display:none">
	    		<table class='conditionmap' width='100%' height="100%" align='left' border='1' cellspacing='0' cellpadding='4' bordercolordark="#FFFFFF" bordercolorlight="#666666">
					<tr>
						<td>
							<iframe id="familygroup" name="familygroup" height="100%" width="100%" frameborder=0></iframe>
						</td>
					</tr>
				</table>
	    	</div>
	    </td>
	  </tr>
	  
	<%
	 i++;
	%>
	  <tr > 
	    <td colspan="4"> 
	      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
			<tr>
			<td>
			  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
				<tbody> 
				<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
				  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
				  </td>
				  <td align=left width='100%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
					<table>
					  <tr> 
						<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >家谱维护备注</font> 
						</td>
					  </tr>
					</table>
				  </td>
				  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
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
			<form name="Phase1" method="post" target="_top">
			<table width="100%" align="center">
				<tr width="100%" >
					<td width="100%"  valign="top" >
				 		<table>
							<tr>
								<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript:doReturn()",sResourcesPath)%></td>
							</tr>
		               </table>
				    </td>
				</tr>
				
			    <tr height=1> 
				    <td colspan="5" valign="top" >
				    		<hr>
				    </td>
			    </tr>
				<tr>
					<td>
						<table>	
						<%
						rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("FamilySeq",sFamilySeq));
						if (rsTemp.next()){
							
						sSubmitOpinion  = DataConvert.toString(rsTemp.getString("SubmitOpinion"));
						//将空值转化成空字符串
						if(sSubmitOpinion == null) sSubmitOpinion = "";
				        %>
							<tr>
						 		<td width="20%">家谱维护备注</td>
								<td colspan=4  width="80%">
									<textarea type=textfield  bgcolor="#FDFDF3" readonly style='width:400px;height:100px;resize:none;'><%=StringFunction.replace((sSubmitOpinion).trim(),"\\r\\n","\r\n")%>
                                   </textarea>
							 </td>
							</tr>
							   <%
							    }
						       rsTemp.getStatement().close();    
							   %>							
						</table>
					</td>
				</tr>
			</table>
	       </form>
	        </td>
		</tr>
		</table>
	      </div>
	    </td>
	  </tr>
	<%
	i++;
	%>
	  <tr > 
	    <td colspan="4"> 
	      <table border=1 cellspacing=0 cellpadding=0 bordercolordark="#FFFFFF" bordercolorlight="#666666" width='100%'>
			<tr>
			<td>
			  <table border=0 cellpadding=0  cellspacing=0 style='cursor: pointer;' width='100%'>
				<tbody> 
				<tr bgcolor='#EEEEEE' id=ConditonMap<%=i%>Tab valign=center height='20'> 
				  <td align=right valign='middle'> <img alt='' border=0 id=ConditonMap<%=i%>Tab3 onClick="showHideContent(event,'ConditonMap<%=i%>','<%=i%>');"  src='<%=sResourcesPath%>/expand.gif' style='cursor: pointer;' width='15' height='15'> 
				  </td>
				  <td align=left width='100%' valign='middle' onClick="javascript:document.getElementById('ConditonMap<%=i%>Tab3').click();"> 
					<table>
					  <tr> 
						<td> <font color=#000000 id=ConditonMap<%=i%>Tab2 >家谱复核意见</font> 
						</td>
					  </tr>
					</table>
				  </td>
				  <td align=right valign='top'> <img alt='' border=0 id=ConditonMap<%=i%>Tab1 src='<%=sResourcesPath%>/curve1.gif' width='0' height='0'> 
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
			<form name="Phase" method="post" target="_top">
			<table width="100%" align="center">
				<tr width="100%" >
					<td width="100%"  valign="top" >
				 		<table>
							<tr>
							    <td><%=sRight == null ? ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","复核通过","复核通过","javascript:saveRecord(2)",sResourcesPath) : ""%></td>
							    <td><%=sRight == null ? ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","复核退回","复核退回","javascript:saveRecord(3)",sResourcesPath) : ""%></td>
								<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","返回","返回","javascript:doReturn()",sResourcesPath)%></td>
							</tr>
		               </table>
				    </td>
				</tr>
				
			    <tr height=1> 
				    <td colspan="5" valign="top" >
				    		<hr>
				    </td>
			    </tr>
				<tr>
					<td>
						<table>	
								<%
								rsTemp = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("GroupID",sGroupID).setParameter("FamilySeq",sFamilySeq));
								if (rsTemp.next()){
								sSerialNo  = DataConvert.toString(rsTemp.getString("SerialNo"));
								sOpinion  = DataConvert.toString(rsTemp.getString("Opinion"));
								//将空值转化成空字符串
								if(sSerialNo == null) sSerialNo = "";
								if(sOpinion == null) sOpinion = "";
						        %>						
							<tr>
						 		<td width="20%">复核意见（最多输入500汉字）</td>
								<td colspan=4  width="80%">
									<textarea type=textfield  id="PhaseOpinion" bgcolor="#FDFDF3"  <%=sRight%> style='width:400px;height:100px;resize: none;'  onkeyup="count()" ><%=StringFunction.replace((sOpinion).trim(),"\\r\\n","\r\n")%></textarea>
							    </td>
							</tr>
							<%
							    }
						       rsTemp.getStatement().close();    
							 %>													
						</table>
					</td>
				</tr>
			</table>
	       </form>
	        </td>
		</tr>
		</table>
	      </div>
	    </td>
	  </tr>

	</table>

</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script type="text/javascript">		

	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doReturn(){
		self.returnValue = "_CANCEL_";
		self.close();
	}
	
	//用以控制几个条件区的显示或隐藏
	function showHideContent(event,id,iStrip)
	{
		var bMO = false;
		var bOn = false;
		var oTab    = document.getElementById(id+"Tab");
		var oTab2   = document.getElementById(id+"Tab2");
		var oImage   = document.getElementById(id+"Tab3");
		var oContent = document.getElementById(id+"Content");
		var oEmptyTag = document.getElementById(id+"EmptyTag");

		if (!oTab || !oTab2 || !oImage || !oContent) 
		return;
	
		var obj = event.srcElement || event.target;
		if (obj){
			bMO = (obj.src.toLowerCase().indexOf("_mo.gif") != -1);
			bOn = (oContent.style.display.toLowerCase() == "none");
		}

		if (bOn == false){
			oTab.bgColor = "#EEEEEE";
			oTab2.color  = "#000000";
			oContent.style.display = "none";
			if(oEmptyTag){
				oEmptyTag.style.display = "";
			}
			oImage.src = "<%=sResourcesPath%>/expand" + (bMO? ".gif" : ".gif");
		}else{
			oTab2.color  = "#ffffff";
			oTab.bgColor = "#00659C";
			oContent.style.display = "";
			if(oEmptyTag){
				oEmptyTag.style.display = "none";
			}
			oImage.src = "<%=sResourcesPath%>/collapse" + (bMO? "_mo.gif" : "_mo.gif");
		}
	}
    
	function saveRecord(sApproveType)
	{	
		var sUserID = "<%=sUserID%>";
		var sOrgID = "<%=sOrgID%>";
		var sGroupID="<%=sGroupID%>";
		var sFamilySeq = "<%=sFamilySeq%>";
		var sSerialNo = "<%=sSerialNo%>";
		var opinion = document.getElementById("PhaseOpinion").value;
		// 校验复核意见
		if(!validatyCheck()) return;
		//保存相关信息
	    var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveOpinion","GroupID="+sGroupID+",SerialNo="+sSerialNo+",Opinion="+opinion+",UserID="+sUserID+",effectiveStatus="+sApproveType+",versionSeq="+sFamilySeq);
		    if(sReturn = "SUCCEEDED"){
				var sReturn = RunJavaMethodTrans("com.amarsoft.app.als.customer.group.model.UpdateFamilyApproveStatus","updateFamilyApproveStatus","GroupID="+sGroupID+",UserID="+sUserID+",effectiveStatus="+sApproveType+",versionSeq="+sFamilySeq);
				  if(sReturn = "SUCCEEDED"){
						alert("完成复核！");
						top.close();
				  }	  
			}
	}
	
	/*~[Describe=校验复核意见;InputParam=无;OutPutParam=无;]~*/
	function validatyCheck(){
		iLength = document.getElementById("PhaseOpinion").value.length;//获取意见长度
		if(iLength == 0){
			alert("请输入复核意见！");
			return false;
		}
		return true;
	}
	document.getElementById("ConditonMap2Tab3").click();
		
	groupfamily();
	function groupfamily(){
		var sGroupID="<%=sGroupID%>";
		var sFamilySeq = "<%=sFamilySeq%>";
		var sOldFamilySeq="<%=sOldFamilySeq%>";
    	OpenComp("FamilyVersionInternalList","/CustomerManage/GroupManage/FamilyVersionApprove/FamilyVersionInternalList.jsp","GroupID="+sGroupID+"&FamilySEQ="+sFamilySeq+"&OldFamilySEQ="+sOldFamilySeq,"familygroup");
	}
	
	function count(){
		iLength = document.getElementById("PhaseOpinion").value.length;//获取意见长度
		if(iLength > 500)
			alert("您输入的复核意见超过字数500！");
	}
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
