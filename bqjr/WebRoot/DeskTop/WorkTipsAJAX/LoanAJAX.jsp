<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<% 	
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	ASResultSet rsTips=null;
	String sTipsFlag,WhereCase;
	int countLoan=0;
	WhereCase=	" from BUSINESS_PUTOUT BP, FLOW_TASK FT "+
				" where BP.SerialNo=FT.ObjectNo "+
				" and FT.ObjectType='PutOutApply' "+
				" and FT.UserID=:UserID "+
				" and (FT.EndTime is null "+
				" or FT.EndTime = ' ') "+
				" and (FT.PhaseAction is null "+
				" or FT.PhaseAction = ' ') ";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(BP.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rsTips.next())  countLoan = rsTips.getInt(1);
		out.println(countLoan); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql = 	" select getBusinessName(BP.BusinessType)||'&nbsp;['||BP.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
				" BP.BusinessSum,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		while(rsTips.next()){
			if (rsTips.getString(3).substring(0,10).equals(StringFunction.getToday()))
			{
				sTipsFlag="&nbsp;&nbsp;";
			}else{
				sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
			}
%>
             	<tr>
  			<%
            	if(rsTips.getString(5).equals("0010") || rsTips.getString(5).equals("3000"))
            	{//新增还未提交或发回补充资料
            %>
             	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=PutOutApply&PhaseType=<%=rsTips.getString(6)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
        	<%
        				}else{ //待复核
        	%>
             	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('PutOutApproveMain','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApprovePutOutApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%></a>&nbsp;</td>
        	<%
        				}
        	%>
            	   <td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
            	<br></tr>
<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>