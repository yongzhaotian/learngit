package com.amarsoft.app.als.image;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.SpecialTools;
import com.amarsoft.awe.control.model.Component;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.web.ui.ASSet;
import com.amarsoft.web.ui.ASWebInterface;
import com.amarsoft.web.ui.TreeViewItem;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;

public class HTMLTreeViewYX {

	public HTMLTreeViewYX(String sTreeViewName) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		TreeViewName = sTreeViewName;
	}

	public HTMLTreeViewYX(String sTreeViewName, String sTargetWindow) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		TreeViewName = sTreeViewName;
		TargetWindow = sTargetWindow;
	}

	public HTMLTreeViewYX(Transaction tmpSqlca, Component tmpCurComp,
			String sTmpServletURL, String sTreeViewName, String sTargetWindow) {
		TargetWindow = "";
		ImageDirectory = "";
		BackgroundDirectory = "";
		BackgroundImage = "";
		BackgroundColor = "#DCDCDC";
		LinkColor = "#000000";
		Items = new ArrayList();
		toRegister = false;
		sServletURL = null;
		Sqlca = null;
		CurComp = null;
		Sqlca = tmpSqlca;
		CurComp = tmpCurComp;
		sServletURL = sTmpServletURL;
		TreeViewName = sTreeViewName;
		TargetWindow = sTargetWindow;
	}

	public TreeViewItem getItemByValue(String sValue) {
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (tviTemp.getValue().equals(sValue))
				return tviTemp;
		}

		return null;
	}

	public int getItemCount() {
		return Items.size();
	}

	public TreeViewItem getItem(String sID) {
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (tviTemp.getId().equals(sID))
				return tviTemp;
		}

		return null;
	}

	public String insertFolder(String sParentID, String sName, String sScript,
			int iOrder) {
		return insertFolder(sParentID, sName, "", sScript, iOrder);
	}

	public String insertFolder(String sParentID, String sName, String sValue,
			String sScript, int iOrder) {
		String sID = String.valueOf(getItemCount() + 1);
		return insertFolder(sID, sParentID, sName, sValue, sScript, iOrder);
	}

	public String insertFolder(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder) {
		TreeViewItem tviFold = new TreeViewItem(sID, sParentID, "folder",
				sName, sValue, sScript, iOrder, "");
		Items.add(tviFold);
		return sID;
	}

	public String insertFolder(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder, String sPicture) {
		TreeViewItem tviFold = new TreeViewItem(sID, sParentID, "folder",
				sName, sValue, sScript, iOrder, sPicture);
		Items.add(tviFold);
		return sID;
	}

	public String insertPage(String sParentID, String sName, String sScript,
			int iOrder) {
		return insertPage(sParentID, sName, "", sScript, iOrder);
	}

	public String insertPage(String sParentID, String sName, String sValue,
			String sScript, int iOrder) {
		String sID = String.valueOf(getItemCount() + 1);
		return insertPage(sID, sParentID, sName, sValue, sScript, iOrder);
	}

	public String insertPage(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder) {
		TreeViewItem tviPage = new TreeViewItem(sID, sParentID, "page", sName,
				sValue, sScript, iOrder, "");
		Items.add(tviPage);
		return sID;
	}

	public String insertPage(String sID, String sParentID, String sName,
			String sValue, String sScript, int iOrder, String sPicture) {
		TreeViewItem tviPage = new TreeViewItem(sID, sParentID, "page", sName,
				sValue, sScript, iOrder, sPicture);
		Items.add(tviPage);
		return sID;
	}

	public void initWithCode(String sCodeNo, Transaction sqlca)
			throws Exception {
		initWithSql(
				"ItemNo",
				"ItemName",
				"",
				"ItemDescribe",
				"ItemAttribute",
				(new StringBuilder())
						.append("from CODE_LIBRARY where CodeNo='")
						.append(sCodeNo).append("' and IsInUse = '1' ")
						.toString(), " Order By SortNo,ItemNo ", sqlca);
	}

	public void initWithCode(String sCodeNo, String sWhere, Transaction sqlca)
			throws Exception {
		if (sWhere != null && !sWhere.equals(""))
			initWithSql(
					"ItemNo",
					"ItemName",
					"",
					"ItemDescribe",
					"ItemAttribute",
					(new StringBuilder())
							.append("from CODE_LIBRARY where CodeNo='")
							.append(sCodeNo).append("' and ").append(sWhere)
							.toString(), sqlca);
		else
			initWithSql(
					"ItemNo",
					"ItemName",
					"",
					"ItemDescribe",
					"ItemAttribute",
					(new StringBuilder())
							.append("from CODE_LIBRARY where CodeNo='")
							.append(sCodeNo).append("'").toString(), sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColScript,
			String sFrom, Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, sColID, sColScript, sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sFrom,
			Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, "", "", sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sFrom, Transaction sqlca)
			throws Exception {
		initWithSql(sColID, sColName, sColValue, sColScript, "", sFrom, sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sColPicture, String sFrom,
			Transaction sqlca) throws Exception {
		initWithSql(sColID, sColName, sColValue, sColScript, sColPicture,
				sFrom, (new StringBuilder()).append(" Order By ")
						.append(sColID).toString(), sqlca);
	}

	public void initWithSql(String sColID, String sColName, String sColValue,
			String sColScript, String sColPicture, String sFrom,
			String sOrderBy, Transaction Sqlca) throws Exception {
		sColID = sColID.trim().toUpperCase();
		sColName = sColName.trim().toUpperCase();
		sColValue = sColValue.trim().toUpperCase();
		sColScript = sColScript.trim().toUpperCase();
		sColPicture = sColPicture.trim().toUpperCase();
		sOrderBy = sOrderBy.trim().toUpperCase();
		String sSelect = "SELECT ";
		if (sColID.indexOf("DISTINCT") > -1) {
			sColID = sColID.replace("DISTINCT ", "");
			sSelect = (new StringBuilder()).append(sSelect).append("DISTINCT ")
					.toString();
		}
		if (sOrderBy.indexOf("DISTINCT") > -1)
			sOrderBy = sOrderBy.replace("DISTINCT ", "");
		String sGroup = "";
		String sSelectTemp = "";
		ASSet assTemp = new ASSet();
		assTemp.addElement(sColID);
		int index = sColID.lastIndexOf(" AS ") + 4;
		if (index > 3)
			sColID = sColID.substring(index).trim();
		assTemp.addElement(sColName);
		index = sColName.lastIndexOf(" AS ") + 4;
		if (index > 3)
			sColName = sColName.substring(index).trim();
		assTemp.addElement(sColValue);
		index = sColValue.lastIndexOf(" AS ") + 4;
		if (index > 3)
			sColValue = sColValue.substring(index).trim();
		assTemp.addElement(sColScript);
		index = sColScript.lastIndexOf(" AS ") + 4;
		if (index > 3)
			sColScript = sColScript.substring(index).trim();
		assTemp.addElement(sColPicture);
		index = sColPicture.lastIndexOf(" AS ") + 4;
		if (index > 3)
			sColPicture = sColPicture.substring(index).trim();
		for (int i = 0; i < assTemp.getSize(); i++) {
			String sTemp = (String) assTemp.getElement(i);
			if (!sTemp.equals(""))
				sSelectTemp = (new StringBuilder()).append(sSelectTemp)
						.append(",").append(sTemp).toString();
		}

		sSelect = (new StringBuilder()).append(sSelect)
				.append(sSelectTemp.substring(1)).toString();
		int iGroup = sFrom.indexOf(" group by ");
		if (iGroup >= 0) {
			sGroup = sFrom.substring(iGroup);
			sFrom = sFrom.substring(0, iGroup);
		}
		int iOrder = 0;
		String sParentID = "root";
		String sValue = "";
		String sScript = "";
		String sPicture = "";
		String sSql = (new StringBuilder()).append(sSelect).append(" ")
				.append(sFrom).append(" ").append(sGroup).append(" ")
				.append(sOrderBy).toString();
		ARE.getLog().trace(sSql);
		String sID;
		String sName;
		ASResultSet rsItem;
		for (rsItem = Sqlca.getASResultSet(sSql); rsItem.next(); insertPage(
				sID, sParentID, sName, sValue, sScript, iOrder, sPicture)) {
			sID = rsItem.getString(sColID);
			sName = DataConvert.toString(rsItem.getString(sColName));
			if (!sColValue.equals(""))
				sValue = rsItem.getString(sColValue);
			if (!sColScript.equals(""))
				sScript = DataConvert.toString(rsItem.getString(sColScript));
			if (!sColPicture.equals(""))
				sPicture = DataConvert.toString(rsItem.getString(sColPicture));
		}

		rsItem.getStatement().close();
		packUpItems();
	}

	public void packUpItems() {
		int iOrder = 0;
		ArrayList tempItems = new ArrayList();
		Iterator i$ = Items.iterator();
		do {
			if (!i$.hasNext())
				break;
			TreeViewItem child = (TreeViewItem) i$.next();
			String sChildID = child.getId();
			Iterator i$1 = Items.iterator();
			do {
				if (!i$1.hasNext())
					break;
				TreeViewItem parent = (TreeViewItem) i$1.next();
				String sParentID = parent.getId();
				if (!sChildID.equals(sParentID)
						&& sChildID.startsWith(sParentID)) {
					parent.setType("folder");
					child.setParentID(sParentID);
				}
			} while (true);
			if (!tempItems.contains(child)) {
				iOrder++;
				child.setOrder(iOrder);
				tempItems.add(child);
			}
		} while (true);
		Items.clear();
		Items.addAll(tempItems);
	}

	public String generateHTMLTreeView() throws Exception {
		StringBuffer sbHTMLTreeView = new StringBuffer();
		sbHTMLTreeView.append((new StringBuilder())
				.append("imageDirectory = '").append(ImageDirectory)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundDirectory = '").append(BackgroundDirectory)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundImage = '").append(BackgroundImage)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder())
				.append("backgroundColor = '").append(BackgroundColor)
				.append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder()).append("linkColor = '")
				.append(LinkColor).append("';\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder()).append("myMultiSelect = ")
				.append(MultiSelect).append(";\r\n").toString());
		sbHTMLTreeView.append((new StringBuilder()).append("addItem('root','")
				.append(TreeViewName)
				.append("','root','','root','','',0,'');\r\n").toString());
		for (int i = 0; i < Items.size(); i++) {
			TreeViewItem tviTemp = (TreeViewItem) Items.get(i);
			if (!toRegister)
				sbHTMLTreeView
						.append((new StringBuilder())
								.append("addItem('")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getId()))
								.append("','")
								.append(tviTemp	/*jqcao:*/
										.getName())
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getValue()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getParentID()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getType()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getScript()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getPicture()))
								.append("',")
								.append(tviTemp.getOrder())
								.append(",'")
								.append(SpecialTools
										.real2Amarsoft(TargetWindow))
								.append("');\r\n").toString());
			else
				sbHTMLTreeView.append(ASWebInterface.generateControl(
						Sqlca,
						CurComp,
						sServletURL,
						"",
						"TreeNode",
						tviTemp.getName(),
						"",
						(new StringBuilder())
								.append("addItem('")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getId()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getName()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getValue()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getParentID()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getType()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getScript()))
								.append("','")
								.append(SpecialTools.real2Amarsoft(tviTemp
										.getPicture()))
								.append("',")
								.append(tviTemp.getOrder())
								.append(",'")
								.append(SpecialTools
										.real2Amarsoft(TargetWindow))
								.append("');\r\n").toString(), ImageDirectory));
		}

		sbHTMLTreeView.append("drawMenu();\r\n");
		if (TriggerClickEvent)
			sbHTMLTreeView.append(" myTriggerClickEvent=true;\r\n");
		return sbHTMLTreeView.toString();
	}

	public String TreeViewName;
	public String TargetWindow;
	public String ImageDirectory;
	public String BackgroundDirectory;
	public String BackgroundImage;
	public String BackgroundColor;
	public String LinkColor;
	public ArrayList Items;
	public boolean TriggerClickEvent;
	public boolean MultiSelect;
	public boolean toRegister;
	public String sServletURL;
	public Transaction Sqlca;
	public Component CurComp;
}


/*
	DECOMPILATION REPORT

	Decompiled from: D:\Proj_JAVA\ALS7_YXPOC\WebContent\WEB-INF\lib\awe-2.6-b99-rc1_g.jar
	Total time: 107 ms
	Jad reported messages/errors:
The class file version is 49.0 (only 45.3, 46.0 and 47.0 are supported)
	Exit status: 0
	Caught exceptions:
*/