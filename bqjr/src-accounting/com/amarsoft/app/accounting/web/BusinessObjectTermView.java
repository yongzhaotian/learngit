package com.amarsoft.app.accounting.web;

import java.util.ArrayList;

import com.amarsoft.app.accounting.businessobject.BusinessObject;
import com.amarsoft.app.accounting.config.loader.ProductConfig;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.web.dw.ASColumn;
import com.amarsoft.web.dw.ASDataWindow;


/**
 * @author ygwang
 * ����ҵ�����չ��������������Ϣ�����������Ϣ���ص�datawindow��չ�֣�����datawindow�����ƣ��˹���ʵ���߼��ȽϷ���
 *
 */
public class BusinessObjectTermView{
	
	public static String appendTermListToDataWindow(ASDataWindow dwTemp,String columnName,ArrayList<ASValuePool> termList
			,ArrayList<BusinessObject> termObjectList,Transaction sqlca,Page curPage) throws Exception{
		StringBuffer sb = new StringBuffer();
		
		ASColumn column = dwTemp.DataObject.getColumn(columnName);
		//��Ŷ�ѡ�������
		dwTemp.DataObject.setUnit(column.getAttribute("Name"), "<span id=\"" + column.getAttribute("Name") + "_Span\">aa</span>");
		//���ֶε�¼������id���Ա�����
		dwTemp.DataObject.appendHTMLStyle(column.getAttribute("Name"), " id=" + column.getAttribute("Name") + "_id ");
		//��Ŷ�ѡ���ѡ��Ĵ�����������
		String checkBoxHtml="";
		for (int i = 0; i < termList.size(); i ++){
			ASValuePool term = termList.get(i);
			checkBoxHtml = "\"<input name='"+column.getAttribute("Name")+"'  onclick=parent.selectFee('"+term.getString("TermID")+"') " +
					" type=checkbox value='"+term.getString("TermID")+"'>"+term.getString("TermName") +"&nbsp;&nbsp;\"";
		}
		dwTemp.DataObject.setColumnAttribute(column.getAttribute("Name"), "EditStyle", "1");
		sb.append("document.all(\"myiframe0\").contentWindow.document.getElementById(\""+column.getAttribute("Name")+"_Span\").innerHTML = "+checkBoxHtml+";");
		sb.append("document.all(\"myiframe0\").contentWindow.document.getElementById(\""+column.getAttribute("Name")+"_id\").style.display=\"none\";");
		return sb.toString();
	}
	
	public static ArrayList<ASValuePool> getFeeTermList(BusinessObject businessObject,String termType,Transaction sqlca) throws NumberFormatException, Exception{
		ArrayList<ASValuePool> feeTermList = new ArrayList<ASValuePool>();
		if(businessObject.getObjectType().equals("jbo.app.ACCT_TRANSACTION")){
			BusinessObject loan = businessObject.getRelativeObject(businessObject.getString("RelativeObjectType"), businessObject.getString("RelativeObjectNo"));
			String productID = loan.getString("BusinessType");
			String productVersionID = loan.getString("ProductVersion");
			ArrayList<ASValuePool> termList = ProductConfig.getProductTermList(productID, productVersionID, "FEE");
			
			for(ASValuePool a:termList){
				ASValuePool parameterSet = (ASValuePool)a.getAttribute("TermParameters");
				ASValuePool parameter = (ASValuePool)parameterSet.getAttribute("FeeTransactionCode");
				String termTransactionCode = parameter.getString("ValueList");
				if(termTransactionCode==null||termTransactionCode.indexOf(businessObject.getString("TransCode"))<0) continue;
				else{
					feeTermList.add(a);
				}
			}
		}
		return feeTermList;
	}
}
