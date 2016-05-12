<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	/*
	Author:  syang 2009/10/30
	Tester:
	Content: 工作台待处理五级分类提醒
	Input Param:		
	Output param:		                
	History Log: 		                 
	*/
	
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	String selectClause,whereClause,fromClause,orderClause;
	ASResultSet rs = null;
	String sTipsFlag = "";
	int countApplay=0;
	
	fromClause = " from FLOW_TASK FT,CLASSIFY_RECORD CR,BUSINESS_DUEBILL BD";
	whereClause = " where 1=1 "
	 +" and FT.ObjectType = 'Classify'"
	 +" and FT.ObjectNo = CR.SerialNo"
	 +" and FT.FlowNo = 'ClassifyFlow'"
	 +" and FT.PhaseNo <> '1000' "
	 +" and FT.UserID =:UserID"
	 +" and CR.ObjectNo = BD.SerialNo"
	 +" and (FT.EndTime is null or FT.EndTime = ' ')"
	 ;
	orderClause = " order by FT.SerialNo desc";
	
	if(sFlag.equals("0")){
		selectClause = 	" select count(CR.SerialNo) ";
		sSql = selectClause+fromClause+whereClause;
		rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rs.next())  countApplay = rs.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rs.getStatement().close();
	}else if(sFlag.equals("1")){
		selectClause = "select getBusinessName(BusinessType)"
				+" ||'&nbsp;['||nvl(getItemName('ClassifyResult', FinallyResult),'')"
				+" ||']&nbsp;'||BD.CustomerName"
				+" ||'&nbsp;'||CR.ObjectNo,"
				+" BD.Balance as Balance,"
				+" FT.SerialNo as SerialNo,"
				+" FT.PhaseNo as PhaseNo"
				;

		sSql = selectClause+fromClause+whereClause+orderClause;	
		rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		%>
		<table>
		<%
		while(rs.next()){
		%>
   		<tr>
   	<%
	   	if(rs.getString("PhaseNo").equals("0010")){//新增还未提交或发回补充资料
    %>
				<td align="left" >
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=资产风险分类认定申请&ComponentType=MainWindow&ApplyType=ClassifyApply","_top","");'><%=rs.getString(1)%>&nbsp;</a>
				</td>
    <%
      	}else{//待审查审批				                        	
		%>
				<td align="left" >
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=资产风险分类认定申请&ComponentType=MainWindow&ApproveType=ClassifyApprove","_top","");' ><%=rs.getString(1)%>&nbsp;</a>
				</td>
		<%
			}
		%>
				<td align="right" valign="bottom"><%=DataConvert.toMoney(rs.getDouble("Balance"))%>&nbsp;</td>
			</tr>
		<%
		}
		rs.getStatement().close();
	}
%>
	</table>
<%@ include file="/IncludeEndAJAX.jsp"%>