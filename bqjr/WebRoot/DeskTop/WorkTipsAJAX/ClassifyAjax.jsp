<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	/*
	Author:  syang 2009/10/30
	Tester:
	Content: ����̨�������弶��������
	Input Param:		
	Output param:		                
	History Log: 		                 
	*/
	
	//�����꣬sFlag ="1"
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
		out.println(countApplay); //ajax�Ĵ�ӡ������ɾ��
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
	   	if(rs.getString("PhaseNo").equals("0010")){//������δ�ύ�򷢻ز�������
    %>
				<td align="left" >
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=�ʲ����շ����϶�����&ComponentType=MainWindow&ApplyType=ClassifyApply","_top","");'><%=rs.getString(1)%>&nbsp;</a>
				</td>
    <%
      	}else{//���������				                        	
		%>
				<td align="left" >
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=�ʲ����շ����϶�����&ComponentType=MainWindow&ApproveType=ClassifyApprove","_top","");' ><%=rs.getString(1)%>&nbsp;</a>
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