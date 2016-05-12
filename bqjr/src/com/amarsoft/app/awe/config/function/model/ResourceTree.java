package com.amarsoft.app.awe.config.function.model;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.HTMLTreeView;

/**
 * ���ܵ�������������
 * @author xhgao
 *
 */
public class ResourceTree {
	
	private String roleIDs ="";

	private String getRoleIDs(String userID) throws JBOException{
		BizObjectQuery bq = JBOFactory.createBizObjectQuery("jbo.awe.USER_ROLE", "Select RoleID from O where UserID=:UserID and Status='1'").setParameter("UserID", userID);
		List<BizObject> list = bq.getResultList(false);
		for(BizObject bo : list){
			roleIDs += ",'"+bo.getAttribute("RoleID").getString()+"'";
		}
		return roleIDs.length()>0?roleIDs.substring(1):"''";
	}
	
	/**
	 * ���ܵ�������4���㼶��ģ�顢���ܵ㡢Ȩ�޵�
	 * ��������ȡ������
	 * @param tviTemp
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public HTMLTreeView getResourceTree(Transaction Sqlca,String sTreeViewName) throws Exception{
		HTMLTreeView tviTemp = new HTMLTreeView(sTreeViewName);
		tviTemp.initWithSql("SortNo","MenuName","MenuID","","","from AWE_MENU_INFO where 1 = 1 ","Order By SortNo",Sqlca);
		
		int iOrder = 0;
		ASResultSet rsItem = Sqlca.getASResultSet("Select ModuleID,FunctionID,FunctionName from AWE_FUNCTION_INFO where 1 = 1 Order By SortNo");
		while (rsItem.next()) {
			String sParentID	= rsItem.getString("ModuleID");
			String sID  		= rsItem.getString("FunctionID");
			String sName  	= "���ܵ㣺"+rsItem.getString("FunctionName");
			String sValue  	= "Function";
			//System.out.println(sParentID+"||"+sID+"||"+sName);
			if(tviTemp.getItem(sParentID) != null) tviTemp.getItem(sParentID).setType("folder");
			tviTemp.insertPage(sID,sParentID,sName,sValue,"",++iOrder,""); //���ܵ���Ϊ�˵��ڵ���ӽڵ�
		}
		rsItem.getStatement().close();
		
		iOrder = 0;
		rsItem = Sqlca.getASResultSet("Select SerialNo,FunctionID,RightPointName from AWE_FUNCTION_URL where 1 = 1 Order By SerialNo");
		while (rsItem.next()) {
			String sParentID	= rsItem.getString("FunctionID");
			String sID  		= rsItem.getString("SerialNo");
			String sName  	= "Ȩ�޵㣺"+rsItem.getString("RightPointName");
			String sValue  	= "RightPoint";
			//System.out.println(sParentID+"||"+sID+"||"+sName);
			if(tviTemp.getItem(sParentID) != null) tviTemp.getItem(sParentID).setType("folder");
			tviTemp.insertPage(sID,sParentID,sName,sValue,"",++iOrder,""); //Ȩ�޵���Ϊ���ܵ�ڵ���ӽڵ�
		}
		rsItem.getStatement().close();
		
		//����ڵ�
		tviTemp.packUpItems();
		
		/*System.out.println("---------------------------------------------------------------");
		ArrayList<TreeViewItem> Items = tviTemp.Items;
		for(TreeViewItem item : Items){
			System.out.println(item.getPicture()+"||"+item.getId()+"||"+item.getName());
		}*/
		
		return tviTemp;
	}
	
	public HTMLTreeView getUserResourceTree(Transaction Sqlca,String sTreeViewName,String userID) throws Exception {
		this.roleIDs = getRoleIDs(userID);
		HTMLTreeView tviTemp = new HTMLTreeView(sTreeViewName);
		//�˵���
		tviTemp.initWithSql("distinct O.SortNo as SortNo","'[�˵��]'||O.MenuName as MenuName","O.MenuID as MenuID","","","from AWE_MENU_INFO O,AWE_ROLE_MENU RM where O.MenuID=RM.MenuID and RM.RoleID in ("+roleIDs+") and O.IsInUse='1' ","Order By O.SortNo",Sqlca);
		
		//���ܵ�
		int iOrder = 0;
		String queryStr = "SELECT distinct O.FunctionID,O.FunctionName,O.ModuleID,O.SortNo FROM AWE_FUNCTION_INFO O,AWE_ROLE_FUNCTION RF " +
				"where O.FunctionID =RF.FunctionID and RF.RoleID in ("+roleIDs+") order by O.SortNo";
		ASResultSet rsItem = Sqlca.getASResultSet(queryStr);
		while (rsItem.next()) {
			String sParentID	= rsItem.getString("ModuleID");
			String sID  		= rsItem.getString("FunctionID");
			String sName  	= "[���ܵ㣺]"+rsItem.getString("FunctionName");
			String sValue  	= "Function";
			//System.out.println(sParentID+"||"+sID+"||"+sName);
			if(tviTemp.getItem(sParentID) != null) tviTemp.getItem(sParentID).setType("folder");
			tviTemp.insertPage(sID,sParentID,sName,sValue,"",++iOrder,""); //���ܵ���Ϊ�˵��ڵ���ӽڵ�
		}
		rsItem.getStatement().close();
		
		//Ȩ�޵�
		iOrder = 0;
		queryStr = "SELECT distinct O.SerialNo,O.FunctionID,O.RightPointName FROM AWE_FUNCTION_URL O,AWE_ROLE_URL RU " +
				"WHERE O.URL=RU.URL and RU.RoleID in ("+roleIDs+") order by O.FunctionID,O.SerialNo";
		rsItem = Sqlca.getASResultSet(queryStr);
		while (rsItem.next()) {
			String sParentID	= rsItem.getString("FunctionID");
			String sID  		= rsItem.getString("SerialNo");
			String sName  	= "[Ȩ�޵㣺]"+rsItem.getString("RightPointName");
			String sValue  	= "RightPoint";
			//System.out.println(sParentID+"||"+sID+"||"+sName);
			if(tviTemp.getItem(sParentID) != null) tviTemp.getItem(sParentID).setType("folder");
			tviTemp.insertPage(sID,sParentID,sName,sValue,"",++iOrder,""); //Ȩ�޵���Ϊ���ܵ�ڵ���ӽڵ�
		}
		rsItem.getStatement().close();
		
		//����ڵ�
		tviTemp.packUpItems();
		
		return tviTemp;
	}
}
