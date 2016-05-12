<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	/*
	  author:syang 2009/10/20
		Content: 工作台上WorkTips工作提示Ajax展示总调度页面
		Input Param:
			Type:加载类型（点击鼠标，展开时Type ="1"）
		Output param:
		History Log:
	 */
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sType == null) sType = "0";
	if(sItemNo == null) throw new Exception("请传入编号");
	
	String sReturn = "";
	
	//取出代码对象
	Item[] codeDef = CodeManager.getItems("PlantformTask");
			
	String sClassName = "";
	for(int i=0;i<codeDef.length;i++){
		Item vpItem = codeDef[i];
		String sCurItemNo = (String)vpItem.getItemNo();
		if(sItemNo.equals(sCurItemNo)){	//遍历，与传入的进行比较
			sClassName = (String)vpItem.getItemAttribute();
			break;
		}
	}
	//加载的类名不能为空
	if(sClassName == null || sClassName.length() == 0){
		throw new Exception("代码表[PlantformTask]，ItemNo["+sItemNo+"],没有配置ItemAttribute字段的值");
	}
	response.sendRedirect(SpecialTools.amarsoft2Real(sWebRootPath+sClassName+"?Flag="+sType+"&CompClientID="+sCompClientID));

	//调用动态类
	/**
	Bizlet biz = (Bizlet)Class.forName(sClassName).newInstance();
	biz.setAttribute("CurUser",CurUser);
	biz.setAttribute("CurOrg",CurOrg);
	biz.setAttribute("Type",sType);
	biz.setAttribute("ResourcesPath",sResourcesPath);
	Vector list = (Vector)biz.run(Sqlca);
	
	//对结果进行处理
	StringBuffer sb = new StringBuffer();
	for(int i=0;i<list.size();i++){
		if(sType.equals("1")){
			String[] row = (String[])list.get(i);
			sb.append("['").append(row[0]).append("','").append(row[1]).append("'],");
		}else{
			sReturn = (String)list.get(i);
		}
		
		if(sReturn != null && sb.length() > 0 && sType.equals("1")){
			sReturn = sb.substring(0,sb.length()-1);
		}
	}
	out.println(sReturn);
	//Thread.sleep(2000);
	sReturn = null;
	*/

%>
<%@ include file="/IncludeEndAJAX.jsp"%>