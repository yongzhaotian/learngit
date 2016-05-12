<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<script type="text/javascript">
<%
	String sCurCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CurCompID"));
	String sTargetCompID = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetCompID"));
	String sTargetOrderNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("TargetOrderNo"));
	String sInjectionType = DataConvert.toRealString(iPostChange,CurPage.getParameter("InjectionType"));
	SqlObject so = null;
	String sNewSql = "";		
	if(sTargetOrderNo==null || sTargetOrderNo.equals("")){
		throw new Exception("û�н��ܵ�TargetOrderNo:"+sTargetOrderNo);
	}   
	int iTargetLength = sTargetOrderNo.length();
	int iLengthA = 0;
	if(iTargetLength<6)
		iLengthA=2;
	else
		iLengthA=iTargetLength-4;
	int iLengthB = iTargetLength-iLengthA;
	
	String sOrderNoA = sTargetOrderNo.substring(0,iLengthA);
	sNewSql = "select OrderNo from REG_COMP_DEF where CompID=:CompID";
	so=new SqlObject(sNewSql).setParameter("CompID",sCurCompID);
	String sOldOrderNo = Sqlca.getString(so);
	
	//�������ڵ�һ��ֱ�Ӳ���
	if(sCurCompID.equals(sTargetCompID)){
		%>
		alert("�벻Ҫѡ�������");
		top.returnValue="failed";
		<%
	}else if(sTargetOrderNo.indexOf(sOldOrderNo)==0){
		%>
		alert("�벻Ҫѡ���������������¼������");
		top.returnValue="failed";
		<%
	}else if(iTargetLength==2 && sInjectionType!=null && !sInjectionType.equals("below")){
		%>
		alert("�벻Ҫ�ڵ�һ����룬ѡ����ϸ���ѡ���ڡ�֮�¡����룡");
		top.returnValue="failed";
		<%
	}else if(sTargetOrderNo.indexOf("0")==0){
		%>
		alert("�벻Ҫ��0��ͷ���֮ǰ������֮�󡱻�֮�¡����롣");
		top.returnValue="failed";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("before")){
		//��TargetComp����֮������������SortNo��ǰ iTargetLength λ��10
		//���ȴ��ڵ������� 
		//modifyed by sxwang 2009.02.16 
		String sSql =  "";
		sNewSql = "select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>=:TargetLength "+
		" and OrderNo>=:TargetOrderNo "+
		" and OrderNo like :OrderNoA "+
		//" and OrderNo not like '"+sOldOrderNo+"%'"//�ų���ǰ������¼����
		" Order by OrderNo desc";
		so=new SqlObject(sNewSql);
		so.setParameter("TargetLength",iTargetLength);
		so.setParameter("TargetOrderNo",sTargetOrderNo);
		so.setParameter("OrderNoA",sOrderNoA+"%");
		ASResultSet rs=Sqlca.getASResultSet(so);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//λ����������λ�Զ�ֵ0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
				so = new SqlObject(sNewSql);
				so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
				Sqlca.executeSQL(so);
			}
		}
		rs.getStatement().close();
		
		//��ȡ��ǰ�����OrderNo
		sOldOrderNo="";
		sNewSql = "Select OrderNo from REG_COMP_DEF  where CompID = :CompID";
		so = new SqlObject(sNewSql).setParameter("CompID",sCurCompID);
		rs=Sqlca.getASResultSet(so);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
        	//��ǰ�����OrderNo����ΪsTargetOrderNo
        	sNewSql = "update REG_COMP_DEF set OrderNo=:OrderNo where CompID = :CompID";
    		so = new SqlObject(sNewSql);
    		so.setParameter("CompID",sCurCompID).setParameter("OrderNo",sTargetOrderNo);
        	Sqlca.executeSQL(so);
        	sNewMaxOrderNo=sTargetOrderNo;
			//���µ�ǰ����¼����
    		sNewSql = "select OrderNo from REG_COMP_DEF "+
			" where OrderNo like :OldOrderNo and length(OrderNo)>:OldOrderNoLength "+
			" order by OrderNo desc";
        	so = new SqlObject(sNewSql);
       		so.setParameter("OldOrderNo",sOldOrderNo+"%").setParameter("OldOrderNoLength",sOldOrderNo.length());
    		rs=Sqlca.getASResultSet(so);
    		while(rs.next()){
    			String sOldOrderNo1=rs.getString("OrderNo");
    			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
    			sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
    			so = new SqlObject(sNewSql);
    			so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
    			Sqlca.executeSQL(so);
    		}
    		rs.getStatement().close();
        }
		%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮ǰ��");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("after")){
		//��TargetComp����֮������������SortNo��ǰ iTargetLength λ��10
		//���ȴ��ڵ�������              
		//modifyed by sxwang 2009.02.16                                     
		String sSql = "";
		sNewSql = "select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>=:TargetLength "+
		" and OrderNo>:TargetOrderNo1 "+
		" and OrderNo not like :TargetOrderNo2 "+ //�ų�Ŀ������Լ��¼����
		" and OrderNo like :OrderNoA "+
		//"and OrderNo not like '"+sOldOrderNo+"%'";//�ų���ǰ������¼����
		" Order by OrderNo desc";
		so=new SqlObject(sNewSql);
		so.setParameter("TargetLength",iTargetLength);
		so.setParameter("TargetOrderNo1",sTargetOrderNo);
		so.setParameter("TargetOrderNo2",sTargetOrderNo+"%");
		so.setParameter("OrderNoA",sOrderNoA+"%");
		ASResultSet rs=Sqlca.getASResultSet(so);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sOldOrderNo1.trim();
			if(sNewOrderNo.length()>=iTargetLength){
				double dNewOrderNo=DataConvert.toDouble(sNewOrderNo.substring(0,iTargetLength));
				dNewOrderNo+=10;
				String sNewOrder1=new DecimalFormat("##").format(dNewOrderNo);
				//λ����������λ�Զ�ֵ0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				//String sUpdateSql="update REG_COMP_DEF set OrderNo = '"+sNewOrderNo+"' where OrderNo='"+sOldOrderNo1+"'";
				sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
				so = new SqlObject(sNewSql);
				so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
				Sqlca.executeSQL(so);
			}
		}
		rs.getStatement().close();
	    
		//��ȡ��ǰ�����OrderNo
		sOldOrderNo="";
		sNewSql = "Select OrderNo from REG_COMP_DEF  where CompID = :CompID";
		so = new SqlObject(sNewSql).setParameter("CompID",sCurCompID);
		rs=Sqlca.getASResultSet(so);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
			//����ǰ�����OrderNo����ΪsTargetOrderNo+10
    		double dNewOrderNo=DataConvert.toDouble(sTargetOrderNo.substring(0,iTargetLength));
    		sNewMaxOrderNo=new DecimalFormat("##").format(dNewOrderNo+10);
    		while(sNewMaxOrderNo.length()<iTargetLength)sNewMaxOrderNo="0"+sNewMaxOrderNo;
    		sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo where CompID = :CompID";
    		so = new SqlObject(sNewSql);
    		so.setParameter("OrderNo",sNewMaxOrderNo).setParameter("CompID",sCurCompID);
    		Sqlca.executeSQL(so);
    		//���µ�ǰ������¼����
    		sNewSql = "select OrderNo from REG_COMP_DEF "+
    		" where OrderNo like :OrderNo1 and length(OrderNo)>:OrderNo2"+
    		" Order by OrderNo desc";
    		so = new SqlObject(sNewSql);
    		so.setParameter("OrderNo1",sOldOrderNo).setParameter("OrderNo2",sOldOrderNo.length());
    		rs=Sqlca.getASResultSet(so);
    		while(rs.next()){
    			String sOldOrderNo1=rs.getString("OrderNo");
    			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
    			sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
    			so = new SqlObject(sNewSql);
    			so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
    			Sqlca.executeSQL(so);
    		}
    		rs.getStatement().close();
        }
		%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮��");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("below")){
		//��TargetComp����֮������������SortNo��10
		//modifyed by sxwang 2009.02.16 
		sNewSql = "select max(OrderNo) from REG_COMP_DEF where OrderNo like :OrderNo1 and length(OrderNo)=:OrderNo2";
		so = new SqlObject(sNewSql);
		so.setParameter("OrderNo1",sTargetOrderNo+"%").setParameter("OrderNo2",sTargetOrderNo.length()+4);
		String sMaxOrderNo = Sqlca.getString(so);
		
		String sNewMaxOrderNo = "";
		if(sMaxOrderNo==null || sMaxOrderNo.equals(""))
			sNewMaxOrderNo = sTargetOrderNo+"0010";
		else{
			sNewMaxOrderNo = String.valueOf(Long.parseLong(sMaxOrderNo)+10);
			while(sNewMaxOrderNo.length()<iTargetLength+4)sNewMaxOrderNo="0"+sNewMaxOrderNo;
		}
		//����ǰ�����OrderNo����ΪsTargetOrderNo
		sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo where CompID = :CompID";
		so = new SqlObject(sNewSql);
		so.setParameter("CompID",sCurCompID).setParameter("OrderNo",sNewMaxOrderNo);
		Sqlca.executeSQL(so);
		//���µ�ǰ������¼����
		sNewSql = "select OrderNo from REG_COMP_DEF "+
		" where OrderNo like :OrderNo1 and length(OrderNo)>:OrderNo2"+
		" Order by OrderNo desc";
		so = new SqlObject(sNewSql);
		so.setParameter("OrderNo1",sOldOrderNo+"%").setParameter("OrderNo2",sOldOrderNo.length());
		ASResultSet rs=Sqlca.getASResultSet(so);
		while(rs.next()){
			String sOldOrderNo1=rs.getString("OrderNo");
			String sNewOrderNo=sNewMaxOrderNo+(sOldOrderNo1.length()>sOldOrderNo.length()?sOldOrderNo1.substring(sOldOrderNo.length()):"");
			sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
			so = new SqlObject(sNewSql);
			so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
			Sqlca.executeSQL(so);
		}
		rs.getStatement().close();
		%>		
		alert("�ɹ������<%=sCurCompID%>������<%=sTargetCompID%>֮�£�");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%	
	}
%>
self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>