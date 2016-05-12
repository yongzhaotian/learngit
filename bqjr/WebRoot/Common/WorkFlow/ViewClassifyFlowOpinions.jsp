<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
    <%
    /*
    Author: cbsu 2009-10-14
    Tester:
    Content: 五级分类查看意见页面
    Input Param:
        ObjectType： 五级分类对象类型("Classify")
        ObjectNo：五级分类申请流水号
        FlowNo：流程名
        PhaseNo：当前阶段号
    Output param:
    History Log:
    */
    %>
<%/*~END~*/%>

<%
	//获取页面参数：五级分类对象类型("Classify")，五级分类申请流水号，流程名，阶段名
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
    String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
	String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
	String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
	
	//将空值转化为空字符串
	if(sObjectType==null)sObjectType="";
	if(sObjectNo==null)sObjectNo="";
	if(sCurFlowNo==null)sCurFlowNo="";
	if(sCurPhaseNo==null)sCurPhaseNo="";
	
    String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
    //哪些阶段能看
    boolean bRolePrivilege = false;
	boolean bPhasePrivilege = false;
	//判断当前意见所处阶段是否在对应的特权阶段
	boolean bPhaseMatch = false;
	//流程名称
	String sFlowNo = "";
	//当前阶段号
	String sPhaseNo = "";
	//仅查看自己签署的意见所对应的阶段
	String sSelfOpinionPhase = "";
	//人工认定理由
	String sSelfOpinion = "";
	//阶段名称
	String sPhaseName = "";
	//处理人
	String sUserName = "";
	//处理人所属机构
	String sOrgName = "";
	//收到时间
	String sBeginTime = "";
	//完成时间
	String sEndTime = "";
	//客户名称
	String sCustomerName = "";
	//模型分类结果
	String sModeResult = "";
	//人工认定结果
	String sSelfOpinionReason = "";

	int iTermYear = 0;
	int iTermMonth = 0;
	int iTermDay = 0;
	//用于判断记录是否有审批意见
	int iCountRecord=0;
	//用于标记行数
	int iRow=0,jRow=0;
	
	ASResultSet rs = null;
	
	//获取仅查看自己签署的意见所对应的阶段
	sSql = 	" select Attribute6 from FLOW_MODEL "+
			" where FlowNo =:FlowNo and PhaseNo =:PhaseNo ";
	SqlObject so = new SqlObject(sSql);
	so.setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo);
	sSelfOpinionPhase = Sqlca.getString(so);
	if(sSelfOpinionPhase == null) sSelfOpinionPhase = "";
	//获取仅查看自己签署的意见信息
	if(!sSelfOpinionPhase.equals("")){
		sSql = " select FO.CustomerName, getItemName('ClassifyResult',FO.PhaseOpinion) as PhaseOpinion, getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1, FO.PhaseOpinion2, " + //
		       " FT.PhaseName, FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime " +
		       " from FLOW_OPINION FO, FLOW_TASK FT " + 
		       " where FT.Serialno=FO.SerialNo "+             
               " and (FO.PhaseOpinion is not null) "+
               " and FO.InputUser =:InputUser "+
               " and FT.ObjectNo=:ObjectNo "+
               " and FT.ObjectType=:ObjectType"+
               " and FT.FlowNo =:FlowNo "+
               " and FT.PhaseNo=:PhaseNo ";
        so = new SqlObject(sSql);
        so.setParameter("InputUser",CurUser.getUserID()).setParameter("ObjectNo",sObjectNo)
        .setParameter("ObjectType",sObjectType).setParameter("FlowNo",sCurFlowNo).setParameter("PhaseNo",sCurPhaseNo);
		rs = Sqlca.getASResultSet(so);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			sSelfOpinion = rs.getString("PhaseOpinion2");
			sModeResult = rs.getString("PhaseOpinion1");
			sSelfOpinionReason = rs.getString("PhaseOpinion");
			sPhaseName = rs.getString("PhaseName");
			sUserName = rs.getString("UserName");
			sOrgName = rs.getString("OrgName");
			sBeginTime = rs.getString("BeginTime");
			sEndTime = rs.getString("EndTime");
			iCountRecord = iCountRecord + 1;
		}
		rs.getStatement().close();
	}
	
	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2	
	sSql =  " select FO.CustomerName, "+         
            " FT.FlowNo,FT.PhaseNo,FT.PhaseName,FT.UserName,FT.OrgName,FT.PhaseAction, "+
            " FT.BeginTime,FT.EndTime,FT.PhaseChoice, getItemName('ClassifyResult',FO.PhaseOpinion) as PhaseOpinion, getItemName('ClassifyResult',FO.PhaseOpinion1) as PhaseOpinion1,FO.PhaseOpinion2, "+
            " FM.Attribute3 as OpinionRightType,FM.Attribute4 as OpinionRightPhases,FM.Attribute5 as OpinionRightRoles "+
            " from FLOW_TASK FT,FLOW_OPINION FO,FLOW_MODEL FM "+
            " where FT.Serialno=FO.SerialNo "+
            " and FT.FlowNo=FM.FlowNo "+
            " and FT.PhaseNo=FM.PhaseNo "+
            " and (FO.PhaseOpinion is not null) "+
            " and FT.ObjectNo=:ObjectNo "+
            " and FT.ObjectType=:ObjectType";
	
	if(sSelfOpinionPhase.equals("")){
		sSql += " ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("ObjectNo",sObjectNo).setParameter("ObjectType",sObjectType);
	}else{
		sSql += " and FT.PhaseNo <> :FT.PhaseNo ORDER BY FT.SerialNo";
		so = new SqlObject(sSql);
		so.setParameter("FT.ObjectNo",sObjectNo)
		.setParameter("FT.ObjectType",sObjectType).setParameter("FT.PhaseNo",sSelfOpinionPhase);
	}
	rs=Sqlca.getASResultSet(so);
%>
<html>
<head>
<title>审批详情</title>
</head>
<body  leftmargin="0" topmargin="0" class="pagebackground"  >
  <form name="opinion">
  <table width="100%"  height="100%" cellpadding="3" cellspacing="0" border="0" style="overflow:auto;overflow-x:visible;overflow-y:visible">
  	<tr>
  		<!--暂时隐藏 
  		<td>
			<%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","spreadsheetTransfer(formatContent());",sResourcesPath)%>
		</td> -->
	</tr>
    <%
        
        while (rs.next())
        {
			sOpinionRightType = rs.getString("OpinionRightType");    //查看意见方式 all_except(排除一些阶段) none_except(选择一些阶段)
			sOpinionRightPhases = rs.getString("OpinionRightPhases");//不同查看意见方式对应的阶段
			sOpinionRightRoles = rs.getString("OpinionRightRoles");  //意见查看特权角色
			sPhaseAction = rs.getString("PhaseAction");
			//将空值转化为空字符串
			if(sOpinionRightType == null) sOpinionRightType = "";
			if(sOpinionRightPhases == null) sOpinionRightPhases = "";
			if(sOpinionRightRoles == null) sOpinionRightRoles = "";
			if(sPhaseAction == null) sPhaseAction = "";

			//1、判断该用户是否拥有特权角色
			if(sOpinionRightRoles.equals("")) bRolePrivilege = false;
			else{
				ArrayList<String> roles = CurUser.getRoleTable();
				for(int i=0;i<roles.size();i++){
					if(sOpinionRightRoles.indexOf(roles.get(i))>=0){
						bRolePrivilege = true;
						break;
					}
				}
			}
			
			//2、判断当前意见所处阶段是否在模型对应的特权阶段
			if(sOpinionRightPhases.equals("")) bPhaseMatch = false;			
			else{
				int iCountPhases = StringFunction.getSeparateSum(sOpinionRightPhases,",");
				
				String sTempFlowPhase,sTempFlow,sTempPhase;
				for(int i=0;i<iCountPhases;i++){
					sTempFlowPhase = StringFunction.getSeparate(sOpinionRightPhases,",",i+1);					
					if(sTempFlowPhase.indexOf(".")<0) sTempFlowPhase = sCurFlowNo + "." + sTempFlowPhase;					
					if(sTempFlowPhase.equals(sCurFlowNo+"."+sCurPhaseNo)){
						bPhaseMatch = true;
						break;
					}
				}
			}
			
			//3、根据查看意见方式的不同，判断是否可以显示
			if(sOpinionRightType.equals("") || sOpinionRightType.equals("none_except")){
				bPhasePrivilege = bPhaseMatch;
			}else{
				bPhasePrivilege = !bPhaseMatch;				
			}
			
			//bPhasePrivilege = true; bRolePrivilege = true;
			//4、最终判断是否显示意见，如果不需要显示，则继续判断下一条意见
			//该用户是否具有特权角色、该阶段意见是否属于该意见可查看阶段、该阶段是否属于			
			if(!bPhasePrivilege && !bRolePrivilege && sPhaseAction.indexOf("补充资料")<0) continue;
			iCountRecord++;						
    %>
    <tr>
	<td valign="top">
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=iRow++%>>
			<td width=50%><b>阶段名称:</b><%=DataConvert.toString(rs.getString("PhaseName"))%><input type=hidden value='阶段名称：<%=DataConvert.toString(rs.getString("PhaseName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%> ></td>
            <td width=50%><b>处理人:</b><%=DataConvert.toString(rs.getString("UserName"))%><input type=hidden value='处理人：<%=DataConvert.toString(rs.getString("UserName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        <tr id=<%=iRow++%>>
			<td width=50%><b>处理人所属机构:</b><%=DataConvert.toString(rs.getString("OrgName"))%><input type=hidden value='处理人所属机构：<%=DataConvert.toString(rs.getString("OrgName"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>客户名称:</b><%=DataConvert.toString(rs.getString("CustomerName"))%><input type=hidden value='客户名称：<%=DataConvert.toString(rs.getString("CustomerName"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
 
        <tr id=<%=iRow++%>>
            <td width=50%><b>模型分类结果:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%><input type=hidden value='模型分类结果:<%=DataConvert.toString(rs.getString("PhaseOpinion1"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>人工认定结果:</b><%=DataConvert.toString(rs.getString("PhaseOpinion"))%><input type=hidden value='人工认定结果:<%=DataConvert.toString(rs.getString("PhaseOpinion"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
              
        <tr id=<%=iRow++%>>
            <td width=50%><b>收到时间:</b><%=DataConvert.toString(rs.getString("BeginTime"))%><input type=hidden value='收到时间：<%=DataConvert.toString(rs.getString("BeginTime"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(rs.getString("EndTime"))%><input type=hidden value='完成时间：<%=DataConvert.toString(rs.getString("EndTime"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=iRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n【认定理由】"+ StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n【认定理由】"+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(iRow)+"L"%>>
            <input type=hidden value='amarsoft' name=<%="R"+String.valueOf(iRow)+"R"%>>	<!--用于判断是否插入一行一列-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>
    <%
    }
    rs.getStatement().close();
    
    //展现背靠背审批自己签署的意见
    if(!sSelfOpinionPhase.equals(""))
    {
    %>
    <tr>
	<td>
	  <table width=90%  cellpadding="4" cellspacing="0" border="1" bordercolorlight="#666666" bordercolordark="#FFFFFF" >
        <tr id=<%=jRow++%>>
			<td width=50%><b>阶段名称:</b><%=DataConvert.toString(sPhaseName)%><input type=hidden value='阶段名称：<%=DataConvert.toString(sPhaseName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>处理人:</b><%=DataConvert.toString(sUserName)%><input type=hidden value='处理人：<%=DataConvert.toString(sUserName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        <tr id=<%=jRow++%>>
			<td width=50%><b>处理人所属机构:</b><%=DataConvert.toString(sOrgName)%><input type=hidden value='处理人所属机构：<%=DataConvert.toString(sOrgName)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>客户名称:</b><%=DataConvert.toString(sCustomerName)%><input type=hidden value='客户名称：<%=DataConvert.toString(sCustomerName)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
       
        <tr id=<%=iRow++%>>
            <td width=50%><b>模型分类结果:</b><%=DataConvert.toString(rs.getString("PhaseOpinion1"))%><input type=hidden value='模型分类结果:<%=DataConvert.toString(rs.getString("PhaseOpinion1"))%>' name=<%="R"+String.valueOf(iRow)+"L"%>></td>
            <td width=50%><b>人工认定结果:</b><%=DataConvert.toString(rs.getString("PhaseOpinion"))%><input type=hidden value='人工认定结果:<%=DataConvert.toString(rs.getString("PhaseOpinion"))%>' name=<%="R"+String.valueOf(iRow)+"R"%>></td>
        </tr>       
       
        <tr id=<%=jRow++%>>
            <td width=50%><b>收到时间:</b><%=DataConvert.toString(sBeginTime)%><input type=hidden value='收到时间：<%=DataConvert.toString(sBeginTime)%>' name=<%="R"+String.valueOf(jRow)+"L"%>></td>
            <td width=50%><b>完成时间:</b><%=DataConvert.toString(sEndTime)%><input type=hidden value='完成时间：<%=DataConvert.toString(sEndTime)%>' name=<%="R"+String.valueOf(jRow)+"R"%>></td>
        </tr>
        
        <tr id=<%=jRow++%>>
            <td  colspan=2 align=center>
                <textarea type=textfield  bgcolor="#FDFDF3" readonly style="width:100%;height:170px;resize: none;">
                     <%="\r\n【认定理由】"+ StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")
                     %>
                </textarea>
            <input type=hidden value='<%="\r\n【认定理由】"+StringFunction.replace(DataConvert.toString(sSelfOpinion).trim(),"\\r\\n","\r\n")%>' name=<%="R"+String.valueOf(jRow)+"L"%>>
            <input type=hidden value='amarsoft' name=<%="R"+String.valueOf(jRow)+"R"%>>	<!--用于判断是否插入一行一列-->
            </td>
        </tr>        
      </table>
	  </td>
    </tr>
    <tr>
	<td>&nbsp;
	  </td>
    </tr>    
    <%
    }
    %>
	<tr>
  		<!--暂时隐藏
  		<td>
			<%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","spreadsheetTransfer(formatContent());",sResourcesPath)%>
		</td>-->
	</tr>
  </table>
  </form>
</body>
</html>
<%
	//如果没有意见或者没有找到对应的对象，则自动关闭
	if (iCountRecord==0||sObjectNo.equals("")){
%>
<body style={color:red}>目前此业务还没有您可以查看的审批意见！</body>
<%
	}
%>
<script type="text/javascript">
function formatContent()
{
	var sContentNew = "",i=0;
	var iRowCount = 1;
	if("<%=sSelfOpinionPhase%>" != "")	iRowCount =<%=jRow%>;
	else iRowCount =<%=iRow%>;

	var iColCount = 2;
	var sHeader = "【流水号】"+"<%=sObjectNo%>";

	sContentNew += "<STYLE>"; 
	sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
	sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '黑体','宋体';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '黑体','宋体';font-size: 9pt;font-weight:bold;text-decoration: none}"
	sContentNew += "</STYLE>";
	
	sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
	sContentNew += "<tr>";
	sContentNew += "    <td colspan="+iColCount+" align=middle style='color:black;padding-left:2px;background:silver;font-size:18.0pt;font-weight:700;font-family:黑体;' height=53>业务审查审批意见</td>";
	sContentNew += "</tr>";
	sContentNew += "<tr>";
	sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;'>"+sHeader+"</td>";
	sContentNew += "</tr>";
	
	for(i=1;i<=iRowCount;i++)
	{
		
		if(document.forms["opinion"].elements["R"+i+"R"].value == "amarsoft")
		{   //意见框只插入一行一列
			sContentNew += "<tr height=50 style='mso-height-source:userset;height:38.1pt'>";
			sContentNew += "    <td colspan="+iColCount+" align=left style='background-color:#CCC8EB;color:black;padding-left:2px;mso-font-charset:0;vertical-align:top;text-align:left;'>"+document.forms["opinion"].elements["R"+i+"L"].value+"</td>";
			sContentNew += "</tr>";
		}
		else
		{
			sContentNew += "<tr>";
			sContentNew += "    <td align=left>"+document.forms["opinion"].elements["R"+i+"L"].value+"</td>";
			sContentNew += "    <td align=left>"+document.forms["opinion"].elements["R"+i+"R"].value+"</td>";
			sContentNew += "</tr>";
		}
	}	
	
	sContentNew += "</table>";
	//防止因导出数据量太小，导出EXCEL时变成乱码
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	
	return(sContentNew);		
}
</script>
<%@ include file="/IncludeEnd.jsp"%>