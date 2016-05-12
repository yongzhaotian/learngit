<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase=	" from BUSINESS_CONTRACT BC, FLOW_TASK FT "+
				" where BC.SerialNo = FT.ObjectNo "+
				" and FT.ObjectType='BusinessContract' "+
				" and FT.UserID=:UserID "+
				" and (FT.EndTime is null "+
				" or FT.EndTime = ' ') "+
				" and (FT.PhaseAction is null "+
				" or FT.PhaseAction = ' ')  and FT.PhaseType='1020'";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(BC.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select getItemName('ApplyType',FT.ApplyType)||'&nbsp;['||getBusinessName(BC.BusinessType)||']'||'&nbsp;['||BC.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
			  " BC.BusinessSum,FT.ApplyType,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType ";
		sSql = sSql+ WhereCase + " order by FT.ApplyType, FT.begintime";
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		while(rsTips.next()){
			if (rsTips.getString(4).substring(0,10).equals(StringFunction.getToday()))
				sTipsFlag="&nbsp;&nbsp;";
			else
				sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
		%>
                      	<tr>
                     		<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApproveMain','/Common/WorkFlow/ApproveMainNew.jsp','ApproveType=XFApprove&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
       
                     		<td align="right" valign="bottom"><%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                     	<br></tr>
		<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>