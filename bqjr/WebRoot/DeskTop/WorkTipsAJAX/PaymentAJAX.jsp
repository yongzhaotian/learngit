<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%>	
<% 	


	/*
	Author:  smiao 2011.06.17
	Tester:
	Content: �������֧������
	Input Param:		
	Output param:		                
	History Log: 		                 
	*/
	
	//�����꣬sFlag ="1"
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));
	String sSql;
	ASResultSet rsTips=null;
	String sTipsFlag,WhereCase;
	int countPayment=0;
	WhereCase=	" from PAYMENT_INFO PI, FLOW_TASK FT "+
				" where PI.SerialNo=FT.ObjectNo "+
				" and FT.ObjectType='PaymentApply' "+
				" and FT.UserID=:UserID "+
				" and (FT.EndTime is null "+
				" or FT.EndTime = ' ') "+
				" and (FT.PhaseAction is null "+
				" or FT.PhaseAction = ' ') ";
	
	if(sFlag.equals("0")){
		sSql = 	" select count(PI.SerialNo) ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		if(rsTips.next())  countPayment = rsTips.getInt(1);
		out.println(countPayment); //ajax�Ĵ�ӡ������ɾ��
		rsTips.getStatement().close();
	}else if(sFlag.equals("1")){
		sSql = 	" select '['||PI.CustomerName||']'||'&nbsp;['||FT.PhaseName||']', "+
				" PI.PaymentSum,FT.BeginTime,FT.PhaseName,FT.PhaseNo,FT.PhaseType ";
		sSql = sSql+ WhereCase;
		rsTips = Sqlca.getResultSet(new SqlObject(sSql).setParameter("UserID",CurUser.getUserID()));
		while(rsTips.next()){
			if (rsTips.getString(3).substring(0,10).equals(StringFunction.getToday()))
			{
				sTipsFlag="&nbsp;&nbsp;";
			}else{
				sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt='�ù�����������ѳ���1��'>&nbsp;";
			}
%>
             	<tr>
  			<%
            	if(rsTips.getString(5).equals("0010") || rsTips.getString(5).equals("3000"))
            	{//������δ�ύ�򷢻ز�������
            %>
             	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('CreditApplyMain','/Common/WorkFlow/ApplyMain.jsp','ApplyType=PaymentApply&PhaseType=<%=rsTips.getString(6)%>&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%>&nbsp;</a></td>
        	<%
        				}else{ //������
        	%>
             	   <td align="left" ><%=sTipsFlag%><a href="javascript:OpenComp('PaymentApprove Main ','/Common/WorkFlow/ApproveMain.jsp','ApproveType=ApprovePaymentApply&DefaultTVItemName=<%=rsTips.getString("PhaseName")%>','_top','')"><%=rsTips.getString(1)%></a>&nbsp;</td>
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