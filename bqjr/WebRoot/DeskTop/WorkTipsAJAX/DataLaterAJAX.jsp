<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<% 	
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	ASResultSet rsTips=null;
	String sTipsFlag,WhereCase;
	int countLoan=0;
	WhereCase=	" from Business_Contract BC"+
				" where BC.BusinessType in('1130010','1130020','1130030','1130040') "+
				" and BC.ReinforceFlag <>'020' and BC.MANAGEORGID=:MANAGEORGID";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(BC.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("MANAGEORGID",CurUser.getOrgID()));
		if(rsTips.next())  countLoan = rsTips.getInt(1);
		out.println(countLoan); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql = 	" select getBusinessName(BC.BusinessType)||'&nbsp;['||BC.CustomerName||']' ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("MANAGEORGID",CurUser.getOrgID()));
		while(rsTips.next()){
				sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 >&nbsp;";
%>
             <tr>
             	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('BusinessInputMain','/InfoManage/DataInput/BusinessInputMain.jsp','ComponentName=信贷业务补充登记&Component=N&ComponentType=MainWindow&DefaultTVItemName=需补登信贷业务','_top','')"><%=rsTips.getString(1)%></a>&nbsp;</td>
            
            	<br></tr>
<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>