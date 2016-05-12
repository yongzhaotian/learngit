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
 * 家谱信息维护基类：提供以下方法
 *    1.checkVersionUnique:校验集团客户是否存在正在维护的家谱版本
 *    2.copyLatestVersion:拷贝最新外部信息
 *    3.recreateFamily:重建家谱
 *    4.submitVersion:提交复核
 *    5.getNewRefVersionSeq：获取最新的正在维护的家谱版本编号
 *
 * @author hwang
 * @since 2010/09/26
 *
 */
public class FamilyMaintain {

	private String groupID;		// 集团客户编号
	private String userID;		// 当前用户编号
	private String refVersionSeq;		// 集团客户正在维护的家谱版本编号
	private String currentVersionSeq;		// 集团客户正在使用的家谱版本编号
	private String oldMemberCustomerID;//集团家谱已认定版本中核心企业客户编号

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
	 * 校验集团客户是否存在正在维护的家谱版本
	 * @return
	 * @throws Exception
	 */
	public String checkVersionUnique() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		//集团客户正在使用的家谱版本
		String sCurrentVersionSeq="";
		//集团客户正在维护的家谱版本
		String sRefVersionSeq="";
		//集团客户家谱版本状态
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
		//集团客户正在使用家谱版本编号与正在维护家谱版本编号一致的情况有2种：
		//1.集团客户刚刚组建
		//2.家谱刚刚维护完成
		//1.集团客户组建时:正在使用的家谱版本与正在维护的家谱版本编号一致,并且家谱版本状态为草稿
		if(sCurrentVersionSeq.equals(sRefVersionSeq) && "0".equals(sFamilyMapStatus)){
			return "new";//该集团客户刚刚组建,家谱尚未建立,不需要重建家谱!
		}
		//2.家谱刚刚维护完成:正在使用的家谱版本和正在维护的家谱版本一致时，并且家谱版本状态为复核通过
		if(sCurrentVersionSeq.equals(sRefVersionSeq) && "3".equals(sFamilyMapStatus)){
			return "false";
		}
		
		return "true";
	}
	
	/**
	 * 删除当前正在维护的”草稿“状态下家谱版本信息，并更新GROUP_INFO表
	 * @return
	 * @throws Exception
	 */
	public String deleteRefVersion(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		// 删除对应的集团客户家谱版本信息GROUP_FAMILY_VERSION
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",refVersionSeq);
		q.executeUpdate();
		
		//删除对应的集团客户家谱成员信息GROUP_FAMILY_MEMBER
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",refVersionSeq);
		q.executeUpdate();
		
		//更新集团客户信息GROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set FamilyMapStatus=:FamilyMapStatus,RefVersionSeq=:RefVersionSeq,KeyMemberCustomerID=:KeyMemberCustomerID where GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq",currentVersionSeq);//将当前正在维护的家谱版本字段恢复成最新已认定的版本编号
		q.setParameter("KeyMemberCustomerID",oldMemberCustomerID);
		q.setParameter("FamilyMapStatus","2");
		q.executeUpdate();
		
		return "true";
	}
	
	/**
	 * 获取新的正在维护的家谱版本编号
	 * @return 返回新的正在维护的家谱版本编号
	 * @throws Exception
	 */
	public String getNewRefVersionSeq(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		//集团客户正在维护的家谱版本
		String sRefVersionSeq="S"+DateX.format(new java.util.Date(), "yyyy/MM/dd").replace("/", "")+StringFunction.getNow().replace(":","");
		initializeFamilyVersion(sRefVersionSeq,tx);
		//初始化家谱成员表：拷贝已复核的家谱
		initializeFamilyMember(sRefVersionSeq,tx);
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set RefVersionSeq=:RefVersionSeq,FamilyMapStatus=:FamilyMapStatus where GroupID=:GroupID");
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq",sRefVersionSeq);
		q.setParameter("FamilyMapStatus","0");//将家谱复核状态更新为0,草稿
		q.executeUpdate();
		return sRefVersionSeq;
	}	
	/**
	 * 获取最新外部信息的上一版本外部信息的版本编号
	 * @return 返回最新外部信息的上一版本外部信息的版本编号
	 * @throws Exception
	 */
	public String getRefExternalVersionSeq() throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		BizObject bo = null;
		//集团客户正在维护的家谱版本
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
	 * 暂时的功能
	 * @return 
	 * @throws Exception
	 */
	public String updateVersionSeq(JBOTransaction tx) throws Exception {
		
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m =null;
		BizObjectQuery q = null;
		//集团客户概况
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("update O set RefVersionSeq=:RefVersionSeq1,CurrentVersionSeq=:CurrentVersionSeq where GroupID=:GroupID and RefVersionSeq=:RefVersionSeq2");
		q.setParameter("RefVersionSeq1",currentVersionSeq);
		q.setParameter("CurrentVersionSeq",currentVersionSeq);
		q.setParameter("GroupID",groupID);
		q.setParameter("RefVersionSeq2",refVersionSeq);
		q.executeUpdate();
		//家谱版本版本
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("update O set VersionSeq=:VersionSeq1 where VersionSeq=:VersionSeq2 and GroupID=:GroupID");
		q.setParameter("VersionSeq1",currentVersionSeq);
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq2",refVersionSeq);
		q.executeUpdate();
		//家谱成员表
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
	 * 初始化家谱版本表
	 * @param sMemberID
	 * @return 返回家谱版本编号
	 * @throws Exception
	 */
	public String initializeFamilyVersion(String sVersionSeq,JBOTransaction tx) throws Exception {
		BizObjectManager m =null;
		BizObject bo = null;
		m = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		bo=m.newObject();
		bo.getAttribute("GroupID").setValue(groupID);
		bo.getAttribute("VersionSeq").setValue(sVersionSeq);
		bo.getAttribute("InfoSource").setValue("S");//消息来源:系统内部
		bo.getAttribute("EffectiveStatus").setValue("0");//生效标志为草稿
		bo.getAttribute("RefVersionSeq").setValue(currentVersionSeq);//上一家谱版本编号
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
	 * 初始化家谱成员表,拷贝已复核通过的家谱版本
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
			//设置版本号
			bo1.getAttribute("VersionSeq").setValue(sVersionSeq);
			m.saveObject(bo1);
		}
		return sReturn;
	}
	
	/**
	 * 拷贝最新外部信息
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
		//集团客户最新外部信息版本
		String sLastestVersionSeq="";
		//父成员集团编号
		String sParentMemberID="";
		//重建的集团家谱版本编号
		String sVersionSeq="S"+getTodayString();
		String sToday = DateX.format(new java.util.Date(), "yyyy/MM/dd");
		//获取最新外部信息版本编号
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		q = m.createQuery("GroupID=:GroupID and InfoSource=:InfoSource and EffectiveStatus=:EffectiveStatus and Status=:Status");
		q.setParameter("GroupID",groupID);
		q.setParameter("InfoSource","X");//外部信息
		q.setParameter("EffectiveStatus","9");//已处理
		q.setParameter("Status","1");//有效
		bo = q.getSingleResult();
		if(bo != null){
			sLastestVersionSeq=bo.getAttribute("VersionSeq").getString();
		}
		if(sLastestVersionSeq==null) sLastestVersionSeq="";
		if("".equals(sLastestVersionSeq)){
			ARE.getLog("获取最新外部信息失败!");
			return "false";
		}
		
		//获取最新外部信息家谱
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		q = m.createQuery("GroupID=:GroupID and VersionSeq=:VersionSeq");
		q.setParameter("GroupID",groupID);
		q.setParameter("VersionSeq",sLastestVersionSeq);
		list=q.getResultList();
		//拷贝前后节点成员编号MemberID
		String[][] sParentMemberIDs=new String[list.size()][2];
		int j=1;
		for(int i=0;i<list.size();i++){
			bo=(BizObject) list.get(i);
			sParentMemberID=bo.getAttribute("ParentMemberID").getString();
			boolean bLeafOrNot=checkLeafOrNot(bo.getAttribute("GroupID").getString(),bo.getAttribute("VersionSeq").getString(),bo.getAttribute("MemberID").getString());
			//sParentMemberIDs[0][0]存放外部信息的母公司成员编号,非叶节点的集团成员的拷贝前后节点成员编号从sParentMemberIDs[1][0]开始存储
			//不拷贝集团母公司
			if(!"None".equals(sParentMemberID)){
				m1 = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
				bo1=m1.newObject();
				bo1.setAttributesValue(bo);
				bo1.setAttributeValue("VersionSeq",sVersionSeq);
				bo1.setAttributeValue("InfoSource","S");
				bo1.setAttributeValue("ReviseFlag","NEW");
				//系统管理信息
				bo1.setAttributeValue("InputDate",sToday);
				bo1.setAttributeValue("UpdateDate",sToday);
				bo1.setAttributeValue("InputUserID",curUser.getUserID());
				bo1.setAttributeValue("InputOrgID",curUser.getOrgID());
				/*
				//更新集团成员客户编号(原始值),集团成员名称(原始值),与父成员关系(原始值)，持股比例(原始值)，认定类型(原始值)，成员类型(原始值)
				bo1.setAttributeValue("OldMemberCustomerID",bo.getAttribute("MemberCustomerID").getString());
				bo1.setAttributeValue("OldMemberName",bo.getAttribute("MemberName").getString());
				bo1.setAttributeValue("OldParentRelationType",bo.getAttribute("ParentRelationType").getString());
				bo1.setAttributeValue("OldShareValue",bo.getAttribute("ShareValue").getDouble());
				bo1.setAttributeValue("OldReasonType",bo.getAttribute("ReasonType").getString());
				bo1.setAttributeValue("OldMemberType",bo.getAttribute("MemberType").getString());
				*/
				tx.join(m1);
				m1.saveObject(bo1);
				//有子节点才对复制前后成员编号进行保存
				if(!bLeafOrNot){
					sParentMemberIDs[j][0]=bo.getAttribute("MemberID").getString();//外部信息中该节点成员编号
					sParentMemberIDs[j][1]=bo1.getAttribute("MemberID").getString();//拷贝后系统信息中该节点成员编号
					j++;
				}
			}else{
				//存储母公司成员编号
				sParentMemberIDs[0][0]=bo.getAttribute("MemberID").getString();
			}
		}
		
		//拷贝完成后,对拷贝得到的系统信息树图节点的父节点成员编号ParentMemberID进行替换
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
		//对以母公司为父节点的成员的父节点编号进行单独处理
		String sNewKeyMemberID="";//系统信息中母公司成员ID
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
			//待完善
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
	 * 校验该成员节点是否为叶节点(即没有子节点),是返回true,否则返回false
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
		if(bo!=null){//能查询到以该成员编号为父成员编号的集团成员
			return false;
		}
		return true;
	}
	
	/**
	 * 重建家谱
	 * 1.初始化家谱表      
	 * 2.初始化家谱版本表
	 * 3.更新集团客户信息中正在使用家谱版本、正在维护家谱版本、家谱版本状态字段
	 * @return 
	 */
	public String recreateFamily(JBOTransaction tx) throws Exception {
		ASUserObject curUser=ASUserObject.getUser(userID);
		//当前正在使用的家谱版本编号
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
			//获取正在使用的家谱版本信息
			m = f.getManager("jbo.app.GROUP_INFO");
			q = m.createQuery("GroupID=:GroupID");
			q.setParameter("GroupID",groupID);
			bo = q.getSingleResult();
			if(bo != null){
				sCurrentVersionSeq=bo.getAttribute("CurrentVersionSeq").getString();
				if(sCurrentVersionSeq==null) sCurrentVersionSeq="";
				//初始化家谱表GROUP_FAMILY_MEMBER(母公司)
				bo1=m1.newObject();
				bo1.getAttribute("GroupID").setValue(groupID);
				bo1.getAttribute("VersionSeq").setValue(sVersionSeq);
				bo1.setAttributeValue("ReviseFlag","CHECKED");
				bo1.getAttribute("MemberName").setValue(bo.getAttribute("GroupName").getString());//集团客户名称=集团母公司客户名称
				bo1.getAttribute("MemberCustomerID").setValue(groupID.substring(1));//集团客户编号="G"+集团母公司客户编号
				bo1.getAttribute("MemberType").setValue("01");//母公司
				bo1.getAttribute("ParentMemberID").setValue("None");//母公司父成员编号设为None
				bo1.getAttribute("MemberCertType").setValue("Ent01");//集团母公司必须是以组织机构代码建立客户的公司客户
				bo1.getAttribute("MemberCertID").setValue(bo.getAttribute("GroupCorpID").getString());
				bo1.getAttribute("MemberCorpID").setValue(bo.getAttribute("GroupCorpID").getString());
				bo1.getAttribute("InfoSource").setValue("S");//消息来源:系统内部
				bo1.getAttribute("InputUserID").setValue(ASUserObject.getUser(userID).getUserID());
				bo1.getAttribute("InputOrgID").setValue(ASUserObject.getUser(userID).getOrgID());
				bo1.getAttribute("InputDate").setValue(StringFunction.getToday());
				bo1.getAttribute("UpdateDate").setValue(StringFunction.getToday());
				tx.join(m1);
				m1.saveObject(bo1);
			}
			//初始化家谱版本表(GROUP_FAMILY_VERSION)
			bo1=m2.newObject();
			bo1.setAttributeValue("GroupID",groupID);
			bo1.setAttributeValue("VersionSeq",sVersionSeq);
			bo1.setAttributeValue("InfoSource","S");
			bo1.setAttributeValue("EffectiveStatus","0");//草稿
			bo1.setAttributeValue("RefVersionSeq",sCurrentVersionSeq);//将当前正在使用的家谱版本编号更新为重建的家谱上一家谱版本编号
			bo1.setAttributeValue("InputDate",sToday);
			bo1.setAttributeValue("UpdateDate",sToday);
			bo1.setAttributeValue("InputUserID",curUser.getUserID());
			bo1.setAttributeValue("InputOrgID",curUser.getOrgID());
			tx.join(m2);
			m2.saveObject(bo1);
			//更新集团客户信息中正在维护家谱版本、家谱版本状态字段
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
	 * 获取当前日期的日期字符串,格式为YYYYmmdd
	 * @return 当前日期的日期字符串
	 */
	public String getTodayString(){
		String sToday=DateX.format(new java.util.Date(), "yyyy/MM/dd");
		String sTodayString=sToday.substring(0,4)+sToday.substring(5,7)+sToday.substring(8);
		
		return sTodayString;
	}
}
