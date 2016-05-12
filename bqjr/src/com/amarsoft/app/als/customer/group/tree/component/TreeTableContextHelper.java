package com.amarsoft.app.als.customer.group.tree.component;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.util.ObjectConverts;
import com.amarsoft.awe.util.json.JSONObject;
import com.amarsoft.awe.util.json.JSONValue;

/**
 * 
 * @author syang
 * @date 2011-7-27
 * @describe TreeTable工具类
 */
public class TreeTableContextHelper {
	public static FacesContext getFacesContext(String serialContext) throws Exception{
		if(serialContext==null||serialContext.length()==0)throw new Exception("数据异常，参数contextSerial丢失");
		return (FacesContext)ObjectConverts.getObject(serialContext);
	}
	
	public static FacesContext getFacesContext(Page page) throws Exception{
		String serialContext = page.getParameter("contextSerial");
		return getFacesContext(serialContext);
	}
	/**
	 * 从request中恢复FacesContext
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static FacesContext getFacesContext(HttpServletRequest request) throws Exception{
		String serialContext = request.getParameter("contextSerial");
		return getFacesContext(serialContext);
	}
	/***
	 * 从参数里恢复一个TreeNode对象
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	public static TreeNode getTreeNode(String parameter,Class<? extends TreeNode> nodeClass) throws Exception{
		TreeNode[] treeNodes = getTreeNodes(parameter,nodeClass);
		if(treeNodes==null)return null;
		return treeNodes[0];
	}
	/**
	 * 根据参数恢复一组TreeNode对象
	 * @param parameter
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static TreeNode[] getTreeNodes(String parameter,Class<? extends TreeNode> nodeClass ) throws Exception{
		TreeNode[] treeNodes = null;
		String[] sp = parameter.split("\\|");
		treeNodes = new TreeNode[sp.length];
		for(int i=0;i<sp.length;i++){
			JSONObject node = (JSONObject)JSONValue.parse(sp[i]);//恢复为json
			TreeNode treeNode = nodeClass.newInstance();
			treeNode = (TreeNode)ObjectHelper.fillObjectFromMap(treeNode, node);//恢复为对象
			treeNodes[i] = treeNode;
		}
		return treeNodes;
	}
}
