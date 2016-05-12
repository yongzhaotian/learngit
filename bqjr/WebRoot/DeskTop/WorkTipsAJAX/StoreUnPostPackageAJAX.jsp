<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	
	WhereCase="	from Package_Info WHERE status='01' and packtype='01' and CreateUser=:CreateUser and SNO=:SNO";
	// select PackNo,ContractNum,SNo,PostBillNo,getItemName('PackStatus',Status) as Status,getItemName('PackType',PackType) as PackType,CreateDate,CreateUser,getusername(CreateUser) as CreateUserName from Package_Info WHERE status='01' and packtype='01'
	if(sFlag.equals("0")){
		sSql = 	" select count(PackNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CreateUser", CurUser.getUserID()).setParameter("SNO", CurUser.getAttribute8()));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		out.println(countApplay); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select PackNo || ' [' || getstorename(SNo) || '] ', ContractNum,PostBillNo ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CreateUser", CurUser.getUserID()).setParameter("SNO", CurUser.getAttribute8()));
		while(rsTips.next()){
			sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
%>				<tr>
          			<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('ShopPackageMain','/BusinessManage/ContractManage/ShopPackageMain.jsp','ComponentName=门店未邮寄包裹&TreeviewTemplet=ShopPackageMain','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                	<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                <br></tr>
<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>