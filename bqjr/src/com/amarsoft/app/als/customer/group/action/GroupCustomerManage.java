package com.amarsoft.app.als.customer.group.action;

import java.util.List;

import com.amarsoft.app.als.bizobject.customer.GroupCustomer;
import com.amarsoft.app.als.customer.common.action.OperCustomer;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.awe.util.DBKeyHelp;

public class GroupCustomerManage {
	private String GroupID;
	private String keyMemberCustomerID;
	private String GroupName;
	private String UserID;
	private String OrgID;
	private String memberCustomerID;
	
	public String getOrgID() {
		return OrgID;
	}
	public void setOrgID(String orgID) {
		OrgID = orgID;
	}
	public String getUserID() {
		return UserID;
	}
	public void setUserID(String userID) {
		UserID = userID;
	}
	public String getGroupName() {
		return GroupName;
	}
	public void setGroupName(String groupName) {
		GroupName = groupName;
	}
	public String getGroupID() {
		return GroupID;
	}
	public void setGroupID(String groupID) {
		GroupID = groupID;
	}
	public String getKeyMemberCustomerID() {
		return keyMemberCustomerID;
	}
	public void setKeyMemberCustomerID(String keyMemberCustomerID) {
		this.keyMemberCustomerID = keyMemberCustomerID;
	}
	public String getMemberCustomerID() {
		return memberCustomerID;
	}
	public void setMemberCustomerID(String memberCustomerID) {
		this.memberCustomerID = memberCustomerID;
	}
	/**
	 * ��֤���������Ƿ��ظ���������
	 * @return
	 * @throws Exception
	 */
	public String checkGroupName(JBOTransaction tx) throws Exception{
		BizObject bo1 = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO").createQuery("GroupName=:GroupName").setParameter("GroupName",GroupName).getSingleResult();
		if(bo1 != null){
			return	"false";
		}else
			return "true";
	}
	
	/**
	 * ��֤���������Ƿ��ظ����޸ļ������飩
	 * @return
	 * @throws Exception
	 */
	public String checkGroupName1(JBOTransaction tx) throws Exception{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		BizObjectQuery q = m.createQuery("select GroupName from o where o.GroupName=:GroupName and o.GroupID <>:GroupID" );
		q.setParameter("GroupName",GroupName);
		q.setParameter("GroupID",GroupID);
		if(q.getTotalCount()>0){
			return "false";
		}else 
			return "true";

	}
	
	/**
	 * �鿴�����Ƿ�����;����
	 * @return
	 */
	public String checkOnLineApply() throws Exception
	{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
		BizObjectQuery q = m.createQuery("select SerialNo from o where   o.CustomerID =:CustomerID" +
				" and   o.BusinessType = '3020'"+
				" and exists (select 1 from jbo.app.FLOW_OBJECT FO where FO.ObjectNo=o.SerialNo" +
				" and FO.ApplyType =o.ApplyType and  FO.PhaseType  in ('1010','1020'))");// δ����ͨ��������
		q.setParameter("CustomerID",GroupID);
		if(q.getTotalCount()>0) return "ReadOnly";
		return "All"; 
	}
	
	/**
	 * У�鼯�ſͻ��Ƿ��������Ч�汾
	 * @return
	 */
	public String checkGroupApproveOpinion() throws Exception
	{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String sReturn = "";
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_OPINION");
			bo = bm.createQuery(" GroupID=:GroupID AND ApproveType='2' ").setParameter("GroupID",GroupID).getSingleResult();
			if(bo!=null){
				sReturn="ISEXIST";
			}else{
				sReturn="NOTEXIST";
			}
		} catch (JBOException e) {
			sReturn = "ERROR";
			e.printStackTrace();
		}
		return sReturn;
		
	}
	
	
	/**
	 * �ж��Ƿ�����ɾ�������������
	 * @throws Exception 
	 * */
	public String checkBeforeDeleteGroup() throws Exception{
		String sReturn = "";
		if("ReadOnly".equals(checkOnLineApply())||"ISEXIST".equals(getApproveInfo())
				||"ISEXIST".equals(getContractInfo())){
			sReturn = "�ü��ſͻ��������Ŷ��ҵ����Ϣ������ɾ����";
		}else{
			sReturn = "IsNotExist";
		}
		return sReturn;
	}
	
	//��ȡ������Ϣ
	public String getApproveInfo(){
		 BizObjectManager bm = null;
		 BizObjectQuery bq = null;
		 BizObject bo = null;
		String sReturn = "";
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",GroupID).getSingleResult();
			if(bo!=null){
				sReturn="ISEXIST";
			}else{
				sReturn="NOTEXIST";
			}
		} catch (JBOException e) {
			sReturn = "IsNotExist";
			e.printStackTrace();
		}
		return sReturn;
	}
	
	//��ȡ��ͬ��Ϣ
	public String getContractInfo(){
		BizObjectManager bm = null;
		 BizObjectQuery bq = null;
		 BizObject bo = null;
		String sReturn = "";
		bo = null;
		try {
			bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",GroupID).getSingleResult();
			if(bo!=null){
				sReturn="ISEXIST";
			}else{
				sReturn="NOTEXIST";
			}
		} catch (JBOException e) {
			sReturn = "IsNotExist";
			e.printStackTrace();
		}
		return sReturn;
	}
	
	/**
	 * ��������ҵ�Ƿ�Ϊ�������ŵĳ�Ա
	 * @return
	 * @throws Exception
	 */
	public String checkMember(JBOTransaction tx) throws Exception{
		String sReturn = "true";
		String snowGroupID = "";
		String sGroupCustomerName = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery bq = bm.createQuery("MemberCustomerID=:MemberCustomerID");
		bq.setParameter("MemberCustomerID",keyMemberCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			snowGroupID = bo.getAttribute("GroupID").getString();
			if(!snowGroupID.equals(GroupID)){
				 //������ҵ��Ӧ�ļ��ſͻ�
				bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
				bo = bm.createQuery("GroupID=:GroupID").setParameter("GroupID",snowGroupID).getSingleResult(false);
				sGroupCustomerName = bo.getAttribute("GROUPNAME").getString();
				sReturn="��ѡ�������ҵ����["+sGroupCustomerName+"]�ĳ�Ա����������Ϊ�������ŵĺ�����ҵ";
			}
		}
		return sReturn;
		
	}
	
	/**
	 * ��鼯�ſͻ��Ƿ���ͨ������,ͨ�������򲻿��Ը��ĺ�����ҵ
	 * @return
	 * @throws Exception
	 */
	public String checkKeyMemberCustomer(JBOTransaction tx) throws Exception{
		String sReturn = "NOTPAST";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		BizObjectQuery bq = bm.createQuery("GroupID=:GroupID");
		bq.setParameter("GroupID",GroupID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			sReturn = "ISPAST";
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
	
		String sReturn = "true";
		String existGroupID = "";
		String sGroupCustomerName = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery bq = bm.createQuery("MemberCustomerID=:MemberCustomerID and REVISEFLAG <> 'REMOVED'");
		bq.setParameter("MemberCustomerID",memberCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			existGroupID = bo.getAttribute("GroupID").getString();
			if(!existGroupID.equals(GroupID)){
				String sGroupMemberName = bo.getAttribute("MemberName").getString();//��Ա����
				 //��Ա��Ӧ�ļ��ſͻ�
				bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
				BizObject boGroupInfo = bm.createQuery("GroupID=:GroupID").setParameter("GroupID",existGroupID).getSingleResult(false);
				sGroupCustomerName = boGroupInfo.getAttribute("GROUPNAME").getString();
				sReturn="["+sGroupMemberName+"]"+"�����ڼ���["+sGroupCustomerName+"]����������Ϊ�������ŵĳ�Ա";
			}else{
				String sGroupMemberName = bo.getAttribute("MemberName").getString();//��Ա����
				sReturn="["+sGroupMemberName+"]"+"�����ڵ�ǰ���ţ������ظ����";
			}
		}
		return sReturn;
	}
	
	/**
	 * �����ͻ�֮ǰɾ�����صļ��ų�Ա
	 * @param groupCustomer
	 * @param 
	 * @throws Exception 
	 */
	public String forDeleteGroupmember()throws Exception{
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery(" delete from  o  where MemberCustomerID=:MemberCustomerID and GroupID=:GroupID and REVISEFLAG = 'REMOVED' ");
		q.setParameter("MemberCustomerID",memberCustomerID);
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		return "succes";
		
	}
	
	
	/**
	 * ��鼯���³�Ա���鿴�ó�Ա�Ƿ��������������Ѿ����� @
	 * @return
	 * @throws Exception 
	 */
	public String checkAllGroupMember() throws Exception{
		String sReturn="",sMemberID="",snowGroupID="";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		List<BizObject> bizList = m.createQuery("GroupID=:GroupID").setParameter("GroupID",GroupID).getResultList(false); 
		for(BizObject biz:bizList)
		{
			sMemberID=biz.getAttribute("MemberCustomerID").getString();
			List<BizObject> memberList = m.createQuery("MEMBERCUSTOMERID=:MemberCustomerID ").setParameter("MemberCustomerID", sMemberID).getResultList(false);
			for(BizObject mbiz:memberList)
			{
				snowGroupID=mbiz.getAttribute("GroupID").getString();
				if(!snowGroupID.equals(this.GroupID)){
					String sGroupMemberName = mbiz.getAttribute("MemberName").getString();
					BizObjectManager mTemp = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
					BizObject boGroupInfo = mTemp.createQuery("GroupID=:GroupID").setParameter("GroupID",snowGroupID).getSingleResult(false);
					String sGroupCustomerName = boGroupInfo.getAttribute("GROUPNAME").getString();
					
					sReturn+="��Ա["+sGroupMemberName+"]�����ڼ���["+sGroupCustomerName+"]\n";
				}
			}
			
		} 
		if(sReturn.equals("")) {
			sReturn="true";
		}else{
			sReturn="���ܽ����ύ���ˣ���ע���������⣺\n"+sReturn;
		}
		return sReturn;
		
	}
	
	
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�����
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public String getGroupCustomerByID(JBOTransaction tx) throws Exception{
	   String sReturn = "";
	   BizObject bo = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO").createQuery("GroupID=:GroupID").setParameter("GroupID",GroupID).getSingleResult();
	   if(bo != null){
		   sReturn = bo.getAttribute("KeyMemberCustomerID").getString()+"@"+bo.getAttribute("MgtUserID").getString();
	   }
	   return sReturn;
	}
	
	/**
	 * @InputParam
	 * 			<p>CustomerID: �ͻ����
	 * @return ��;���Ŷ��ҵ����Ϣ
	 * @throws Exception
	 */
	public String getBusinessMessage(JBOTransaction tx) throws Exception {
		String sReturn = "NO";
		// ������������������������������������ҵ��������
		String Result = "",Result1 = "",Result2 = "",Result3 = "";
		
		// ��;�ļ������Ŷ������
		BizObject bo1 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("CustomerID=:CustomerID and (PigeonholeDate is null)").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo1 != null){
		Result1 =	bo1.getAttribute("SERIALNO").getString();// δͨ��������δ�鵵��������
		}else{
			Result1 = "";	
		}
		
		// ����Ч���ڵ���������
		BizObject bo2 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE").createQuery("CustomerID=:CustomerID and (PigeonholeDate is null)").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo2 != null){
		Result2 =	bo2.getAttribute("SERIALNO").getString();// ��ǩ��ͬ��δ�鵵��������
		}else{
			Result2 = "";	
		}

		// ����Ч���ڵ����Ŷ��
		BizObject bo3 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo3 != null){
		Result3 =	bo3.getAttribute("SERIALNO").getString();	// δ�鵵�ĺ�ͬ��
		}else{
			Result3 = "";	
		}
		
		Result = Result1 + Result2 + Result3;
		if(!Result.equals("")){
			sReturn = "�ü��ſͻ�";
			if(!Result1.equals("")){
				sReturn += "����;�ļ������Ŷ�����룬";
			}
			if(!Result2.equals("")){
				sReturn += "������Ч���ڵ����Ŷ��������";
			}
			if(!Result3.equals("")){
				sReturn += "������Ч���ڵ����Ŷ�ȣ�";
			}
			sReturn += "����ִ�д˲�����";
		}else{
			sReturn = "NO";
		}

		return sReturn;
	}
	
	/**
	 * �������й�������
	 * @param groupCustomer
	 * @param tx
	 * @throws Exception 
	 * @throws JBOException 
	 */
	public String updateGroupType2(JBOTransaction tx) throws Exception{
		   String sReturn = "";
		   try {
			   BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
			   tx.join(bm);
			   BizObjectQuery bq = bm.createQuery("update O set GroupType2 = '1' where GroupID=:GroupID").setParameter("GroupID", GroupID);
			   bq.executeUpdate();	
			   
				BizObjectManager m = null;
				BizObjectQuery q = null;
				BizObject bo = null;
			
				m = JBOFactory.getFactory().getManager("jbo.app.GROUP_EVENT");
				String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID");
				tx.join(m);
				bo = m.newObject();
				bo.setAttributeValue("EventID", sEventID);
				bo.setAttributeValue("GroupID", GroupID);
				bo.setAttributeValue("EventType", "05");
				bo.setAttributeValue("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
				bo.setAttributeValue("RefMemberID", "");
				bo.setAttributeValue("EventValue", "");
				bo.setAttributeValue("InputOrgID",OrgID );
				bo.setAttributeValue("InputUserID",UserID);
				bo.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
				bo.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
				bo.setAttributeValue("OldEventValue", "");
				bo.setAttributeValue("RefMemberName", "");
				bo.setAttributeValue("ChangeContext", "�� �����й������� ���Ϊ �����й�������");
				m.saveObject(bo);
				sReturn = "Success";
			} catch (JBOException e) {
				e.printStackTrace();
				sReturn = "Faile";
			}			   
		   return sReturn;
	}
	
	/**
	 * @param ����˵��<br/>
	 * 		CustomerID	:�ͻ�ID<br/>
	 * 		UserID		:�û�ID
	 * @return ����ֵ˵��
	 * 		<p>����Ȩ@��Ϣ�鿴Ȩ@��Ϣά��Ȩ@ҵ�����Ȩ</p>
	 * 		<li>����Ȩֵ�򡡡���Y/N</li>
	 * 		<li>��Ϣ�鿴Ȩֵ��Y1/N1</li>
	 * 		<li>��Ϣά��Ȩֵ��Y2/N2</li>
	 * 		<li>����ҵ�����Ȩֵ��Y3/N3</li>
	 * 		<li>�ͷ���ҵ�����Ȩֵ��Y3/N3</li>
	 */
	/*
	public String checkRolesAction() throws Exception {
		String sReturnValue = "";		//����Ȩ��־   
	    String sReturnValue1 = "";		//��Ϣ�鿴Ȩ��־
	    String sReturnValue2 = "";		//��Ϣά��Ȩ��־
	    String sReturnValue3 = "";		//����ҵ�����Ȩ��־
	    String sReturnValue4 = "";		//�ͷ���ҵ�����Ȩ��־
	    
	    String sBelongAttribute = "";	//�ͻ�����Ȩ    
	    String sBelongAttribute1 = "";	//��Ϣ�鿴Ȩ
	    String sBelongAttribute2 = "";	//��Ϣά��Ȩ
	    String sBelongAttribute3 = "";	//����ҵ�����Ȩ    
	    String sBelongAttribute4 = "";	//�ͷ���ҵ�����Ȩ    
		   
	    BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
	    BizObjectQuery q = m.createQuery("CustomerID=:CustomerID and UserID=:UserID");
	    q.setParameter("CustomerID",customerID).setParameter("UserID",userID);
	    BizObject bo = q.getSingleResult();
	    if(bo != null){
	    	sBelongAttribute = bo.getAttribute("BelongAttribute").getString();
	    	sBelongAttribute1 = bo.getAttribute("BelongAttribute1").getString();
	    	sBelongAttribute2 = bo.getAttribute("BelongAttribute2").getString();
	    	sBelongAttribute3 = bo.getAttribute("BelongAttribute3").getString();
	    	sBelongAttribute4 = bo.getAttribute("BelongAttribute4").getString();
	    }
	    if(sBelongAttribute == null) sBelongAttribute = "";
		if(sBelongAttribute1 == null) sBelongAttribute1 = "";
		if(sBelongAttribute2 == null) sBelongAttribute2 = "";
		if(sBelongAttribute3 == null) sBelongAttribute3 = "";
		if(sBelongAttribute4 == null) sBelongAttribute4 = "";
	    
		//����пͻ�����Ȩ����Y�����򷵻�N	
	    if(sBelongAttribute.equals("1")){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	        
	    //�������Ϣ�鿴Ȩ����Y1�����򷵻�N1	
	    if(sBelongAttribute1.equals("1")){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //�������Ϣά��Ȩ����Y2�����򷵻�N2	
	    if(sBelongAttribute2.equals("1")){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //����г���ҵ�����Ȩ����Y3�����򷵻�N3	
	    if(sBelongAttribute3.equals("1")){
	        sReturnValue3 = "Y3";
	    }else{ 
	    	sReturnValue3 = "N3";
	    }
	    //����еͷ���ҵ�����Ȩ����Y4�����򷵻�N4	
	    if(sBelongAttribute4.equals("1")){
	        sReturnValue4 = "Y4";
	    }else{ 
	    	sReturnValue4 = "N4";
	    }
		return sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3+"@"+sReturnValue4;
	}
	*/
	/**
	 * ɾ�����ſͻ�ʱɾ�������Ϣ
	 * @InputParam
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public String deleteGroupCustomer(JBOTransaction tx) throws Exception  {  
		//-----------------------------����ENT_INFO��CUSTOMER_INFO,ɾ�����ſͻ���ع�����-----------------
	    JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String sSql;
		
		//����ENT_INFO
		m = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		q = m.createQuery("GroupID=:GroupID").setParameter("GroupID",GroupID);
		List<BizObject> memberList = q.getResultList();
		for(int i = 0;i<memberList.size();i++){
			BizObject tempBo = memberList.get(i);
			GroupCustomer group = new GroupCustomer();
			group.setKeyMemberCustomerID(tempBo.getAttribute("MEMBERCUSTOMERID").getString());
			OperCustomer.updateEntCustomer("0", group, tx);
		}
		
		//����CUSTOMER_INFO
		m = f.getManager("jbo.app.CUSTOMER_INFO");
		tx.join(m);
		q = m.createQuery("update O set BelongGroupID=:BelongGroupID where BelongGroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.setParameter("BelongGroupID","");
		q.executeUpdate();
		
		// ɾ����Ӧ�ļ��ż��׳�Ա��ϢGROUP_FAMILY_MEMBER
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		/*
		//ɾ����Ӧ�ļ��ſͻ����ձ���GROUP_RISKREPORT
		m = f.getManager("jbo.app.GROUP_RISKREPORT");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
	    */
		
		// ɾ����Ӧ�ļ��ſͻ����׸������GROUP_FAMILY_OPINION
		m = f.getManager("jbo.app.GROUP_FAMILY_OPINION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		// ɾ����Ӧ�ļ��ſͻ����װ汾��ϢGROUP_FAMILY_VERSION
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		// ɾ����Ӧ�ļ��ſͻ���ǰ������ϢGROUP_MEMBER_RELATIVE add by bcpu 
		m = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		/*
		// ɾ����Ӧ�ļ��ſͻ��¼���ϢGROUP_EVENT
		m = f.getManager("jbo.app.GROUP_EVENT");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		*/
		//ɾ��ʱ�ڶ�Ӧ�ļ��ſͻ��¼���Ϣ��GROUP_EVENT��Ӽ�¼
		insertGroupEvent(tx,GroupName);

		// ɾ�����ſͻ�GROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		bo = q.getSingleResult();
		if(bo != null){
			m.deleteObject(bo);
		}
		
		// ɾ���ͻ�������CUSTOMER_BELONG
		m = f.getManager("jbo.app.CUSTOMER_BELONG");
		tx.join(m);
		q = m.createQuery("delete from O where CustomerID=:CustomerID");
		q.setParameter("CustomerID",GroupID);
		q.executeUpdate();
		
		//ɾ���ͻ��ܱ�
		m = f.getManager("jbo.app.CUSTOMER_INFO");
		tx.join(m);
		q = m.createQuery("CustomerID=:CustomerID");
		q.setParameter("CustomerID",GroupID);
		bo = q.getSingleResult();
		if(bo != null){
			m.deleteObject(bo);
		}
		
		return "true";
	}
	
	
	/**
	 * ����������GROUP_EVENT
	 * @param 
	 * @throws Exception 
	 */
	public void insertGroupEvent(JBOTransaction tx,String GroupName) throws Exception{
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String sEventID=DBKeyHelp.getSerialNo("GROUP_EVENT","EventID");
		
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_EVENT");
		tx.join(m);
		bo = m.newObject();
		bo.setAttributeValue("EventID", sEventID);
		bo.setAttributeValue("GroupID", GroupID);
		bo.setAttributeValue("EventType", "02");
		bo.setAttributeValue("OccurDate",  DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		bo.setAttributeValue("RefMemberID", "");
		bo.setAttributeValue("EventValue", "");
		bo.setAttributeValue("InputOrgID",OrgID );
		bo.setAttributeValue("InputUserID",UserID);
		bo.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		bo.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		bo.setAttributeValue("OldEventValue", "");
		bo.setAttributeValue("RefMemberName", "");
		bo.setAttributeValue("ChangeContext", "ɾ��"+GroupName+"����");
		m.saveObject(bo);
	}
	
	/**
	 * ��֤������ҵ�Ƿ�Ķ�
	 * @return
	 * @throws Exception
	 */
	public String checkKeyMemberCustomerID(JBOTransaction tx) throws Exception{
		String sKeyMemberCustomerID="";
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		BizObjectQuery q = m.createQuery("GroupID=:GroupID" );
		q.setParameter("GroupID",GroupID);
		BizObject bo = q.getSingleResult();
		if(bo != null){
			sKeyMemberCustomerID=bo.getAttribute("KeyMemberCustomerID").getString();
			return sKeyMemberCustomerID;
		}else 
			return sKeyMemberCustomerID;
	}

	/**
	 * �жϸÿͻ��Ƿ������ڼ���
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException 
	 */
	public String isGroupCustomer1() throws Exception{
	
		String sReturn = "false";
		String existGroupID = "";
		JBOFactory factory = JBOFactory.getFactory();
		BizObjectManager bm = factory.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObjectQuery bq = bm.createQuery("MemberCustomerID=:MemberCustomerID");
		bq.setParameter("MemberCustomerID",memberCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo != null){
			existGroupID = bo.getAttribute("GroupID").getString();
			if(existGroupID.equals(GroupID)){
				return "true";
			}
		}
		return sReturn;
	}
}