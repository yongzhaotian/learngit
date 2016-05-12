<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<% 	
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	ASResultSet rsTips=null;
	String sTipsFlag,WhereCase;
	int countLoan=0;
	WhereCase=	" from BUSINESS_APPROVE BA where OperateUserID =:OperateUserID "+
				" and ApproveType = '01'  and "+
				" SerialNo in (select ObjectNo from FLOW_OBJECT FO where FlowNo='ApproveFlow'  and PhaseNo='1000') "+
				" and SerialNo not in (select RelativeSerialNo from  BUSINESS_CONTRACT BC where RelativeSerialNo is not null)";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(SerialNo)  ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("OperateUserID",CurUser.getUserID()));
		if(rsTips.next())  countLoan = rsTips.getInt(1);
		out.println(countLoan); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= 	" select getBusinessName(BA.BusinessType)||'&nbsp;['||BA.CustomerName||']'||'&nbsp;', "+
				" BA.BusinessSum  ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("OperateUserID",CurUser.getUserID()));
		while(rsTips.next()){
			sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
%>				<tr>
          			<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('BookInContractMain','/CreditManage/CreditPutOut/BookInContractMain.jsp','ComponentName=待登记合同的最终审批意见&TreeviewTemplet=BookInContractMain','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                	<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                <br></tr>
<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>