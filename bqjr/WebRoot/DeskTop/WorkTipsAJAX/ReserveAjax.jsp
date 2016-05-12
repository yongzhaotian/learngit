<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%

	/*
	Author:  syang 2009/10/30
	Tester:
	Content: 待处理的单项计提减值准备
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
	
	fromClause = " from FLOW_TASK FT, RESERVE_APPLY RA";
	 
	whereClause = " where 1=1 "
		+" and FT.ObjectType = 'Reserve'"
		+" and FT.ObjectNo = RA.SerialNo"
		+" and FT.FlowNo = 'ReserveFlow'"
		+" and FT.PhaseNo <> '8000'"		//单项计提转组合计提（审批通过了）
		+" and FT.UserID =:UserID"
		+" and (FT.EndTime is null or FT.EndTime = ' ')"
		;
	orderClause = " order by FT.SerialNo desc" ;
	
	if(sFlag.equals("0")){
		selectClause = 	" select count(RA.SerialNo) ";
		sSql = selectClause+fromClause+whereClause;
		rs = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rs.next())  countApplay = rs.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rs.getStatement().close();
	}else if(sFlag.equals("1")){
		selectClause = "select "
			+" '['||RA.AccountMonth||']'"
			+" ||'&nbsp;'||RA.DuebillNo"
			+" ||'&nbsp;'||RA.CustomerName,"
			+" RA.Balance as Balance,"
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
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApplyMain","/Common/WorkFlow/ApplyMain.jsp","ComponentName=认定申请&ComponentType=MainWindow&ApplyType=ReserveApply","_top","");'><%=rs.getString(1)%>&nbsp;</a>
				</td>
    <%
      }else{//待审查审批				                        	
		%>
				<td align="left" >
					<%=sTipsFlag%><a href='javascript:OpenComp("CreditApproveMain","/Common/WorkFlow/ApproveMain.jsp","ComponentName=单项减值准备审查审批&ComponentType=MainWindow&ApproveType=ReserveApprove","_top","");' ><%=rs.getString(1)%>&nbsp;</a>
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