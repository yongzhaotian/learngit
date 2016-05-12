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
		throw new Exception("没有接受到TargetOrderNo:"+sTargetOrderNo);
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
	
	//不允许在第一层直接插入
	if(sCurCompID.equals(sTargetCompID)){
		%>
		alert("请不要选择本组件！");
		top.returnValue="failed";
		<%
	}else if(sTargetOrderNo.indexOf(sOldOrderNo)==0){
		%>
		alert("请不要选择本组件及本组件的下级组件！");
		top.returnValue="failed";
		<%
	}else if(iTargetLength==2 && sInjectionType!=null && !sInjectionType.equals("below")){
		%>
		alert("请不要在第一层插入，选择明细项，或选择在“之下”插入！");
		top.returnValue="failed";
		<%
	}else if(sTargetOrderNo.indexOf("0")==0){
		%>
		alert("请不要在0开头的项“之前”、“之后”或“之下”插入。");
		top.returnValue="failed";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("before")){
		//将TargetComp及其之后的所有组件的SortNo的前 iTargetLength 位加10
		//长度大于等于它的 
		//modifyed by sxwang 2009.02.16 
		String sSql =  "";
		sNewSql = "select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>=:TargetLength "+
		" and OrderNo>=:TargetOrderNo "+
		" and OrderNo like :OrderNoA "+
		//" and OrderNo not like '"+sOldOrderNo+"%'"//排除当前组件及下级组件
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
				//位数不够，首位自动值0
				while(sNewOrder1.length()<iTargetLength)sNewOrder1="0"+sNewOrder1;
				sNewOrderNo=sNewOrder1+(sNewOrderNo.length()>iTargetLength?sNewOrderNo.substring(iTargetLength):"");
				sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo1 where OrderNo=:OrderNo2";
				so = new SqlObject(sNewSql);
				so.setParameter("OrderNo1",sNewOrderNo).setParameter("OrderNo2",sOldOrderNo1);
				Sqlca.executeSQL(so);
			}
		}
		rs.getStatement().close();
		
		//获取当前组件的OrderNo
		sOldOrderNo="";
		sNewSql = "Select OrderNo from REG_COMP_DEF  where CompID = :CompID";
		so = new SqlObject(sNewSql).setParameter("CompID",sCurCompID);
		rs=Sqlca.getASResultSet(so);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
        	//当前组件的OrderNo更新为sTargetOrderNo
        	sNewSql = "update REG_COMP_DEF set OrderNo=:OrderNo where CompID = :CompID";
    		so = new SqlObject(sNewSql);
    		so.setParameter("CompID",sCurCompID).setParameter("OrderNo",sTargetOrderNo);
        	Sqlca.executeSQL(so);
        	sNewMaxOrderNo=sTargetOrderNo;
			//更新当前组件下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之前！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("after")){
		//将TargetComp及其之后的所有组件的SortNo的前 iTargetLength 位加10
		//长度大于等于它的              
		//modifyed by sxwang 2009.02.16                                     
		String sSql = "";
		sNewSql = "select OrderNo from REG_COMP_DEF "+
		" where length(OrderNo)>=:TargetLength "+
		" and OrderNo>:TargetOrderNo1 "+
		" and OrderNo not like :TargetOrderNo2 "+ //排除目标组件以及下级组件
		" and OrderNo like :OrderNoA "+
		//"and OrderNo not like '"+sOldOrderNo+"%'";//排除当前组件及下级组件
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
				//位数不够，首位自动值0
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
	    
		//获取当前组件的OrderNo
		sOldOrderNo="";
		sNewSql = "Select OrderNo from REG_COMP_DEF  where CompID = :CompID";
		so = new SqlObject(sNewSql).setParameter("CompID",sCurCompID);
		rs=Sqlca.getASResultSet(so);
		if(rs.next())sOldOrderNo=rs.getString("OrderNo");
		rs.getStatement().close();
		if(sOldOrderNo==null)sOldOrderNo="";
		String sNewMaxOrderNo = "";
        if(!sOldOrderNo.equals("")){
			//将当前组件的OrderNo更新为sTargetOrderNo+10
    		double dNewOrderNo=DataConvert.toDouble(sTargetOrderNo.substring(0,iTargetLength));
    		sNewMaxOrderNo=new DecimalFormat("##").format(dNewOrderNo+10);
    		while(sNewMaxOrderNo.length()<iTargetLength)sNewMaxOrderNo="0"+sNewMaxOrderNo;
    		sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo where CompID = :CompID";
    		so = new SqlObject(sNewSql);
    		so.setParameter("OrderNo",sNewMaxOrderNo).setParameter("CompID",sCurCompID);
    		Sqlca.executeSQL(so);
    		//更新当前组件的下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之后！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%
	}else if(sInjectionType!=null && sInjectionType.equals("below")){
		//将TargetComp及其之后的所有组件的SortNo加10
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
		//将当前组件的OrderNo更新为sTargetOrderNo
		sNewSql = "update REG_COMP_DEF set OrderNo = :OrderNo where CompID = :CompID";
		so = new SqlObject(sNewSql);
		so.setParameter("CompID",sCurCompID).setParameter("OrderNo",sNewMaxOrderNo);
		Sqlca.executeSQL(so);
		//更新当前组件的下级组件
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
		alert("成功将组件<%=sCurCompID%>排列在<%=sTargetCompID%>之下！");
		top.returnValue="<%=sNewMaxOrderNo%>";
		<%	
	}
%>
self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>