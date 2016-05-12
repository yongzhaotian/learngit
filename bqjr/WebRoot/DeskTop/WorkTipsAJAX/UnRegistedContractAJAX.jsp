<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	String[] sRoleIDs={"000","099","1032","1034"};   //拥有注册合同权限的角色
	boolean hasRoles=CurUser.hasRole(sRoleIDs);//判断当前用户是否具有注册合同的权限
	WhereCase=" FROM business_contract"+
			  " WHERE TO_CHAR(to_date(PutOutDate, 'yyyy/mm/dd') +"+
			  " (CASE WHEN  "+
			  " (SELECT UserType FROM User_Info WHERE UserID = business_contract.Salesexecutive) = '01'"+
			  " THEN "+
			  " (select AttrNum1 from BasedataSet_Info where SerialNo = (select Max(serialno) as Serialno from BasedataSet_Info where TypeCode = 'ExpiredRegiste'))"+
			  " else"+
			  "(select AttrNum2 from BasedataSet_Info where SerialNo = (select Max(serialno) as Serialno  from BasedataSet_Info  where TypeCode = 'ExpiredRegiste')) END), 'yyyy/mm/dd') <= to_char(sysdate, 'yyyy/mm/dd')"+
			  "  AND ContractStatus = '080'";

		      //+
			//" AND business_contract.Operateuserid=:Operateuserid";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(SerialNo) ";
		sSql = sSql+ WhereCase;
		//rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("Operateuserid",CurUser.getUserID()));
		rsTips = Sqlca.getResultSet(new SqlObject(sSql));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		if(!hasRoles)  countApplay = 0;
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= 	" select serialno||' ['||customername||'] ', businesssum  ";
		sSql = sSql+ WhereCase;	
		//rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("Operateuserid",CurUser.getUserID()));
		rsTips = Sqlca.getResultSet(new SqlObject(sSql));
		if(hasRoles){
		while(rsTips.next()){
			sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
%>				<tr>
					 <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('QuickQueryMain','/InfoManage/QuickSearch/QuickQueryMain.jsp','ComponentName=超期未注册合同&TreeviewTemplet=QuickQueryMain&Display=合同快速查询','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                	<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                <br></tr>
<%
		}
	}
		rsTips.getStatement().close();
  }
%>
<%@ include file="/IncludeEndAJAX.jsp"%>