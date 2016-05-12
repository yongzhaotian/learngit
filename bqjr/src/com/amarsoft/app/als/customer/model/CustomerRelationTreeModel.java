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
	
	
	{ // Ĭ��ֵ
		subSortNoMode = "0000";
	}
	
	public String getSubSortNoMode() {
		return subSortNoMode;
	}
	
	public void setSubSortNoMode(String subSortNoMode) {
		this.subSortNoMode = subSortNoMode;
	}
	
	/**
	 * ��ʼ���ͻ�������ͼ����
	 * @param sCustomerID �Ӹÿͻ�������
	 * @param rootSortNo �ͻ������
	 * @param layerNum �������
	 */
	public CustomerRelationTreeModel(String sCustomerID, String rootSortNo, String layerNumString) {
		this.customerID = sCustomerID;
		this.rootSortNo = rootSortNo;
		this.layerNum = Integer.parseInt(layerNumString);
	}
	
	/**
	 * ��ȡ������ͼ
	 * @param sResourcesPath:��Դ�ļ�Ŀ¼
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public HTMLTreeView getRelationTree(String sResourcesPath,Transaction Sqlca) throws Exception{
		//�������ͻ��б�
		List<String> searchedCustomer=new ArrayList<String>();
		//ȡ�ÿͻ�����
	    String sCustomerName=GetCustomer.getCustomerName(customerID);
		//����Treeview
		HTMLTreeView tviTemp = new HTMLTreeView(sCustomerName+"��������ϵͼ��","_top");
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.toRegister = false; //�����Ƿ���Ҫ�����еĽڵ�ע��Ϊ���ܵ㼰Ȩ�޵�
		tviTemp.TriggerClickEvent=true; //�Ƿ��Զ�����ѡ���¼�
		int leaf=1;
		//����ǰ�ͻ������������ͻ��б�
		searchedCustomer.add(customerID);
		//���ÿͻ��µĹ�����ϵ�ڵ㼰�����ͻ��ڵ�
		setRelationTree(customerID, sCustomerName, rootSortNo, tviTemp, new DecimalFormat(subSortNoMode),"",searchedCustomer,leaf,Sqlca);
		return tviTemp;
	}
	
	
	/**
	 * ���ÿͻ��µĹ�����ϵ�ڵ㼰�����ͻ��ڵ�
	 * @param sCustomerID �����Ŀͻ����
	 * @param sCustomerName �����Ŀͻ�����
	 * @param parentSortNo �����Ŀͻ������
	 * @param tviTemp ����������
	 * @param format �ڵ������ʽ������
	 * @param parent �ϲ�ڵ�
	 * @param searchedCustomer �������ͻ��б�
	 * @param leaf ҳ�ڵ������
	 * @param Sqlca 
	 * @throws Exception
	 */
	private void setRelationTree(String sCustomerID, String sCustomerName, String parentSortNo, HTMLTreeView tviTemp, DecimalFormat format,String parent,List<String> searchedCustomer, int leaf, Transaction Sqlca) throws Exception {
		String sortNoOrId;
		String sortNoOrId2;
		String sRelativeID;//�����ͻ����
		String sRelativeCustomerName;//�����ͻ�����
		String sRelationShipName;//������ϵ����
		
		String sCurrentFloder1="";//��ǰĿ¼1
		String sCurrentFloder2="";//��ǰĿ¼2
		if("".equals(parent)){//�ϲ�ڵ�Ϊ��,Ĭ��Ϊ��Ŀ¼
			parent="root";
		}
		BizObject relabo = null, relaCustbo = null;
		//ȡ�ͻ����й�����ϵ
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
		List relaList = bm.createQuery("select distinct RelationShip from o where CustomerID=:CustomerID and exists(select 1 from jbo.app.CUSTOMER_INFO CI where CI.CustomerID=o.RelativeID) order by RelationShip")
						.setParameter("CustomerID",sCustomerID).getResultList(false);
		//---------------------���ݹ�����ϵ,ȡ���������ϵ��¼-------------------------
		for(int i = 0; i < relaList.size(); i++){
			relabo = (BizObject)relaList.get(i);
			sRelationShipName = CodeManager.getItemName("RelationShip",relabo.getAttribute("RelationShip").getString());
			sortNoOrId = parentSortNo + format.format(i);
			sCurrentFloder1=tviTemp.insertFolder(parent+i,parent,sCustomerName+"��"+sRelationShipName,sCustomerID,"",i);
			
			List subList = bm.createQuery("select RelativeID from o where CustomerID=:CustomerID and RelationShip=:RelationShip and exists(select 1 from jbo.app.CUSTOMER_INFO CI where CI.CustomerID=o.RelativeID) ")
						.setParameter("CustomerID", sCustomerID).setParameter("RelationShip",relabo.getAttribute("RelationShip").getString()).getResultList(false);
			//---------------��ȡ�����ͻ��ڵ�-----------------------------
			for(int j = 0; j < subList.size() ; j++){
				relaCustbo = (BizObject)subList.get(j);
				sRelativeID = relaCustbo.getAttribute("RelativeID").getString(); 
				sRelativeCustomerName = GetCustomer.getCustomerName(sRelativeID);
				
				if(StringX.isSpace(sRelativeCustomerName) || sRelativeCustomerName.equals(sRelativeID)){
					sRelativeCustomerName = "���" + sRelativeID + "�Ŀͻ�����ϸ��Ϣ�����ڿͻ���Ϣ�б�����Ӹÿͻ�";
				}
				sortNoOrId2 = sortNoOrId + format.format(j);
				//------------------------�ݹ����-----------------------
				if((sortNoOrId2.length() - rootSortNo.length())  / (subSortNoMode.length() * 2) + 1 < layerNum && !searchedCustomer.contains(sRelativeID)){
					sCurrentFloder2=tviTemp.insertFolder(parent+i+j,sCurrentFloder1,sRelativeCustomerName,sRelativeID,"",leaf++);
					setRelationTree(sRelativeID, sRelativeCustomerName, sortNoOrId2, tviTemp, format,sCurrentFloder2,searchedCustomer,leaf,Sqlca);
				}else{
					tviTemp.insertPage(parent+i+j,sCurrentFloder1,sRelativeCustomerName,sRelativeID,"",leaf++);
				}
				//����ǰ�����ͻ������������ͻ��б�
				if(!searchedCustomer.contains(sRelativeID)){
					searchedCustomer.add(sRelativeID);
				}
			}
			
		}
	}
	
}
