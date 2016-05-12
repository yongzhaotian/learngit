package com.amarsoft.app.als.bizobject.customer;

import java.io.Serializable;
import java.util.List;

import com.amarsoft.app.als.bizobject.ObjectHelper;
import com.amarsoft.app.als.customer.group.action.CheckKeyMemberCustomer;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.context.ASUser;

/**
 * @author qchen
 * @since 2011-7-04
 * @describe ���ſͻ����������
 */
public class GroupCustomerManager extends CustomerManager implements Serializable{

	private static final long serialVersionUID = -1921734771951152399L;
	private String GroupID ;
	private String keyMemberCustomerID;

	public String getKeyMemberCustomerID() {
		return keyMemberCustomerID;
	}

	public void setKeyMemberCustomerID(String keyMemberCustomerID) {
		this.keyMemberCustomerID = keyMemberCustomerID;
	}

	public String getGroupID() {
		return GroupID;
	}

	public void setGroupID(String GroupID) {
		this.GroupID = GroupID;
	}

	public Customer newInstance() {
		GroupCustomer groupCustomer = new GroupCustomer();
		groupCustomer.setCustomerType(this.getCustomerType());
		groupCustomer.groupFlag = true;
		return loadGroupCustomerModelInfo(groupCustomer);
	}

	public GroupCustomer getInstance(String customerID) {
		GroupCustomer groupCustomer = new GroupCustomer();
		groupCustomer.setCustomerID(customerID);
		groupCustomer.groupFlag = true;
		return loadGroupCustomer(groupCustomer);
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ���ſͻ�����ʵ��
	 */
	public GroupCustomer getEasyInstance(String customerID) {
		GroupCustomer groupCustomer = new GroupCustomer();
		groupCustomer.setCustomerID(customerID);
		groupCustomer.setCustomerType(this.getCustomerType());
		groupCustomer.groupFlag = true;
		return loadGroupCustomerModelInfo(groupCustomer);
	}

	public void saveInstance(Customer customer) {

	}

	public String getRightType(Customer customer, ASUser user) {
		return null;
	}

	/**
	 * װ�ؼ��ſͻ�������Ϣ
	 * @param groupCustomer
	 * @return
	 */
	protected GroupCustomer loadGroupCustomerModelInfo(GroupCustomer groupCustomer){
		//װ�ؿͻ�������Ϣ
		Customer customer=loadCustomerModelInfo(groupCustomer);
		if(customer instanceof GroupCustomer){
			groupCustomer=(GroupCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		return groupCustomer;
	}
	
	/**
	 * װ�ؼ��ſͻ�������Ϣ�ľ��巽��
	 */
	public Customer loadCustomerModelInfo(Customer customer) {
		try {
			BizObject boCustomerModel=JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_MODEL").
				createQuery("CustomerType=:CustomerType")
				.setParameter("CustomerType",customer.getCustomerType())
				.getSingleResult();
			if(boCustomerModel!=null){
				ObjectHelper.fillObjectFromJBO(customer, boCustomerModel);
			}else{
			ARE.getLog().error("������CUSTOMER_MODEL.CUSTOMERTYPE=["+this.getCustomerType()+"]�Ŀͻ�����ģ��δ����,��ȷ��!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	
	/**
	 * װ�ؼ��ſͻ�ҵ����Ϣ
	 * @param groupCustomer
	 * @return groupCustomer
	 */
	public GroupCustomer loadCustomerInfo(GroupCustomer groupCustomer){
		//װ�ؿͻ��ܱ�(jbo.app.CUSTOMER_INFO)�пͻ�������Ϣ
		Customer customer=super.loadCustomerInfo(groupCustomer);
		if(customer instanceof GroupCustomer){
			groupCustomer=(GroupCustomer)customer;
		}else{
			ARE.getLog().warn("װ�ؿͻ�������Ϣ����!");
		}
		//����customerʵ��
		customer=null;
		//װ�ع�˾�ͻ���(jbo.app.ENT_INFO)�пͻ�������Ϣ
		try {
			BizObject boGroupInfo=getGroupInfoByCustomerID(groupCustomer.getCustomerID());
			if(boGroupInfo!=null){
				ObjectHelper.fillObjectFromJBO(groupCustomer, boGroupInfo);
			}else{
				ARE.getLog().error("�ͻ�δ�ҵ�,GROUP_INFO.GROUPID=[:"+groupCustomer.getCustomerID()+"],��ȷ��!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return groupCustomer;
	}
	
	/**
	 * װ�ؼ��ſͻ����󣨿ͻ�ҵ����Ϣ�Ϳͻ�������Ϣ��
	 * @param groupCustomer
	 * @return	groupCustomer
	 */
	private GroupCustomer loadGroupCustomer(GroupCustomer groupCustomer){
		groupCustomer = loadCustomerInfo(groupCustomer);
		groupCustomer = loadGroupCustomerModelInfo(groupCustomer);
		return groupCustomer;
	}
	
	/**
	 * ͨ���ͻ���Ż�ȡ���ſͻ�JBO����
	 * @param customerID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getGroupInfoByCustomerID(String customerID) throws JBOException{
		return JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO").createQuery("GroupID=:CustomerID").setParameter("CustomerID",customerID).getSingleResult();
	}
	
	public String addCustomer(Customer customer, String userID,JBOTransaction tx) throws Exception{
		GroupCustomer groupCustomer = (GroupCustomer)customer;
		String sKeyMemberCustomerID = groupCustomer.getKeyMemberCustomerID();
		String sCorpID = groupCustomer.getGroupCorpID();
		String sCheckReturn = "";
		String sReturnInfo = "";
		
		CheckKeyMemberCustomer checker = new CheckKeyMemberCustomer();
		checker.setCorpID(sCorpID);
		checker.setCustomerID(sKeyMemberCustomerID);
		
		//------��鼯��ĸ��˾�Ƿ����������ŵĳ�Ա��ҵ-------
		sCheckReturn = checker.groupMemberExist();
		if(sCheckReturn.equals("EXIST")){
			return "һ�����ŵĳ�Ա��ҵ��������Ϊ���ŵ�ĸ��˾�������¼��ţ�";
		}else if(sCheckReturn.equals("ERROR")){
			return "������ҵ�ͻ��Ƿ�Ϊ�������ſͻ��ĳ�Ա��ҵʱ����";
		}
		
		//--------������齨�����Ƿ��Ѿ�����----------------
		sCheckReturn = checker.groupExist();
		if(sCheckReturn.equals("ERROR")){
			return "������齨�ļ��ſͻ��Ƿ��Ѿ����ڳ���";
		}else if(sCheckReturn.startsWith("EXIT")){
			String sReturn[] = sCheckReturn.split("@");
			return "���ſͻ��Ѿ����ڣ�\n\n�������ƣ�"+sReturn[1]+"\n�������ͣ�"+sReturn[2]+"\n���������"+sReturn[3]+"\n����ͻ�����"+sReturn[4];
		}
		
		sReturnInfo = addGroupCustomerAction(groupCustomer,tx);
		return sReturnInfo;
	}
	
	/**
	 * �������ſͻ��������
	 * @param groupCustomer
	 * @param tx
	 * @return
	 * @throws JBOException
	 */
	protected static String addGroupCustomerAction(GroupCustomer groupCustomer, JBOTransaction tx) throws JBOException{
		initializeGroupInfo(groupCustomer, tx);
		initializeCustomerInfo(groupCustomer, tx);
		initializeFamilyVersion(groupCustomer, tx);
		initializeFamilyMember(groupCustomer, tx);
		return "SUCCESS";
	}	
	
	/**
	 * ��ʼ�����ſͻ���Ϣ�� GROUP_INFO
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeGroupInfo(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		String sCustomerName = groupCustomer.getGroupName(); //ĸ��˾�ͻ�����
		String groupAbbName = sCustomerName.length()>10 ? sCustomerName.substring(0,10) : sCustomerName;  //���ſͻ���ƣ� ��������
		
		String versionSeq = "S" + StringFunction.getToday("");  //��ʼ�����װ汾��
		
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("GroupID", groupCustomer.getGroupID());
		bo.setAttributeValue("GroupName", sCustomerName);
		bo.setAttributeValue("GroupAbbName", groupAbbName);
		bo.setAttributeValue("GroupType1", groupCustomer.getGroupType1());    //���ſͻ�����
		bo.setAttributeValue("KeyMemberCustomerID", groupCustomer.getKeyMemberCustomerID());  			//ĸ��˾�ͻ�ID
		bo.setAttributeValue("RefVersionSeq", versionSeq);     				//����ά���ļ��װ汾��
		bo.setAttributeValue("CurrentVersionSeq", versionSeq); 					//��ǰ���װ汾��
		bo.setAttributeValue("FamilyMapStatus", "0");          					//���װ汾Ϊ�ݸ�
		bo.setAttributeValue("GroupCorpID", groupCustomer.getGroupCorpID()); 	//���ſͻ���֯��������
		bo.setAttributeValue("InputUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID",groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate",groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate",groupCustomer.getUpdateDate());
		
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * ��ʼ�����ż��װ汾��
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeFamilyVersion(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		String versionSeq = "S" + StringFunction.getToday("");  //��ʼ�����װ汾��
		//--------------------��ʼ�����װ汾��----------------
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("GroupID",groupCustomer.getGroupID());
		bo.setAttributeValue("VersionSeq",versionSeq);
		bo.setAttributeValue("InfoSource","S");//��Ϣ��Դ:ϵͳ�ڲ�
		bo.setAttributeValue("EffectiveStatus","0");//��Ч��־Ϊ�ݸ�
		bo.setAttributeValue("ApproveUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID",groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate",groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate",groupCustomer.getUpdateDate());

		tx.join(bm);
		bm.saveObject(bo);
	}
	
	/**
	 * ��ʼ�����ż��׳�Ա��
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeFamilyMember(GroupCustomer groupCustomer, JBOTransaction tx) throws JBOException{
		String versionSeq = "S" + StringFunction.getToday("");  //��ʼ�����װ汾��
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("GroupID", groupCustomer.getGroupID());
		bo.setAttributeValue("VersionSeq", versionSeq);
		bo.setAttributeValue("MemberName", groupCustomer.getGroupName()); //���ſͻ�����=����ĸ��˾�ͻ�����
		bo.setAttributeValue("MemberCustomerID", groupCustomer.getKeyMemberCustomerID());			//�ͻ���ű���
		bo.setAttributeValue("ParentMemberID", "None");					//ĸ��˾����Ա�����ΪNone
		bo.setAttributeValue("MemberType", "01");						//ĸ��˾
		bo.setAttributeValue("MemberCertType", "Ent01");				//����ĸ��˾����������֯�������뽨���ͻ��Ĺ�˾�ͻ�
		bo.setAttributeValue("MemberCertID", groupCustomer.getGroupCorpID());
		bo.setAttributeValue("MemberCorpID", groupCustomer.getGroupCorpID());
		bo.setAttributeValue("ReviseFlag", "CHECKED");
		bo.setAttributeValue("InfoSource", "S");						//��Ϣ��Դ:ϵͳ�ڲ�
		bo.setAttributeValue("InputUserID", groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID", groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate", groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate", groupCustomer.getUpdateDate());
		
		tx.join(bm);
		bm.saveObject(bo);
	}
	/**
	 * �������ſͻ��ſ���Ϣ(CUSTOMER_INFO)
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	protected static void initializeCustomerInfo(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = m.newObject();
		
		bo.getAttribute("CustomerID").setValue(groupCustomer.getGroupID());
		bo.getAttribute("CustomerName").setValue(groupCustomer.getGroupName());
		bo.getAttribute("CustomerType").setValue("0210");
		bo.getAttribute("CertType").setValue("Ent01");
		bo.getAttribute("CertID").setValue(groupCustomer.getGroupCorpID());
		bo.getAttribute("InputUserID").setValue(groupCustomer.getInputUserID());
		bo.getAttribute("InputOrgID").setValue(groupCustomer.getInputDate());
		bo.getAttribute("InputDate").setValue(groupCustomer.getInputDate());
		
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�����
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public static String getGroupCustomerNameByID(String sGroupID) throws JBOException{
	   String groupCustomerName = "";
	   BizObject bo = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO").createQuery("GroupID=:GroupID").setParameter("GroupID",sGroupID).getSingleResult();
	   if(bo != null){
		   groupCustomerName = bo.getAttribute("GroupName").getString();
	   }
	   return groupCustomerName;
	}
	
	/**
	 * �������й�������
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public String updateGroupType2(JBOTransaction tx){
		   String sReturn = "";
		   try {
			   BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
			   tx.join(bm);
			   BizObjectQuery bq = bm.createQuery("update O set GroupType2 = '1' where GroupID=:GroupID").setParameter("GroupID", GroupID);
			   bq.executeUpdate();	
			   sReturn = "Success";
			} catch (JBOException e) {
				e.printStackTrace();
				sReturn = "Faile";
			}			   
		   return sReturn;
	}
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�����
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public String getGroupCustomerByID() throws JBOException{
	   String sReturn = "";
	   BizObject bo = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO").createQuery("GroupID=:GroupID").setParameter("GroupID",GroupID).getSingleResult();
	   if(bo != null){
		   sReturn = bo.getAttribute("KeyMemberCustomerID").getString()+"@"+bo.getAttribute("MgtUserID").getString();
	   }
	   return sReturn;
	}
	
	/**
	 * �жϸÿͻ��Ƿ������ڼ���
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public String isGroupCustomer() throws Exception{
	   String groupFlag = "",snowGroupID="";
	   if(GroupID==null) GroupID="";
	   BizObject bo = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",keyMemberCustomerID).getSingleResult();
	   if(bo != null){
		   snowGroupID=bo.getAttribute("BelongGroupName").getString();
		   if(snowGroupID==null) snowGroupID="";
		   //�ų���ǰ���ڼ���  
//		   if(!snowGroupID.equals(this.GroupID) && !snowGroupID.equals(""))	   groupFlag = bo.getAttribute("GROUPFLAG").getString()+"@"+ NameManager.getCustomerName(snowGroupID);
//		   if(!snowGroupID.equals(this.GroupID) && !snowGroupID.equals(""))	   groupFlag = bo.getAttribute("GROUPFLAG").getString()+"@"+ snowGroupID;
		   if(!snowGroupID.equals(this.GroupID) && !snowGroupID.equals(""))	   groupFlag = bo.getAttribute("GROUPFLAG").getString()+"@"+ bo.getAttribute("snowGroupID").getString();
	   }
	   if(groupFlag.startsWith("2")){
		   List<BizObject> list  = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER").createQuery("select GroupID,REVISEFLAG  from O where MemberCustomerID = :MemberCustomerID").setParameter("MemberCustomerID",keyMemberCustomerID).getResultList();
		   for(int i = 0;i<list.size();i++){
			   BizObject tempBo = (BizObject)list.get(i);
			   String reviseFlag = tempBo.getAttribute("REVISEFLAG").getString();
			   String groupID = tempBo.getAttribute("GroupID").getString();
			   System.out.println(" GroupID ="+groupID+"  ="+GroupID);
			   //����ǰ�����������������ų������ڸſ�ҳ�汣��ʱ���ٴ�У��ͻ��Ƿ����ڼ���
			   if(groupID.equals(this.GroupID))  continue;
			   if("NEW".equals(reviseFlag)||"CHANGED".equals(reviseFlag)){
//				   groupFlag = "1"+"@"+NameManager.getCustomerName(groupID);
				   //groupFlag = "1"+"@"+groupID;
				   groupFlag = "1"+"@"+tempBo.getAttribute("groupID").getString();
				   break;
			   }
		   }
	   } 
	   
	   if("".equals(groupFlag)){
		   groupFlag = "2"+"@"+"";
	   }
	   return groupFlag;
	}
	
	/**
	 * ��������ҵ�Ƿ�Ϊ�������ŵĳ�Ա
	 * @return
	 * @throws Exception
	 */
	public String checkMember() throws Exception
	{
		String sReturn="true",sMemberId="",snowGroupID="";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		List<BizObject> bizList=m.createQuery("MemberCustomerID=:MemberCustomerID")
								.setParameter("MemberCustomerID",this.keyMemberCustomerID).getResultList();
		for(BizObject biz:bizList)
		{
			snowGroupID=biz.getAttribute("GroupID").getString();
			if(!snowGroupID.equals(this.GroupID))
			{
				//String sName=NameManager.getCustomerName(snowGroupID); 
				//String sName=snowGroupID;
				String sName = biz.getAttribute("snowGroupID").getString();
				sReturn="��ѡ�������ҵ����["+sName+"]�ĳ�Ա��������Ϊ������ҵ��";
			}
		}
		return sReturn;
	}
	/**
	 * ��鼯���³�Ա���鿴�Ǹó�Ա�Ƿ��������������Ѿ����� @
	 * @return
	 * @throws Exception 
	 */
	public String checkAllGroupMember() throws Exception
	{
		String sReturn="",sMemberId="",snowGroupID="";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		List<BizObject> bizList=m.createQuery("groupID=:groupID")
								.setParameter("groupID",this.GroupID).getResultList(); 
		for(BizObject biz:bizList)
		{
			sMemberId=biz.getAttribute("MEMBERCUSTOMERID").getString();
			List<BizObject>  memberList=m.createQuery("MEMBERCUSTOMERID=:MemberCustomerID ").setParameter("MemberCustomerID", sMemberId).getResultList();
			for(BizObject mbiz:memberList)
			{
				snowGroupID=mbiz.getAttribute("groupID").getString();
				if(!snowGroupID.equals(this.GroupID)){
//					String sName=NameManager.getCustomerName(sMemberId);
//					String sName2=NameManager.getCustomerName(snowGroupID);
					//String sName=sMemberId;
					//String sName2=snowGroupID;
					String sName = mbiz.getAttribute("sMemberId").getString();
					String sName2 = mbiz.getAttribute("snowGroupID").getString();
					sReturn+="��Ա["+sName+"]�����ڼ���["+sName2+"]\n";
				}
			}
			
		} 
		if(sReturn.equals("")) {
			sReturn="true";
		}else{
			sReturn="���ܽ����ύ���ˣ���ע����������:\n"+sReturn;
		}
		return sReturn;
		
	}
}
