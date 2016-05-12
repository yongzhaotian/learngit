<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<% 	
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	ASResultSet rsTips=null;
	String sTipsFlag,WhereCase;
	int countLoan=0;
	String sSortNo=CurOrg.getSortNo()+"%";
	WhereCase = " from BUSINESS_APPLY BA,FLOW_OBJECT FO,FLOW_TASK FT where BA.SerialNo=FO.ObjectNo and BA.SerialNo=FT.ObjectNo and FO.ObjectType='CreditApply' " 
						 + "and (FO.PhaseNo='1000' or FO.PhaseNo= '8000')  and BA.OperateOrgID in (select OrgID from ORG_INFO where SortNo like :SortNo) and BA.FLAG5='010' "
	  					 + "and BA.OperateUserID =:UserID";  //modified by yzheng 2013-6-25
	if(sFlag.equals("0")){
		sSql = 	" select count(distinct BA.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo).setParameter("UserID", CurUser.getUserID()));  //modified by yzheng 2013-6-25
		if(rsTips.next())  countLoan = rsTips.getInt(1);
		out.println(countLoan); //ajax的打印，不能删除
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql= " select getBusinessName(BA.BusinessType)||'&nbsp;['||BA.CustomerName||']'||'&nbsp;', BA.BusinessSum, FT.EndTime";
		String WhereCase1 = " and FT.SerialNo = (select MAX(FTT.SerialNo) from FLOW_TASK FTT where FTT.ObjectType='CreditApply' and FTT.ObjectNo=BA.SerialNo)";
		sSql = sSql+ WhereCase + WhereCase1;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("SortNo",sSortNo).setParameter("UserID", CurUser.getUserID()));  //modified by yzheng 2013-6-25
		while(rsTips.next()){
		    sTipsFlag="&nbsp;&nbsp;";
		    if (rsTips.getString(3) != null) {
		        //通过判断申请的结束日期与当前日期是否相等来确定是否展示图片 add by cbsu 2009-11-04
			    if (!StringFunction.getToday().equals(rsTips.getString(3).substring(0,10))) {
	                sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='该工作完成期限已超过1天'>&nbsp;";
	            }
		    }
%>				<tr>
          			<td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ComponentName=最终审批意见登记&ComponentType=MainWindow&ApplyType=ApproveApply','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
                	<td align="right" valign="bottom">  <%=DataConvert.toMoney(rsTips.getDouble(2))%>&nbsp;</td>
                <br></tr>
<%
		}
		rsTips.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>