package com.amarsoft.app.als.customer.group.action;

import java.util.List;

import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;
import com.amarsoft.are.util.StringFunction;

/**
 * ������Ϣά�����ࣺ�ṩ���·���
 *    1.checkVersionUnique:У�鼯�ſͻ��Ƿ��������ά���ļ��װ汾
 *    2.copyLatestVersion:���������ⲿ��Ϣ
 *    3.recreateFamily:�ؽ�����
 *    4.submitVersion:�ύ����
 *    5.getNewRefVersionSeq����ȡ���µ�����ά���ļ��װ汾���
 *
 * @author hwang
 * @since 2010/09/26
 *
 */
public class FamilyMaintain {

	private String groupID;		// ���ſͻ����
	private String userID;		// ��ǰ�û����
	private String refVersionSeq;		// ���ſͻ�����ά���ļ��װ汾���
	private String currentVersionSeq;		// ���ſͻ�����ʹ�õļ��װ汾���
	private String oldMemberCustomerID;//���ż������϶��汾�к�����ҵ�ͻ����

	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public String getRefVersionSeq() {
		return refVersionSeq;
	}

	public void setRefVersionSeq(String refVersionSeq) {
		this.refVersionSeq = refVersionSeq;
	}

	public String getCurrentVersionSeq() {
		return currentVersionSeq;
	}

	public void setCurrentVersionSeq(String currentVersionSeq) {
		this.currentVersionSeq = currentVersionSeq;
	}

	public String getOldMemberCustomerID() {
		return oldMemberCustomerID;
	}

	public void setOldMemberCustomerID(String oldMemberCustomerID) {
		this.oldMemberCustomerID = oldMemberCustomerID;
	}
	
	/**
	 * У�鼯�ſͻ��Ƿ��������ά���ļ��װ汾
	 * @return
	 * @throws Exception
	 */
	public String checkVersionUnique() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		//���ſͻ�����ʹ�õļ��װ汾
		String sCurrentVersionSeq="";
		//���ſͻ�����ά���ļ��װ汾
		String sRefVersionSeq="";
		//���ſͻ����װ汾״̬
		String sFamilyMapStatus="";
		
		m = f.getManager("jbo.app.GROUP_INFO");
		q = m.createQuery("GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		bo = q.getSingleResult();
		if(bo != null){
			sCurrentVersionSeq=bo.getAttribute("CurrentVersionSeq").getString();
			sRefVersionSeq=bo.getAttribute("RefVersionSeq").getString();
			sFamilyMapStatus=bo.getAttribute("FamilyMapStatus").getString();
		}
		if(sCurrentVersionSeq==null) sCurrentVersionSeq="";
		if(sRefVersionSeq==null) sRefVersionSeq="";
		if(sFamilyMapStatus==null) sFamilyMapStatus="";
		//���ſͻ�����ʹ�ü��װ汾���������ά�����װ汾���һ�µ������2�֣�
		//1.���ſͻ��ո��齨
		//2.���׸ո�ά�����
		//1.���ſͻ��齨ʱ:����ʹ�õļ��װ汾������ά���ļ��װ汾���һ��,���Ҽ��װ汾״̬Ϊ�ݸ�
		if(sCurrentVersionSeq.equals(sRefVersionSeq) && "0".equals(sFamilyMapStatus)){
			return "new";//�ü��ſͻ��ո��齨,������δ����,����Ҫ�ؽ�����!
		}
		//2.���׸ո�ά�����:����ʹ�õļ��װ汾������ά���ļ��װ汾һ��ʱ�����Ҽ��װ汾״̬Ϊ����ͨ��
		if(sCurrentVersionSeq.equals(sRefVersionSeq) && "3".equals(sFamilyMapStatus)){
			return "false";
		}
		
		return "true";
	}
	
	/**
	 * ɾ����ǰ����ά���ġ��ݸ塰״̬�¼��װ汾��Ϣ��������GROUP_INFO��
	 * @return
	 * @throws Exception
	 */
	public String deleteRefVersion(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		// ɾ����Ӧ�ļ��ſͻ����װ汾��ϢGROUP_FAMILY_VERSION
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",refVersionSeq);
		q.executeUpdate();
		
		//ɾ����Ӧ�ļ��ſͻ����׳�Ա��ϢGROUP_FAMILY_MEMBER
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",refVersionSeq);
		q.executeUpdate();
		
		//���¼��ſͻ���ϢGROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set FamilyMapStatus=:FamilyMapStatus,RefVersionSeq=:RefVersionSeq,KeyMemberCustomerID=:KeyMemberCustomerID where GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq",currentVersionSeq);//����ǰ����ά���ļ��װ汾�ֶλָ����������϶��İ汾���
		q.setParameter("KeyMemberCustomerID",oldMemberCustomerID);
		q.setParameter("FamilyMapStatus","2");
		q.executeUpdate();
		
		return "true";
	}
	
	/**
	 * ��ȡ�µ�����ά���ļ��װ汾���
	 * @return �����µ�����ά���ļ��װ汾���
	 * @throws Exception
	 */
	public String getNewRefVersionSeq(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		//���ſͻ�����ά���ļ��װ汾
		String sRefVersionSeq="S"+DateX.format(new java.util.Date(), "yyyy/MM/dd").replace("/", "")+StringFunction.getNow().replace(":","");
		initializeFamilyVersion(sRefVersionSeq,tx);
		//��ʼ�����׳�Ա�������Ѹ��˵ļ���
		initializeFamilyMember(sRefVersionSeq,tx);
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set RefVersionSeq=:RefVersionSeq,FamilyMapStatus=:FamilyMapStatus where GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq",sRefVersionSeq);
		q.setParameter("FamilyMapStatus","0");//�����׸���״̬����Ϊ0,�ݸ�
		q.executeUpdate();
		return sRefVersionSeq;
	}	
	/**
	 * ��ȡ�����ⲿ��Ϣ����һ�汾�ⲿ��Ϣ�İ汾���
	 * @return ���������ⲿ��Ϣ����һ�汾�ⲿ��Ϣ�İ汾���
	 * @throws Exception
	 */
	public String getRefExternalVersionSeq() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		//���ſͻ�����ά���ļ��װ汾
		String sRefExternalVersionSeq="";
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		q = m.createQuery("VersionSeq=:VersionSeq and GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",refVersionSeq);
		bo=q.getSingleResult();
		if(bo!=null){
			sRefExternalVersionSeq=bo.getAttribute("RefVersionSeq").getString();
		}
		
		return sRefExternalVersionSeq;
	}
	
	/**
	 * ��ʱ�Ĺ���
	 * @return 
	 * @throws Exception
	 */
	public String updateVersionSeq(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		//���ſͻ��ſ�
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set RefVersionSeq=:RefVersionSeq1,CurrentVersionSeq=:CurrentVersionSeq where GroupID=:GroupID and RefVersionSeq=:RefVersionSeq2");
		q.setParameter("RefVersionSeq1",currentVersionSeq);
		q.setParameter("CurrentVersionSeq",currentVersionSeq);
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq2",refVersionSeq);
		q.executeUpdate();
		//���װ汾�汾
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("update O set VersionSeq=:VersionSeq1 where VersionSeq=:VersionSeq2 and GroupID=:GroupID");
		q.setParameter("VersionSeq1",currentVersionSeq);
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq2",refVersionSeq);
		q.executeUpdate();
		//���׳�Ա��
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q = m.createQuery("update O set VersionSeq=:VersionSeq1 where VersionSeq=:VersionSeq2 and GroupID=:GroupID");
		q.setParameter("VersionSeq1",currentVersionSeq);
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq2",refVersionSeq);
		q.executeUpdate();
		
		return "true";
	}
	
	/**
	 * ��ʼ�����װ汾��
	 * @param sMemberID
	 * @return ���ؼ��װ汾���
	 * @throws Exception
	 */
	public String initializeFamilyVersion(String sVersionSeq,JBOTransaction tx) throws Exception {
		BizObjectManager m =null;
		BizObject bo = null;
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		bo=m.newObject();
		bo.getAttribute("GroupID").setValue(groupID);
		bo.getAttribute("VersionSeq").setValue(sVersionSeq);
		bo.getAttribute("InfoSource").setValue("S");//��Ϣ��Դ:ϵͳ�ڲ�
		bo.getAttribute("EffectiveStatus").setValue("0");//��Ч��־Ϊ�ݸ�
		bo.getAttribute("RefVersionSeq").setValue(currentVersionSeq);//��һ���װ汾���
		bo.getAttribute("ApproveUserID").setValue(ASUserObject.getUser(userID).getUserID());
		bo.getAttribute("InputUserID").setValue(ASUserObject.getUser(userID).getUserID());
		bo.getAttribute("InputOrgID").setValue(ASUserObject.getUser(userID).getOrgID());
		bo.getAttribute("InputDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		bo.getAttribute("UpdateDate").setValue(DateX.format(new java.util.Date(), "yyyy/MM/dd"));
		tx.join(m);
		m.saveObject(bo);
		
		return "S"+getTodayString();
	}

	/**
	 * ��ʼ�����׳�Ա��,�����Ѹ���ͨ���ļ��װ汾
	 * @InputParam
	 * @return
	 * @throws Exception
	 */
	public String initializeFamilyMember(String sVersionSeq,JBOTransaction tx) throws Exception {
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		BizObject bo1 = null;
		String sReturn="";
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q=m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",currentVersionSeq);
		List list=q.getResultList();
		for(int i=0;i<list.size();i++)
		{
			bo=(BizObject) list.get(i);
			bo1=m.newObject();
			bo1.setAttributesValue(bo);
			//���ð汾��
			bo1.getAttribute("VersionSeq").setValue(sVersionSeq);
			m.saveObject(bo1);
		}
		return sReturn;
	}
	
	/**
	 * ���������ⲿ��Ϣ
	 * @return
	 * @throws Exception
	 */
	public String copyLatestVersion(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectManager m1 =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		BizObject bo1 = null;
		List list = null;
		ASUserObject curUser=ASUserObject.getUser(userID);
		//���ſͻ������ⲿ��Ϣ�汾
		String sLastestVersionSeq="";
		//����Ա���ű��
		String sParentMemberID="";
		//�ؽ��ļ��ż��װ汾���
		String sVersionSeq="S"+getTodayString();
		String sToday = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		//��ȡ�����ⲿ��Ϣ�汾���
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		q = m.createQuery("GroupID=:GroupID and InfoSource=:InfoSource and EffectiveStatus=:EffectiveStatus and Status=:Status");
		q.setParameter("GroupID",groupID);
		q.setParameter("InfoSource","X");//�ⲿ��Ϣ
		q.setParameter("EffectiveStatus","9");//�Ѵ���
		q.setParameter("Status","1");//��Ч
		bo = q.getSingleResult();
		if(bo != null){
			sLastestVersionSeq=bo.getAttribute("VersionSeq").getString();
		}
		if(sLastestVersionSeq==null) sLastestVersionSeq="";
		if("".equals(sLastestVersionSeq)){
			ARE.getLog("��ȡ�����ⲿ��Ϣʧ��!");
			return "false";
		}
		
		//��ȡ�����ⲿ��Ϣ����
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",sLastestVersionSeq);
		list=q.getResultList();
		//����ǰ��ڵ��Ա���MemberID
		String[][] sParentMemberIDs=new String[list.size()][2];
		int j=1;
		for(int i=0;i<list.size();i++){
			bo=(BizObject) list.get(i);
			sParentMemberID=bo.getAttribute("ParentMemberID").getString();
			boolean bLeafOrNot=checkLeafOrNot(bo.getAttribute("GroupID").getString(),bo.getAttribute("VersionSeq").getString(),bo.getAttribute("MemberID").getString());
			//sParentMemberIDs[0][0]����ⲿ��Ϣ��ĸ��˾��Ա���,��Ҷ�ڵ�ļ��ų�Ա�Ŀ���ǰ��ڵ��Ա��Ŵ�sParentMemberIDs[1][0]��ʼ�洢
			//����������ĸ��˾
			if(!"None".equals(sParentMemberID)){
				m1 = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
				bo1=m1.newObject();
				bo1.setAttributesValue(bo);
				bo1.setAttributeValue("VersionSeq",sVersionSeq);
				bo1.setAttributeValue("InfoSource","S");
				bo1.setAttributeValue("ReviseFlag","NEW");
				//ϵͳ������Ϣ
				bo1.setAttributeValue("InputDate",sToday);
				bo1.setAttributeValue("UpdateDate",sToday);
				bo1.setAttributeValue("InputUserID",curUser.getUserID());
				bo1.setAttributeValue("InputOrgID",curUser.getOrgID());
				/*
				//���¼��ų�Ա�ͻ����(ԭʼֵ),���ų�Ա����(ԭʼֵ),�븸��Ա��ϵ(ԭʼֵ)���ֹɱ���(ԭʼֵ)���϶�����(ԭʼֵ)����Ա����(ԭʼֵ)
				bo1.setAttributeValue("OldMemberCustomerID",bo.getAttribute("MemberCustomerID").getString());
				bo1.setAttributeValue("OldMemberName",bo.getAttribute("MemberName").getString());
				bo1.setAttributeValue("OldParentRelationType",bo.getAttribute("ParentRelationType").getString());
				bo1.setAttributeValue("OldShareValue",bo.getAttribute("ShareValue").getDouble());
				bo1.setAttributeValue("OldReasonType",bo.getAttribute("ReasonType").getString());
				bo1.setAttributeValue("OldMemberType",bo.getAttribute("MemberType").getString());
				*/
				tx.join(m1);
				m1.saveObject(bo1);
				//���ӽڵ�ŶԸ���ǰ���Ա��Ž��б���
				if(!bLeafOrNot){
					sParentMemberIDs[j][0]=bo.getAttribute("MemberID").getString();//�ⲿ��Ϣ�иýڵ��Ա���
					sParentMemberIDs[j][1]=bo1.getAttribute("MemberID").getString();//������ϵͳ��Ϣ�иýڵ��Ա���
					j++;
				}
			}else{
				//�洢ĸ��˾��Ա���
				sParentMemberIDs[0][0]=bo.getAttribute("MemberID").getString();
			}
		}
		
		//������ɺ�,�Կ����õ���ϵͳ��Ϣ��ͼ�ڵ�ĸ��ڵ��Ա���ParentMemberID�����滻
		for(int i=1;i<sParentMemberIDs.length;i++){
			String sOldParentMemberID=sParentMemberIDs[i][0];
			String sNewParentMemberID=sParentMemberIDs[i][1];
			m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
			tx.join(m);
			q = m.createQuery("update O set ParentMemberID=:ParentMemberID1 where GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID2");
			q.setParameter("ParentMemberID1",sNewParentMemberID);
			q.setParameter("GroupID",groupID);
			q.setParameter("VersionSeq",sVersionSeq);
			q.setParameter("ParentMemberID2",sOldParentMemberID);
			q.executeUpdate();
		}
		//����ĸ��˾Ϊ���ڵ�ĳ�Ա�ĸ��ڵ��Ž��е�������
		String sNewKeyMemberID="";//ϵͳ��Ϣ��ĸ��˾��ԱID
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID ");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",sVersionSeq);
		q.setParameter("ParentMemberID","None");
		bo=q.getSingleResult();
		if(bo!=null){
			sNewKeyMemberID=bo.getAttribute("MemberID").getString();
			if(sNewKeyMemberID==null) sNewKeyMemberID=""; 
		}else{
			//������
		}
		//
		tx.join(m);
		q = m.createQuery("update O set ParentMemberID=:ParentMemberID1 where GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID2");
		q.setParameter("ParentMemberID1",sNewKeyMemberID);
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",sVersionSeq);
		q.setParameter("ParentMemberID2",sParentMemberIDs[0][0]);
		q.executeUpdate();
		
		
		return "true";
	}
	/**
	 * У��ó�Ա�ڵ��Ƿ�ΪҶ�ڵ�(��û���ӽڵ�),�Ƿ���true,���򷵻�false
	 * @return
	 * @throws Exception
	 */
	private boolean checkLeafOrNot(String sGroupID,String sVersionSeq,String sMemberID) throws Exception {
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq and ParentMemberID=:ParentMemberID");
		q.setParameter("GroupID",sGroupID);
		q.setParameter("VersionSeq",sVersionSeq);
		q.setParameter("ParentMemberID",sMemberID);
		bo=q.getSingleResult();
		if(bo!=null){//�ܲ�ѯ���Ըó�Ա���Ϊ����Ա��ŵļ��ų�Ա
			return false;
		}
		return true;
	}
	
	/**
	 * �ؽ�����
	 * 1.��ʼ�����ױ�      
	 * 2.��ʼ�����װ汾��
	 * 3.���¼��ſͻ���Ϣ������ʹ�ü��װ汾������ά�����װ汾�����װ汾״̬�ֶ�
	 * @return 
	 */
	public String recreateFamily(JBOTransaction tx) throws Exception {
		ASUserObject curUser=ASUserObject.getUser(userID);
		//��ǰ����ʹ�õļ��װ汾���
		String sCurrentVersionSeq="";
		String sVersionSeq="S"+getTodayString();
		String sToday=DateX.format(new java.util.Date(), "yyyy/MM/dd");
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectManager m1 =null;
		BizObjectManager m2 =null;
		BizObjectManager m3 =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		BizObject bo1 = null;
		
		m1 = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		m2 = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		m3 = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m1);
		tx.join(m2);
		tx.join(m3);
		try{
			//��ȡ����ʹ�õļ��װ汾��Ϣ
			m = f.getManager("jbo.app.GROUP_INFO");
			q = m.createQuery("GroupID=:GroupID");
			q.setParameter("GroupID",groupID);
			bo = q.getSingleResult();
			if(bo != null){
				sCurrentVersionSeq=bo.getAttribute("CurrentVersionSeq").getString();
				if(sCurrentVersionSeq==null) sCurrentVersionSeq="";
				//��ʼ�����ױ�GROUP_FAMILY_MEMBER(ĸ��˾)
				bo1=m1.newObject();
				bo1.getAttribute("GroupID").setValue(groupID);
				bo1.getAttribute("VersionSeq").setValue(sVersionSeq);
				bo1.setAttributeValue("ReviseFlag","CHECKED");
				bo1.getAttribute("MemberName").setValue(bo.getAttribute("GroupName").getString());//���ſͻ�����=����ĸ��˾�ͻ�����
				bo1.getAttribute("MemberCustomerID").setValue(groupID.substring(1));//���ſͻ����="G"+����ĸ��˾�ͻ����
				bo1.getAttribute("MemberType").setValue("01");//ĸ��˾
				bo1.getAttribute("ParentMemberID").setValue("None");//ĸ��˾����Ա�����ΪNone
				bo1.getAttribute("MemberCertType").setValue("Ent01");//����ĸ��˾����������֯�������뽨���ͻ��Ĺ�˾�ͻ�
				bo1.getAttribute("MemberCertID").setValue(bo.getAttribute("GroupCorpID").getString());
				bo1.getAttribute("MemberCorpID").setValue(bo.getAttribute("GroupCorpID").getString());
				bo1.getAttribute("InfoSource").setValue("S");//��Ϣ��Դ:ϵͳ�ڲ�
				bo1.getAttribute("InputUserID").setValue(ASUserObject.getUser(userID).getUserID());
				bo1.getAttribute("InputOrgID").setValue(ASUserObject.getUser(userID).getOrgID());
				bo1.getAttribute("InputDate").setValue(StringFunction.getToday());
				bo1.getAttribute("UpdateDate").setValue(StringFunction.getToday());
				tx.join(m1);
				m1.saveObject(bo1);
			}
			//��ʼ�����װ汾��(GROUP_FAMILY_VERSION)
			bo1=m2.newObject();
			bo1.setAttributeValue("GroupID",groupID);
			bo1.setAttributeValue("VersionSeq",sVersionSeq);
			bo1.setAttributeValue("InfoSource","S");
			bo1.setAttributeValue("EffectiveStatus","0");//�ݸ�
			bo1.setAttributeValue("RefVersionSeq",sCurrentVersionSeq);//����ǰ����ʹ�õļ��װ汾��Ÿ���Ϊ�ؽ��ļ�����һ���װ汾���
			bo1.setAttributeValue("InputDate",sToday);
			bo1.setAttributeValue("UpdateDate",sToday);
			bo1.setAttributeValue("InputUserID",curUser.getUserID());
			bo1.setAttributeValue("InputOrgID",curUser.getOrgID());
			tx.join(m2);
			m2.saveObject(bo1);
			//���¼��ſͻ���Ϣ������ά�����װ汾�����װ汾״̬�ֶ�
			q = m3.createQuery("GroupID=:GroupID");
			q.setParameter("GroupID",groupID);
			bo = q.getSingleResult();
			if(bo != null){
				bo.setAttributeValue("RefVersionSeq",sVersionSeq);
				bo.setAttributeValue("FamilyMapStatus","0");
				tx.join(m3);
				m3.saveObject(bo);
			}
			tx.commit();
		}catch(JBOException ex){
			tx.rollback();
		}
		return sVersionSeq;
	}
	
	/**
	 * ��ȡ��ǰ���ڵ������ַ���,��ʽΪYYYYmmdd
	 * @return ��ǰ���ڵ������ַ���
	 */
	public String getTodayString(){
		String sToday=DateX.format(new java.util.Date(), "yyyy/MM/dd");
		String sTodayString=sToday.substring(0,4)+sToday.substring(5,7)+sToday.substring(8);
		
		return sTodayString;
	}
}
