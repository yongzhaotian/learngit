<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase=	" from BUSINESS_CONTRACT BC, FLOW_OBJECT FO "+
				" where BC.SerialNo = FO.ObjectNo "+
				" and FO.ObjectType='BusinessContract' "+
				" and FO.UserID=:UserID "+
				" and BC.Stores=:StoreID"+
			    " and PhaseType in ('1010','1030')";
	// 1626  1628  modify by yzhang9 CCS-571
 	if(CurUser.hasRole("1620")||CurUser.hasRole("1622")){
   		if(!CurUser.hasRole("1006")&&  !CurUser.hasRole("1626") && !CurUser.hasRole("1628")){
		WhereCase+=" and FO.ApplyType='CashLoanApply' ";
   		}
	} 
	
   	if(CurUser.hasRole("1006")||CurUser.hasRole("1626")||CurUser.hasRole("1628")){
   		if((!CurUser.hasRole("1620"))&&(!CurUser.hasRole("1622"))){
   			WhereCase+=" and FO.ApplyType <> 'CashLoanApply' ";
   	   		}
   	} 

   	//add by yzhang9 CCS-571 
   if(CurUser.hasRole("1626")||CurUser.hasRole("1628")){
   			if((!CurUser.hasRole("1620"))&&(!CurUser.hasRole("1622"))&&(!CurUser.hasRole("1006"))){
   				WhereCase+=" and FO.ApplyType = 'CreditLineApply' ";
   	   		}
   	} 
   	
	if(CurUser.hasRole("1006")||CurUser.hasRole("1620")||CurUser.hasRole("1622")){
   		if((!CurUser.hasRole("1626"))&&(!CurUser.hasRole("1628"))){
   			WhereCase+=" and FO.ApplyType <> 'CreditLineApply' ";
   	   		}
   	} 
   	// end by yzhang9
  
	if(sFlag.equals("0")){
		sSql = 	" select count(BC.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()).setParameter("StoreID",CurUser.getAttribute8()));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select getItemName('ApplyType',FO.ApplyType)||'&nbsp;['||getBusinessName(BC.BusinessType)||']'||'&nbsp;['||BC.CustomerName||']'||'&nbsp;['||FO.PhaseName||']', "+
			  " BC.BusinessSum,FO.ApplyType,FO.InputDate,FO.PhaseName,FO.PhaseNo,FO.PhaseType ";
		sSql = sSql+ WhereCase + " order by FO.ApplyType";
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()).setParameter("StoreID",CurUser.getAttribute8()));
		
		while(rsTips.next()){
			if (rsTips.getString(4).substring(0,10).equals(StringFunction.getToday()))
				sTipsFlag="&nbsp;&nbsp;";
			else
				sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
				
		%>
                      	<tr>
                      	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=<%=rsTips.getString(3)%>&PhaseType=<%=rsTips.getString(7)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                     		<td align="right" valign="bottom"><%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                     	<br></tr>
		<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>