<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//�����꣬sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql,WhereCase;
	ASResultSet rsTips=null;
	String sTipsFlag;
	int countApplay=0;
	String[] sRoleIDs={"000","099","1032","1034"};     //ӵ��ע���ͬȨ�޵Ľ�ɫ
	boolean hasRoles=CurUser.hasRole(sRoleIDs);   //�жϵ�ǰ�û��Ƿ����ע���ͬ��Ȩ��
	// select PackNo,ContractNum,CreditPerson,PostBillNo,getItemName('PackStatus',Status) as Status,getItemName('PackType',PackType) as PackType,CreateUser,getusername(CreateUser) as CreateUserName,CreateDate,CreditID from Package_Info WHERE status='01' and packtype='02'
	WhereCase=	" from Package_Info WHERE status='01' and packtype='02' and CreateUser=:CreateUser ";
	if(sFlag.equals("0")){
		sSql = 	" select count(PackNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CreateUser", CurUser.getUserID()));
		if(rsTips.next())  countApplay = rsTips.getInt(1);
		if(!hasRoles)  countApplay = 0;
		out.println(countApplay); //ajax�Ĵ�ӡ������ɾ��
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= "select PackNo,ContractNum,CreditPerson,PostBillNo, getusername(CreateUser) as CreateUserName ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("CreateUser", CurUser.getUserID()));
		if(hasRoles){
		while(rsTips.next()){
			sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
%>				<tr>
          			<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('PackageManageMain','/BusinessManage/ContractManage/PackageManageMain.jsp','ComponentName=ע�Ჿ���ʼİ���&TreeviewTemplet=PackageManageMain','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                	<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                <br></tr>
<%
		  }
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>