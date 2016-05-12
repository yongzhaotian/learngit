package com.amarsoft.app.als.customer.group.model;

import java.util.List;

import com.amarsoft.app.als.bizobject.customer.GroupCustomer;
import com.amarsoft.app.als.customer.common.action.OperCustomer;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DateX;

/**
 * ���ſͻ����׸��˽׶α��
 * 
 * @author rsu
 * @since 2010/09/20
 * 
 */
public class UpdateFamilyApproveStatus {

	private String groupID; // ���ſͻ����
	private String versionSeq; // ���ż��װ汾���
	private String effectiveStatus; // ���˽׶�
	private String userID; // ���˲�����
	private String changeAddressType; // �Ƿ���������������
	private String opinion;//�������
	private String serialNo;

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getOpinion() {
		return opinion;
	}

	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}

	public String getGroupID() {
		return groupID;
	}

	public void setGroupID(String groupID) {
		this.groupID = groupID;
	}

	public String getVersionSeq() {
		return versionSeq;
	}

	public void setVersionSeq(String versionSeq) {
		this.versionSeq = versionSeq;
	}

	public String getEffectiveStatus() {
		return effectiveStatus;
	}

	public void setEffectiveStatus(String effectiveStatus) {
		this.effectiveStatus = effectiveStatus;
	}

	public String getUserID() {
		return userID;
	}

	public void setUserID(String userID) {
		this.userID = userID;
	}

	public void setChangeAddressType(String changeAddressType) {
		this.changeAddressType = changeAddressType;
	}

	public String getChangeAddressType() {
		return changeAddressType;
	}

	/**
	 * @InputParam <p>
	 *             
	 * @return
	 * @throws Exception
	 */
	public String updateFamilyApproveOpinion(JBOTransaction tx) throws Exception {
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m = null;
		BizObjectQuery q = null;

		ASUserObject curUser = ASUserObject.getUser(userID);

		// ���¼��ż��׸��������
		m = f.getManager("jbo.app.GROUP_FAMILY_OPINION");
		tx.join(m);
		q = m.createQuery("update o set ApproveUserID=:ApproveUserID,ApproveUserName=:ApproveUserName,Opinion=:Opinion,ApproveTime=:ApproveTime,ApproveType=:ApproveType where SerialNo=:SerialNo");
		q.setParameter("ApproveUserID", curUser.getUserID());
		q.setParameter("ApproveUserName", curUser.getUserName());
		q.setParameter("Opinion", opinion);//���
		q.setParameter("ApproveTime", DateX.format(new java.util.Date(), "yyyy/MM/dd"));//����ʱ��
		q.setParameter("ApproveType", effectiveStatus);//����״̬
		q.setParameter("SerialNo", serialNo);//������к�
		q.executeUpdate();
		return "SUCCEEDED";
	}
	
	/**
	 * @InputParam <p>
	 *             GroupID: ���ſͻ����
	 *             <p>
	 *             VersionSeq: ���װ汾��
	 *             <p>
	 *             EffectiveStatus: ����״̬
	 *             <p>
	 *             UserID: ���˲���ԱID
	 * @return
	 * @throws Exception
	 */
	public String updateFamilyApproveStatus(JBOTransaction tx) throws Exception {
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		String sReviseFlag = "";
		String sEventValue = "";
		String sOldEventValue = "";
		String sRefMemberID = "";
		String sRefMemberName = "";
		ASUserObject curUser = ASUserObject.getUser(userID);

		// ���¼��װ汾��
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("Update o set  EffectiveStatus=:EffectiveStatus,UpdateDate=:UpdateDate where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("EffectiveStatus", effectiveStatus);// ����״̬
		q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// ����ʱ��
		q.setParameter("GroupID", groupID);
		q.setParameter("VersionSeq", versionSeq);
		q.executeUpdate();

		// ���¼��ſͻ���GROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		String sSql = "";
		if ("2".equals(effectiveStatus)) {// ����ͨ��ʱ
			sSql = "update o set ApproveOrgID=:ApproveOrgID,ApproveUserID = :ApproveUserID,ApproveDate= :ApproveDate,FamilyMapStatus=:FamilyMapStatus,CurrentVersionSeq=:CurrentVersionSeq ,UpdateDate=:UpdateDate where GroupID=:GroupID";
			q = m.createQuery(sSql);
			q.setParameter("ApproveOrgID", curUser.getOrgID());// ���˻���
			q.setParameter("ApproveUserID", curUser.getUserID());// ������
			q.setParameter("ApproveDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// ��������
			q.setParameter("FamilyMapStatus", effectiveStatus);
			q.setParameter("CurrentVersionSeq", versionSeq);// ����ͨ��,������ʹ�õļ��װ汾����ֶθ���Ϊ�ø���ͨ���ļ��װ汾���
			q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// ����ʱ��
			q.setParameter("GroupID", groupID);
		} else {
			sSql = "update o set ApproveOrgID=:ApproveOrgID,ApproveUserID = :ApproveUserID,ApproveDate= :ApproveDate,FamilyMapStatus=:FamilyMapStatus  ,UpdateDate=:UpdateDate where GroupID=:GroupID";
			q = m.createQuery(sSql);
			q.setParameter("ApproveOrgID", curUser.getOrgID());// ���˻���
			q.setParameter("ApproveUserID", curUser.getUserID());// ������
			q.setParameter("ApproveDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// ��������
			q.setParameter("FamilyMapStatus", effectiveStatus);
			q.setParameter("CurrentVersionSeq", versionSeq);// ������ʹ�õļ��װ汾����ֶθ���Ϊ�ø����˻صļ��װ汾���
			q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// ����ʱ��
			q.setParameter("GroupID", groupID);
		}
		q.executeUpdate();

		String sOldGroupType1 = "";
		String sNewGroupType1 = "";
		// �Ƿ���ļ�����������
		if ("1".equals(changeAddressType)) {
			BizObject boc = m.createQuery(" groupID=:GroupID")
					.setParameter("GroupID", groupID).getSingleResult(true);
			if (boc != null) {
				sOldGroupType1 = boc.getAttribute("GroupType1").getString();
				if (sOldGroupType1.equals("01")) {
					sNewGroupType1 = "02";
				} else if (sOldGroupType1.equals("02")) {
					sNewGroupType1 = "01";
				}
			}
			boc.setAttributeValue("GroupType1", sNewGroupType1);
			boc.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			tx.join(m);
			m.saveObject(boc);
			// ��¼�����ʷ
			BizObjectManager bom = f.getManager("jbo.app.GROUP_EVENT");
			tx.join(bom);
			BizObject boj = bom.newObject();
			boj.setAttributeValue("GroupID", groupID); // ���ſͻ����
			boj.setAttributeValue("EventType", "05"); // �¼����� �������Ա��
			boj.setAttributeValue("OccurDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // ��������
			boj.setAttributeValue("EventValue", sNewGroupType1); // ����ֵ
			boj.setAttributeValue("OldEventValue", sOldGroupType1);
			if ("01".equals(sNewGroupType1)) {
				boj.setAttributeValue("ChangeContext",
						"�����������������ݵ������������ſͻ����Ϊ�����ڼ��ſͻ�");// �������
			} else {
				boj.setAttributeValue("ChangeContext",
						"�������������ɵ����ڱ��Ϊ���ݵ������������ſͻ����ſͻ�");
			}

			boj.setAttributeValue("InputOrgID", curUser.getOrgID()); // �Ǽǻ���
			boj.setAttributeValue("InputUserID", curUser.getUserID()); // �Ǽ���
			boj.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // �Ǽ�����
			boj.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // �޸�����
			bom.saveObject(boj);
		}
		// ����ͨ��ʱ,���ӶԼ��׳�Ա��Ĵ���
		if ("2".equals(effectiveStatus)) {
			
			// ����ͨ���󣬽���ǰ�ļ��׳�Ա��Ϣɾ����������ͨ����ļ��׳�Ա��Ϣ���뵱ǰ���׳�Ա��
			BizObjectManager rm = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
			tx.join(rm);
			q = rm.createQuery("delete from o where GroupID=:GroupID");
			q.setParameter("GroupID", groupID);
			q.executeUpdate();
			
			// ����ͨ��ʱ�����ӶԼ��ų�Ա(��Ա�ͻ���š���Ա���ơ��븸��Ա��ϵ���ֹɱ������϶����͡���Ա����)��Ϣ����
			m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
			tx.join(m);
			q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq").setParameter("GroupID", groupID).setParameter("VersionSeq", versionSeq);
			@SuppressWarnings("unchecked")
			List<BizObject> list = q.getResultList(true);
			for (BizObject boTemp : list) {
				/*
				 * ���ü��ų�Ա�޶����Ϊ��������ʱ,����Ա�ͻ����ԭʼֵ(OLDMEMBERCUSTOMERID)����Ա����ԭʼֵ(
				 * OLDMEMBERNAME)��
				 * �븸��Ա��ϵԭʼֵ(OLDPARENTRELATIONTYPE)���ֹɱ���ԭʼֵ(OLDSHAREVALUE
				 * )���϶�����ԭʼֵ(OLDREASONTYPE)��
				 * ��Ա����ԭʼֵ(OLDMEMBERTYPE)����Ϊ����ֵ(OLDMEMBERCUSTOMERID
				 * ��OLDMEMBERNAME��
				 * OLDPARENTRELATIONTYPE��OLDSHAREVALUE��OLDREASONTYPE
				 * ��OLDMEMBERTYPE)
				 */
				/*
				 * ���޶���־Ϊ���ʱ����ǡ���ķ�ʽ��Ӧ���ǽ���Ա�ͻ�������Ա�ͻ����ԭʼֵ��6����Ϣ����ȡ�������Ƚϣ������ͬ�������ԭʼֵ
				 * �� ����ͼ򵥴���ȫ������
				 */
				sReviseFlag = boTemp.getAttribute("ReviseFlag").getString();
				sRefMemberName = boTemp.getAttribute("MemberName").getString();
				if ("NEW".equals(sReviseFlag) || "CHANGED".equals(sReviseFlag)) {
					// ��Ա�ͻ����
					boTemp.setAttributeValue("OldMemberCustomerID", boTemp.getAttribute("MemberCustomerID").getString());
					// ��Ա����
					boTemp.setAttributeValue("OldMemberName",boTemp.getAttribute("MemberName").getString());
					// �븸�ڵ��ϵ
					boTemp.setAttributeValue("OldParentRelationType", boTemp.getAttribute("ParentRelationType").getString());
					// �ֹɱ���
					boTemp.setAttributeValue("OldShareValue",boTemp.getAttribute("ShareValue").getString());
					// �϶�����
					boTemp.setAttributeValue("OldReasonType",boTemp.getAttribute("ReasonType").getString());
					// ��Ա����
					boTemp.setAttributeValue("OldMemberType",boTemp.getAttribute("MemberType").getString());
					// ����ͨ��,�����޶���־Ϊ�Ѹ���
					boTemp.setAttributeValue("ReviseFlag", "CHECKED");
					m.saveObject(boTemp);
				} else if ("REMOVED".equals(sReviseFlag)) {// �����ų�Ա�޶���־Ϊɾ��ʱ,����ɾ���ó�Ա
					//tx.join(m);
					m.deleteObject(boTemp);
				}
				
				 if (!"REMOVED".equals(sReviseFlag)) {
					// ������ͨ����ĳ�Ա��Ϣ���Ƶ���ǰ���׳�Ա��
					BizObject bom = rm.newObject();
					bom.setAttributesValue(boTemp);
					bom.setAttributeValue("GroupCustomerType", "0210");// ���ſͻ���Ա
					bom.setAttributeValue("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			
					rm.saveObject(bom);
				}
				// ����ͨ��ʱ��¼��Ա������
				// ��¼���ſͻ��¼�
				if ("NEW".equals(sReviseFlag) || "REMOVED".equals(sReviseFlag)) {
					BizObjectManager fm = f.getManager("jbo.app.GROUP_EVENT");
					tx.join(fm);
					BizObject boe = fm.newObject();
					boe.setAttributeValue("GroupID", groupID); // ���ſͻ����
					boe.setAttributeValue("RefMemberID", sRefMemberID); // ���ų�Ա���
					boe.setAttributeValue("RefMemberName", sRefMemberName); // ���ų�Ա����
					boe.setAttributeValue("EventType", "03"); // �¼�����
					boe.setAttributeValue("OccurDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // ��������
					boe.setAttributeValue("EventValue", sEventValue); // ����ֵ
					boe.setAttributeValue("OldEventValue", sOldEventValue);
					if ("NEW".equals(sReviseFlag)) {
						boe.setAttributeValue("ChangeContext", "����"
								+ sRefMemberName + "��Ա��˾");// �������
					}
					if ("REMOVED".equals(sReviseFlag)) {
						boe.setAttributeValue("ChangeContext", "ɾ��"
								+ sRefMemberName + "��Ա��˾");
					}
					boe.setAttributeValue("InputOrgID", curUser.getOrgID()); // �Ǽǻ���
					boe.setAttributeValue("InputUserID", curUser.getUserID()); // �Ǽ���
					boe.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // �Ǽ�����
					boe.setAttributeValue("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd")); // �޸�����
					fm.saveObject(boe);
				}
				
				GroupCustomer groupCustomer = new GroupCustomer();
				groupCustomer.setGroupID(groupID);
				groupCustomer.setKeyMemberCustomerID(boTemp.getAttribute("MemberCustomerID").getString());
				groupCustomer.setInputOrgID(boTemp.getAttribute("InputOrgID").getString());
				groupCustomer.setInputUserID(boTemp.getAttribute("InputUserID").getString());
				OperCustomer.updateEntCustomer("1", groupCustomer, tx);		//����ENT_INFO�ֶ� 	
				OperCustomer.updateCustomerInfo(groupCustomer, tx);		//����CUSTOMER_INFO�ֶ� 
			}
			
			//��ȡ��Ա������ͻ�����
			m = f.getManager("jbo.app.CUSTOMER_BELONG");
			tx.join(m);
			String sql = "select distinct orgid,userid from O,jbo.app.GROUP_FAMILY_MEMBER GFM where O.customerID =GFM.membercustomerid " +
						"and GFM.VersionSeq=:VersionSeq and O.belongattribute = '1' and GFM.groupid=:GroupID and O.UserID not in " +
						"(select O.UserID from O where O.CustomerID=:GroupID and BelongAttribute='1')";
			q = m.createQuery(sql).setParameter("VersionSeq", versionSeq).setParameter("GroupID", groupID);
			List<BizObject> belongList = q.getResultList();
			
			//��ʼ��CUSTOMER_BELONG
			initCustomerBelong("2",groupID,belongList,tx);	
		}
		return "SUCCEEDED";
	}
	
	/**
	 * ��ʼ���ͻ�������CUSTOMER_BELONG
	 * @param sAttribute
	 * @param customer
	 * @param tx
	 * @throws JBOException
	 */
	private void initCustomerBelong(String sAttribute,String groupID,List<BizObject> list,JBOTransaction tx) throws JBOException{
		String sToday = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		tx.join(m);
		//��ɾ��������Ϣ
		BizObjectQuery bq = m.createQuery("delete from O where CustomerID=:CustomerID and belongAttribute='2'").setParameter("CustomerID", groupID);
		bq.executeUpdate();
		//������
		for(int i = 0;i<list.size();i++){
			BizObject tempBo = list.get(i);
			
			BizObject bo = m.newObject();
			bo.setAttributeValue("CustomerID",groupID); 		// ���ſͻ�ID
			bo.setAttributeValue("OrgID",tempBo.getAttribute("OrgID").getString());				// ��Ȩ����ID
			bo.setAttributeValue("UserID",tempBo.getAttribute("UserID").getString());				// ��Ȩ��ID
			bo.setAttributeValue("BelongAttribute",sAttribute);	// ����Ȩ
			bo.setAttributeValue("BelongAttribute1","1");	// ��Ϣ�鿴Ȩ
			bo.setAttributeValue("BelongAttribute2",sAttribute);	// ��Ϣά��Ȩ
			bo.setAttributeValue("BelongAttribute3",sAttribute);	// ����ҵ�����Ȩ
			//bo.setAttributeValue("BelongAttribute4","1");	//�ͷ���ҵ�����Ȩ
			bo.setAttributeValue("InputOrgID",tempBo.getAttribute("OrgID").getString());			// �Ǽǻ���
			bo.setAttributeValue("InputUserID",tempBo.getAttribute("UserID").getString());			// �Ǽ���
			bo.setAttributeValue("InputDate",sToday);			// �Ǽ�����
			bo.setAttributeValue("UpdateDate",sToday);			// ��������
		
			m.saveObject(bo);
		}
		
	}
	
}
