<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	//点击鼠标，sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	if(sFlag == null) sFlag ="";
	String sSql;
	SqlObject so = null;
	ASResultSet rs=null;
	String sWorkBrief="",WhereCase="";
	int countPlan=0;
	
	WhereCase=	" from WORK_RECORD W where W.PromptBeginDate <=:PromptBeginDate "+
				" and W.PromptEndDate >=:PromptEndDate "+				
				" and (W.ActualFinishDate is null or W.ActualFinishDate=' ') "+
				" and W.OperateUserID =:OperateUserID  ";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(SerialNo) ";
		sSql = sSql+ WhereCase;
		so = new SqlObject(sSql).setParameter("PromptBeginDate",StringFunction.getToday())
		.setParameter("PromptEndDate",StringFunction.getToday()).setParameter("OperateUserID",CurUser.getUserID());
		rs = Sqlca.getResultSet(so);
		if(rs.next())  countPlan = rs.getInt(1);
		out.println(countPlan); //ajax的打印，不能删除
		rs.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql = 	" select W.SerialNo,GetItemName('WorkType',WorkType)  as WorkType,W.WorkBrief,W.PlanFinishDate,W.ActualFinishDate,"+
				" getOrgName(W.OperateOrgID) as OrgName,getUserName(W.OperateUserID) as UserName,Importance,Urgency ";
		sSql = sSql+ WhereCase;
		so = new SqlObject(sSql).setParameter("PromptBeginDate",StringFunction.getToday())
		.setParameter("PromptEndDate",StringFunction.getToday()).setParameter("OperateUserID",CurUser.getUserID());
		rs = Sqlca.getResultSet(so);
	
		int iWorks=1;
		while(rs.next()){
			sWorkBrief = DataConvert.toString(rs.getString("WorkBrief"));
%>
			<tr>
				<td align="left" title="<%=sWorkBrief%>" >
				<%
			String sImportance = DataConvert.toString(rs.getString("Importance"));
			if(!sImportance.equals("01"))//工作重要性（01：一般；02：重要：03：非常重要）
			{
				%>
					<img  width=12 height=12 src="<%=sResourcesPath%>/alarm/icon4.gif">
				<%
			}else{
				%>
					&nbsp;&nbsp;
				<%
			}
				%>
					<a href="javascript:popComp('WorkRecordInfo','/DeskTop/WorkRecordInfo.jsp','SerialNo=<%=rs.getString("SerialNo")%>', 'dialogwidth:640px;dialogheight:480;')">
				<%=iWorks%><%=". ["+DataConvert.toString(rs.getString("WorkType"))+"]"%>&nbsp;&nbsp;
<%
			if(sWorkBrief.length()>10) sWorkBrief = sWorkBrief.substring(0,10)+"...";
			out.println(sWorkBrief);
%>
			      	</a>
			    </td>
			    <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<br></tr>
<%
     		iWorks++;
		}
		rs.getStatement().close();
	}
%>
<%@ include file="/IncludeEndAJAX.jsp"%>