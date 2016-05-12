package com.amarsoft.app.als.customer.model;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.app.als.customer.common.action.GetCustomer;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.web.ui.HTMLTreeView;

public class CustomerRelationTreeModel {
	
private String customerID;
	
	private String rootSortNo;
	private String subSortNoMode;
	private int layerNum;
	
	
	{ // 默认值
		subSortNoMode = "0000";
	}
	
	public String getSubSortNoMode() {
		return subSortNoMode;
	}
	
	public void setSubSortNoMode(String subSortNoMode) {
		this.subSortNoMode = subSortNoMode;
	}
	
	/**
	 * 初始化客户关联树图参数
	 * @param sCustomerID 从该客户搜索起
	 * @param rootSortNo 客户排序号
	 * @param layerNum 关联深度
	 */
	public CustomerRelationTreeModel(String sCustomerID, String rootSortNo, String layerNumString) {
		this.customerID = sCustomerID;
		this.rootSortNo = rootSortNo;
		this.layerNum = Integer.parseInt(layerNumString);
	}
	
	/**
	 * 获取关联树图
	 * @param sResourcesPath:资源文件目录
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public HTMLTreeView getRelationTree(String sResourcesPath,Transaction Sqlca) throws Exception{
		//已搜索客户列表
		List<String> searchedCustomer=new ArrayList<String>();
		//取得客户名字
	    String sCustomerName=GetCustomer.getCustomerName(customerID);
		//定义Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(sCustomerName+"※关联关系图※","_top");
		tviTemp.ImageDirectory = sResourcesPath; //设置资源文件目录（图片、CSS）
		tviTemp.toRegister = false; //设置是否需要将所有的节点注册为功能点及权限点
		tviTemp.TriggerClickEvent=true; //是否自动触发选中事件
		int leaf=1;
		//将当前客户加入已搜索客户列表
		searchedCustomer.add(customerID);
		//设置客户下的关联关系节点及关联客户节点
		setRelationTree(customerID, sCustomerName, rootSortNo, tviTemp, new DecimalFormat(subSortNoMode),"",searchedCustomer,leaf,Sqlca);
		return tviTemp;
	}
	
	
	/**
	 * 设置客户下的关联关系节点及关联客户节点
	 * @param sCustomerID 关联的客户编号
	 * @param sCustomerName 关联的客户名称
	 * @param parentSortNo 关联的客户排序号
	 * @param tviTemp 数据树对象
	 * @param format 节点排序格式化对象
	 * @param parent 上层节点
	 * @param searchedCustomer 已搜索客户列表
	 * @param leaf 页节点排序号
	 * @param Sqlca 
	 * @throws Exception
	 */
	private void setRelationTree(String sCustomerID, String sCustomerName, String parentSortNo, HTMLTreeView tviTemp, DecimalFormat format,String parent,List<String> searchedCustomer, int leaf, Transaction Sqlca) throws Exception {
		String sortNoOrId;
		String sortNoOrId2;
		String sRelativeID;//关联客户编号
		String sRelativeCustomerName;//关联客户名称
		String sRelationShipName;//关联关系名称
		
		String sCurrentFloder1="";//当前目录1
		String sCurrentFloder2="";//当前目录2
		if("".equals(parent)){//上层节点为空,默认为根目录
			parent="root";
		}
		BizObject relabo = null, relaCustbo = null;
		//取客户所有关联关系
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
		List relaList = bm.createQuery("select distinct RelationShip from o where CustomerID=:CustomerID and exists(select 1 from jbo.app.CUSTOMER_INFO CI where CI.CustomerID=o.RelativeID) order by RelationShip")
						.setParameter("CustomerID",sCustomerID).getResultList(false);
		//---------------------根据关联关系,取具体关联关系记录-------------------------
		for(int i = 0; i < relaList.size(); i++){
			relabo = (BizObject)relaList.get(i);
			sRelationShipName = CodeManager.getItemName("RelationShip",relabo.getAttribute("RelationShip").getString());
			sortNoOrId = parentSortNo + format.format(i);
			sCurrentFloder1=tviTemp.insertFolder(parent+i,parent,sCustomerName+"："+sRelationShipName,sCustomerID,"",i);
			
			List subList = bm.createQuery("select RelativeID from o where CustomerID=:CustomerID and RelationShip=:RelationShip and exists(select 1 from jbo.app.CUSTOMER_INFO CI where CI.CustomerID=o.RelativeID) ")
						.setParameter("CustomerID", sCustomerID).setParameter("RelationShip",relabo.getAttribute("RelationShip").getString()).getResultList(false);
			//---------------获取关联客户节点-----------------------------
			for(int j = 0; j < subList.size() ; j++){
				relaCustbo = (BizObject)subList.get(j);
				sRelativeID = relaCustbo.getAttribute("RelativeID").getString(); 
				sRelativeCustomerName = GetCustomer.getCustomerName(sRelativeID);
				
				if(StringX.isSpace(sRelativeCustomerName) || sRelativeCustomerName.equals(sRelativeID)){
					sRelativeCustomerName = "编号" + sRelativeID + "的客户无详细信息，请在客户信息列表中添加该客户";
				}
				sortNoOrId2 = sortNoOrId + format.format(j);
				//------------------------递归调用-----------------------
				if((sortNoOrId2.length() - rootSortNo.length())  / (subSortNoMode.length() * 2) + 1 < layerNum && !searchedCustomer.contains(sRelativeID)){
					sCurrentFloder2=tviTemp.insertFolder(parent+i+j,sCurrentFloder1,sRelativeCustomerName,sRelativeID,"",leaf++);
					setRelationTree(sRelativeID, sRelativeCustomerName, sortNoOrId2, tviTemp, format,sCurrentFloder2,searchedCustomer,leaf,Sqlca);
				}else{
					tviTemp.insertPage(parent+i+j,sCurrentFloder1,sRelativeCustomerName,sRelativeID,"",leaf++);
				}
				//将当前关联客户加入已搜索客户列表
				if(!searchedCustomer.contains(sRelativeID)){
					searchedCustomer.add(sRelativeID);
				}
			}
			
		}
	}
	
}
