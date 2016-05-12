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
 * 集团客户家谱复核阶段变更
 * 
 * @author rsu
 * @since 2010/09/20
 * 
 */
public class UpdateFamilyApproveStatus {

	private String groupID; // 集团客户编号
	private String versionSeq; // 集团家谱版本编号
	private String effectiveStatus; // 复核阶段
	private String userID; // 复核操作人
	private String changeAddressType; // 是否变更集团区域属性
	private String opinion;//复核意见
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

		// 更新集团家谱复核意见表
		m = f.getManager("jbo.app.GROUP_FAMILY_OPINION");
		tx.join(m);
		q = m.createQuery("update o set ApproveUserID=:ApproveUserID,ApproveUserName=:ApproveUserName,Opinion=:Opinion,ApproveTime=:ApproveTime,ApproveType=:ApproveType where SerialNo=:SerialNo");
		q.setParameter("ApproveUserID", curUser.getUserID());
		q.setParameter("ApproveUserName", curUser.getUserName());
		q.setParameter("Opinion", opinion);//意见
		q.setParameter("ApproveTime", DateX.format(new java.util.Date(), "yyyy/MM/dd"));//复核时间
		q.setParameter("ApproveType", effectiveStatus);//复核状态
		q.setParameter("SerialNo", serialNo);//意见序列号
		q.executeUpdate();
		return "SUCCEEDED";
	}
	
	/**
	 * @InputParam <p>
	 *             GroupID: 集团客户编号
	 *             <p>
	 *             VersionSeq: 家谱版本号
	 *             <p>
	 *             EffectiveStatus: 家谱状态
	 *             <p>
	 *             UserID: 复核操作员ID
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

		// 更新家谱版本表
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("Update o set  EffectiveStatus=:EffectiveStatus,UpdateDate=:UpdateDate where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("EffectiveStatus", effectiveStatus);// 复核状态
		q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// 更新时间
		q.setParameter("GroupID", groupID);
		q.setParameter("VersionSeq", versionSeq);
		q.executeUpdate();

		// 更新集团客户表GROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		String sSql = "";
		if ("2".equals(effectiveStatus)) {// 复核通过时
			sSql = "update o set ApproveOrgID=:ApproveOrgID,ApproveUserID = :ApproveUserID,ApproveDate= :ApproveDate,FamilyMapStatus=:FamilyMapStatus,CurrentVersionSeq=:CurrentVersionSeq ,UpdateDate=:UpdateDate where GroupID=:GroupID";
			q = m.createQuery(sSql);
			q.setParameter("ApproveOrgID", curUser.getOrgID());// 复核机构
			q.setParameter("ApproveUserID", curUser.getUserID());// 复核人
			q.setParameter("ApproveDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// 复核日期
			q.setParameter("FamilyMapStatus", effectiveStatus);
			q.setParameter("CurrentVersionSeq", versionSeq);// 复核通过,将正在使用的家谱版本编号字段更新为该复核通过的家谱版本编号
			q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// 更新时间
			q.setParameter("GroupID", groupID);
		} else {
			sSql = "update o set ApproveOrgID=:ApproveOrgID,ApproveUserID = :ApproveUserID,ApproveDate= :ApproveDate,FamilyMapStatus=:FamilyMapStatus  ,UpdateDate=:UpdateDate where GroupID=:GroupID";
			q = m.createQuery(sSql);
			q.setParameter("ApproveOrgID", curUser.getOrgID());// 复核机构
			q.setParameter("ApproveUserID", curUser.getUserID());// 复核人
			q.setParameter("ApproveDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// 复核日期
			q.setParameter("FamilyMapStatus", effectiveStatus);
			q.setParameter("CurrentVersionSeq", versionSeq);// 将正在使用的家谱版本编号字段更新为该复核退回的家谱版本编号
			q.setParameter("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd"));// 更新时间
			q.setParameter("GroupID", groupID);
		}
		q.executeUpdate();

		String sOldGroupType1 = "";
		String sNewGroupType1 = "";
		// 是否更改集团区域属性
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
			// 记录变更历史
			BizObjectManager bom = f.getManager("jbo.app.GROUP_EVENT");
			tx.join(bom);
			BizObject boj = bom.newObject();
			boj.setAttributeValue("GroupID", groupID); // 集团客户编号
			boj.setAttributeValue("EventType", "05"); // 事件类型 区域属性变更
			boj.setAttributeValue("OccurDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 发生日期
			boj.setAttributeValue("EventValue", sNewGroupType1); // 发生值
			boj.setAttributeValue("OldEventValue", sOldGroupType1);
			if ("01".equals(sNewGroupType1)) {
				boj.setAttributeValue("ChangeContext",
						"集团区域属性由温州地区或跨地区集团客户变更为地区内集团客户");// 变更内容
			} else {
				boj.setAttributeValue("ChangeContext",
						"集团区域属性由地区内变更为温州地区或跨地区集团客户集团客户");
			}

			boj.setAttributeValue("InputOrgID", curUser.getOrgID()); // 登记机构
			boj.setAttributeValue("InputUserID", curUser.getUserID()); // 登记人
			boj.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 登记日期
			boj.setAttributeValue("UpdateDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 修改日期
			bom.saveObject(boj);
		}
		// 复核通过时,增加对家谱成员表的处理
		if ("2".equals(effectiveStatus)) {
			
			// 复核通过后，将以前的家谱成员信息删除，将复核通过后的家谱成员信息插入当前家谱成员表
			BizObjectManager rm = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
			tx.join(rm);
			q = rm.createQuery("delete from o where GroupID=:GroupID");
			q.setParameter("GroupID", groupID);
			q.executeUpdate();
			
			// 复核通过时，增加对集团成员(成员客户编号、成员名称、与父成员关系、持股比例、认定类型、成员类型)信息备份
			m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
			tx.join(m);
			q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq").setParameter("GroupID", groupID).setParameter("VersionSeq", versionSeq);
			@SuppressWarnings("unchecked")
			List<BizObject> list = q.getResultList(true);
			for (BizObject boTemp : list) {
				/*
				 * 当该集团成员修订标记为新增或变更时,将成员客户编号原始值(OLDMEMBERCUSTOMERID)、成员名称原始值(
				 * OLDMEMBERNAME)、
				 * 与父成员关系原始值(OLDPARENTRELATIONTYPE)、持股比例原始值(OLDSHAREVALUE
				 * )、认定类型原始值(OLDREASONTYPE)、
				 * 成员类型原始值(OLDMEMBERTYPE)更新为现有值(OLDMEMBERCUSTOMERID
				 * 、OLDMEMBERNAME、
				 * OLDPARENTRELATIONTYPE、OLDSHAREVALUE、OLDREASONTYPE
				 * 、OLDMEMBERTYPE)
				 */
				/*
				 * 当修订标志为变更时，最恰当的方式，应该是将成员客户编号与成员客户编号原始值等6组信息依次取出，并比较，如果不同，则更新原始值
				 * 。 这里就简单处理，全部更新
				 */
				sReviseFlag = boTemp.getAttribute("ReviseFlag").getString();
				sRefMemberName = boTemp.getAttribute("MemberName").getString();
				if ("NEW".equals(sReviseFlag) || "CHANGED".equals(sReviseFlag)) {
					// 成员客户编号
					boTemp.setAttributeValue("OldMemberCustomerID", boTemp.getAttribute("MemberCustomerID").getString());
					// 成员名称
					boTemp.setAttributeValue("OldMemberName",boTemp.getAttribute("MemberName").getString());
					// 与父节点关系
					boTemp.setAttributeValue("OldParentRelationType", boTemp.getAttribute("ParentRelationType").getString());
					// 持股比例
					boTemp.setAttributeValue("OldShareValue",boTemp.getAttribute("ShareValue").getString());
					// 认定类型
					boTemp.setAttributeValue("OldReasonType",boTemp.getAttribute("ReasonType").getString());
					// 成员类型
					boTemp.setAttributeValue("OldMemberType",boTemp.getAttribute("MemberType").getString());
					// 复核通过,更新修订标志为已复核
					boTemp.setAttributeValue("ReviseFlag", "CHECKED");
					m.saveObject(boTemp);
				} else if ("REMOVED".equals(sReviseFlag)) {// 当集团成员修订标志为删除时,物理删除该成员
					//tx.join(m);
					m.deleteObject(boTemp);
				}
				
				 if (!"REMOVED".equals(sReviseFlag)) {
					// 将复核通过后的成员信息复制到当前家谱成员表
					BizObject bom = rm.newObject();
					bom.setAttributesValue(boTemp);
					bom.setAttributeValue("GroupCustomerType", "0210");// 集团客户成员
					bom.setAttributeValue("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd"));
			
					rm.saveObject(bom);
				}
				// 复核通过时记录成员变更情况
				// 记录集团客户事件
				if ("NEW".equals(sReviseFlag) || "REMOVED".equals(sReviseFlag)) {
					BizObjectManager fm = f.getManager("jbo.app.GROUP_EVENT");
					tx.join(fm);
					BizObject boe = fm.newObject();
					boe.setAttributeValue("GroupID", groupID); // 集团客户编号
					boe.setAttributeValue("RefMemberID", sRefMemberID); // 集团成员编号
					boe.setAttributeValue("RefMemberName", sRefMemberName); // 集团成员名称
					boe.setAttributeValue("EventType", "03"); // 事件类型
					boe.setAttributeValue("OccurDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 发生日期
					boe.setAttributeValue("EventValue", sEventValue); // 发生值
					boe.setAttributeValue("OldEventValue", sOldEventValue);
					if ("NEW".equals(sReviseFlag)) {
						boe.setAttributeValue("ChangeContext", "新增"
								+ sRefMemberName + "成员公司");// 变更内容
					}
					if ("REMOVED".equals(sReviseFlag)) {
						boe.setAttributeValue("ChangeContext", "删除"
								+ sRefMemberName + "成员公司");
					}
					boe.setAttributeValue("InputOrgID", curUser.getOrgID()); // 登记机构
					boe.setAttributeValue("InputUserID", curUser.getUserID()); // 登记人
					boe.setAttributeValue("InputDate", DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 登记日期
					boe.setAttributeValue("UpdateDate",DateX.format(new java.util.Date(), "yyyy/MM/dd")); // 修改日期
					fm.saveObject(boe);
				}
				
				GroupCustomer groupCustomer = new GroupCustomer();
				groupCustomer.setGroupID(groupID);
				groupCustomer.setKeyMemberCustomerID(boTemp.getAttribute("MemberCustomerID").getString());
				groupCustomer.setInputOrgID(boTemp.getAttribute("InputOrgID").getString());
				groupCustomer.setInputUserID(boTemp.getAttribute("InputUserID").getString());
				OperCustomer.updateEntCustomer("1", groupCustomer, tx);		//更改ENT_INFO字段 	
				OperCustomer.updateCustomerInfo(groupCustomer, tx);		//更改CUSTOMER_INFO字段 
			}
			
			//获取成员的主办客户经理
			m = f.getManager("jbo.app.CUSTOMER_BELONG");
			tx.join(m);
			String sql = "select distinct orgid,userid from O,jbo.app.GROUP_FAMILY_MEMBER GFM where O.customerID =GFM.membercustomerid " +
						"and GFM.VersionSeq=:VersionSeq and O.belongattribute = '1' and GFM.groupid=:GroupID and O.UserID not in " +
						"(select O.UserID from O where O.CustomerID=:GroupID and BelongAttribute='1')";
			q = m.createQuery(sql).setParameter("VersionSeq", versionSeq).setParameter("GroupID", groupID);
			List<BizObject> belongList = q.getResultList();
			
			//初始化CUSTOMER_BELONG
			initCustomerBelong("2",groupID,belongList,tx);	
		}
		return "SUCCEEDED";
	}
	
	/**
	 * 初始化客户关联表CUSTOMER_BELONG
	 * @param sAttribute
	 * @param customer
	 * @param tx
	 * @throws JBOException
	 */
	private void initCustomerBelong(String sAttribute,String groupID,List<BizObject> list,JBOTransaction tx) throws JBOException{
		String sToday = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		tx.join(m);
		//先删除所属信息
		BizObjectQuery bq = m.createQuery("delete from O where CustomerID=:CustomerID and belongAttribute='2'").setParameter("CustomerID", groupID);
		bq.executeUpdate();
		//后新增
		for(int i = 0;i<list.size();i++){
			BizObject tempBo = list.get(i);
			
			BizObject bo = m.newObject();
			bo.setAttributeValue("CustomerID",groupID); 		// 集团客户ID
			bo.setAttributeValue("OrgID",tempBo.getAttribute("OrgID").getString());				// 有权机构ID
			bo.setAttributeValue("UserID",tempBo.getAttribute("UserID").getString());				// 有权人ID
			bo.setAttributeValue("BelongAttribute",sAttribute);	// 主办权
			bo.setAttributeValue("BelongAttribute1","1");	// 信息查看权
			bo.setAttributeValue("BelongAttribute2",sAttribute);	// 信息维护权
			bo.setAttributeValue("BelongAttribute3",sAttribute);	// 敞口业务办理权
			//bo.setAttributeValue("BelongAttribute4","1");	//低风险业务办理权
			bo.setAttributeValue("InputOrgID",tempBo.getAttribute("OrgID").getString());			// 登记机构
			bo.setAttributeValue("InputUserID",tempBo.getAttribute("UserID").getString());			// 登记人
			bo.setAttributeValue("InputDate",sToday);			// 登记日期
			bo.setAttributeValue("UpdateDate",sToday);			// 更新日期
		
			m.saveObject(bo);
		}
		
	}
	
}
