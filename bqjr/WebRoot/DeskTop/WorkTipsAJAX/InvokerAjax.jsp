<%@page import="com.amarsoft.dict.als.object.Item"%>
<%@page import="com.amarsoft.dict.als.manage.CodeManager"%>
<%@page contentType="text/html; charset=GBK"%>
<%@page import="com.amarsoft.biz.bizlet.Bizlet"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%
	/*
	  author:syang 2009/10/20
		Content: ����̨��WorkTips������ʾAjaxչʾ�ܵ���ҳ��
		Input Param:
			Type:�������ͣ������꣬չ��ʱType ="1"��
		Output param:
		History Log:
	 */
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	String sItemNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo"));
	if(sType == null) sType = "0";
	if(sItemNo == null) throw new Exception("�봫����");
	
	String sReturn = "";
	
	//ȡ���������
	Item[] codeDef = CodeManager.getItems("PlantformTask");
			
	String sClassName = "";
	for(int i=0;i<codeDef.length;i++){
		Item vpItem = codeDef[i];
		String sCurItemNo = (String)vpItem.getItemNo();
		if(sItemNo.equals(sCurItemNo)){	//�������봫��Ľ��бȽ�
			sClassName = (String)vpItem.getItemAttribute();
			break;
		}
	}
	//���ص���������Ϊ��
	if(sClassName == null || sClassName.length() == 0){
		throw new Exception("�����[PlantformTask]��ItemNo["+sItemNo+"],û������ItemAttribute�ֶε�ֵ");
	}
	response.sendRedirect(SpecialTools.amarsoft2Real(sWebRootPath+sClassName+"?Flag="+sType+"&CompClientID="+sCompClientID));

	//���ö�̬��
	/**
	Bizlet biz = (Bizlet)Class.forName(sClassName).newInstance();
	biz.setAttribute("CurUser",CurUser);
	biz.setAttribute("CurOrg",CurOrg);
	biz.setAttribute("Type",sType);
	biz.setAttribute("ResourcesPath",sResourcesPath);
	Vector list = (Vector)biz.run(Sqlca);
	
	//�Խ�����д���
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