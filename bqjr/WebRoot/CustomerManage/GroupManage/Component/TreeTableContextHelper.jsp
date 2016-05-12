<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMDAJAX.jsp"%>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.amarsoft.awe.util.ObjectConverts" %>
<%@ page import="com.amarsoft.awe.util.json.JSONObject" %>
<%@ page import="com.amarsoft.awe.util.json.JSONValue" %>
<%@ page import="com.amarsoft.app.als.bizobject.ObjectHelper" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.FacesContext" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.TreeNode" %>
<%@ page import="com.amarsoft.app.als.customer.group.tree.component.TreeTableContextHelper" %>
<%
JSONObject jsonObject = new JSONObject();
Class treeNodeClass=null;
try{
	FacesContext facesContext = TreeTableContextHelper.getFacesContext(CurPage);
	String action = CurPage.getParameter("action");
	String parameter = CurPage.getParameter("parameter");
	if(parameter == null) parameter = "";
	else parameter = URLDecoder.decode(parameter, "UTF-8");
	String treeNodeClassName = CurPage.getParameter("treeNodeClassName");
	if(action==null||action.length()==0)throw new Exception("�����쳣������action��ʧ");
	if(treeNodeClassName==null||treeNodeClassName.length()==0)throw new Exception("�����쳣������treeNodeClassName��ʧ");
	
	treeNodeClass = Class.forName(treeNodeClassName);
	
	//�����б�
	jsonObject.put("status","false");//����ͨ��������Ҫ�ĳ�false
	if("setValue".equals(action)){
		TreeNode[] treeNodes = TreeTableContextHelper.getTreeNodes(parameter,treeNodeClass);
		for(int i=0;i<treeNodes.length;i++){
			facesContext.updateComponent(treeNodes[i]);
		}
		jsonObject.put("status","true");
	}else if("addNode".equals(action)){
		TreeNode treeNode = TreeTableContextHelper.getTreeNode(parameter,treeNodeClass);
		TreeNode parent = (TreeNode)facesContext.findComponent(treeNode.getParentId());//�Ҹ��ڵ����
		if(parent==null){
			  jsonObject.put("message","�����쳣���Ҳ���ID="+treeNode.getParentId()+"���ڵ�");
		}else{
			  jsonObject.put("status","true");
			  facesContext.appendChildComponent(parent, treeNode);
		}
	}else if("removeNode".equals(action)){
        TreeNode treeNode = TreeTableContextHelper.getTreeNode(parameter,treeNodeClass);
        facesContext.removeComponent(treeNode.getId());
        jsonObject.put("status","true");
    }
	jsonObject.put("contextSerial", ObjectConverts.getString(facesContext));
	out.println(jsonObject.toJSONString());
}catch(Exception e){
	e.printStackTrace();
	jsonObject.put("message",e.getMessage());
	jsonObject.put("status","false");
	out.println(jsonObject.toJSONString());
}
%><%@ include file="/IncludeEndAJAX.jsp"%>