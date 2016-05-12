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
	if(action==null||action.length()==0)throw new Exception("数据异常，参数action丢失");
	if(treeNodeClassName==null||treeNodeClassName.length()==0)throw new Exception("数据异常，参数treeNodeClassName丢失");
	
	treeNodeClass = Class.forName(treeNodeClassName);
	
	//动作列表
	jsonObject.put("status","false");//调试通过后，这里要改成false
	if("setValue".equals(action)){
		TreeNode[] treeNodes = TreeTableContextHelper.getTreeNodes(parameter,treeNodeClass);
		for(int i=0;i<treeNodes.length;i++){
			facesContext.updateComponent(treeNodes[i]);
		}
		jsonObject.put("status","true");
	}else if("addNode".equals(action)){
		TreeNode treeNode = TreeTableContextHelper.getTreeNode(parameter,treeNodeClass);
		TreeNode parent = (TreeNode)facesContext.findComponent(treeNode.getParentId());//找父节点对象
		if(parent==null){
			  jsonObject.put("message","数据异常，找不到ID="+treeNode.getParentId()+"父节点");
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