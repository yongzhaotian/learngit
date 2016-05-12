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
 * @describe 集团客户对象管理类
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
	 * 根据客户编号获取集团客户轻型实例
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
	 * 装载集团客户管理信息
	 * @param groupCustomer
	 * @return
	 */
	protected GroupCustomer loadGroupCustomerModelInfo(GroupCustomer groupCustomer){
		//装载客户管理信息
		Customer customer=loadCustomerModelInfo(groupCustomer);
		if(customer instanceof GroupCustomer){
			groupCustomer=(GroupCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户管理信息出错!");
		}
		//销毁customer实例
		customer=null;
		return groupCustomer;
	}
	
	/**
	 * 装载集团客户管理信息的具体方法
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
			ARE.getLog().error("适用于CUSTOMER_MODEL.CUSTOMERTYPE=["+this.getCustomerType()+"]的客户管理模型未定义,请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return customer;
	}
	
	/**
	 * 装载集团客户业务信息
	 * @param groupCustomer
	 * @return groupCustomer
	 */
	public GroupCustomer loadCustomerInfo(GroupCustomer groupCustomer){
		//装载客户总表(jbo.app.CUSTOMER_INFO)中客户基本信息
		Customer customer=super.loadCustomerInfo(groupCustomer);
		if(customer instanceof GroupCustomer){
			groupCustomer=(GroupCustomer)customer;
		}else{
			ARE.getLog().warn("装载客户基本信息出错!");
		}
		//销毁customer实例
		customer=null;
		//装载公司客户表(jbo.app.ENT_INFO)中客户基本信息
		try {
			BizObject boGroupInfo=getGroupInfoByCustomerID(groupCustomer.getCustomerID());
			if(boGroupInfo!=null){
				ObjectHelper.fillObjectFromJBO(groupCustomer, boGroupInfo);
			}else{
				ARE.getLog().error("客户未找到,GROUP_INFO.GROUPID=[:"+groupCustomer.getCustomerID()+"],请确认!");
			}
		} catch (JBOException e) {
			e.printStackTrace();
		}
		return groupCustomer;
	}
	
	/**
	 * 装载集团客户对象（客户业务信息和客户管理信息）
	 * @param groupCustomer
	 * @return	groupCustomer
	 */
	private GroupCustomer loadGroupCustomer(GroupCustomer groupCustomer){
		groupCustomer = loadCustomerInfo(groupCustomer);
		groupCustomer = loadGroupCustomerModelInfo(groupCustomer);
		return groupCustomer;
	}
	
	/**
	 * 通过客户编号获取集团客户JBO对象
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
		
		//------检查集团母公司是否是其他集团的成员企业-------
		sCheckReturn = checker.groupMemberExist();
		if(sCheckReturn.equals("EXIST")){
			return "一个集团的成员企业，不能作为集团的母公司来建立新集团！";
		}else if(sCheckReturn.equals("ERROR")){
			return "检验企业客户是否为其他集团客户的成员企业时出错！";
		}
		
		//--------检查新组建集团是否已经存在----------------
		sCheckReturn = checker.groupExist();
		if(sCheckReturn.equals("ERROR")){
			return "检查新组建的集团客户是否已经存在出错！";
		}else if(sCheckReturn.startsWith("EXIT")){
			String sReturn[] = sCheckReturn.split("@");
			return "集团客户已经存在！\n\n集团名称："+sReturn[1]+"\n集团类型："+sReturn[2]+"\n主办机构："+sReturn[3]+"\n主办客户经理："+sReturn[4];
		}
		
		sReturnInfo = addGroupCustomerAction(groupCustomer,tx);
		return sReturnInfo;
	}
	
	/**
	 * 新增集团客户具体操作
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
	 * 初始化集团客户信息表 GROUP_INFO
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeGroupInfo(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		String sCustomerName = groupCustomer.getGroupName(); //母公司客户名称
		String groupAbbName = sCustomerName.length()>10 ? sCustomerName.substring(0,10) : sCustomerName;  //集团客户简称， 考虑中文
		
		String versionSeq = "S" + StringFunction.getToday("");  //初始化家谱版本号
		
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		BizObject bo = m.newObject();
		bo.setAttributeValue("GroupID", groupCustomer.getGroupID());
		bo.setAttributeValue("GroupName", sCustomerName);
		bo.setAttributeValue("GroupAbbName", groupAbbName);
		bo.setAttributeValue("GroupType1", groupCustomer.getGroupType1());    //集团客户类型
		bo.setAttributeValue("KeyMemberCustomerID", groupCustomer.getKeyMemberCustomerID());  			//母公司客户ID
		bo.setAttributeValue("RefVersionSeq", versionSeq);     				//正在维护的家谱版本号
		bo.setAttributeValue("CurrentVersionSeq", versionSeq); 					//当前家谱版本号
		bo.setAttributeValue("FamilyMapStatus", "0");          					//家谱版本为草稿
		bo.setAttributeValue("GroupCorpID", groupCustomer.getGroupCorpID()); 	//集团客户组织机构代码
		bo.setAttributeValue("InputUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID",groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate",groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate",groupCustomer.getUpdateDate());
		
		tx.join(m);
		m.saveObject(bo);
	}
	
	/**
	 * 初始化集团家谱版本表
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeFamilyVersion(GroupCustomer groupCustomer,JBOTransaction tx) throws JBOException{
		String versionSeq = "S" + StringFunction.getToday("");  //初始化家谱版本号
		//--------------------初始化家谱版本表----------------
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_VERSION");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("GroupID",groupCustomer.getGroupID());
		bo.setAttributeValue("VersionSeq",versionSeq);
		bo.setAttributeValue("InfoSource","S");//消息来源:系统内部
		bo.setAttributeValue("EffectiveStatus","0");//生效标志为草稿
		bo.setAttributeValue("ApproveUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputUserID",groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID",groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate",groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate",groupCustomer.getUpdateDate());

		tx.join(bm);
		bm.saveObject(bo);
	}
	
	/**
	 * 初始化集团家谱成员表
	 * @param groupCustomer
	 * @param tx
	 * @throws JBOException
	 */
	protected static void initializeFamilyMember(GroupCustomer groupCustomer, JBOTransaction tx) throws JBOException{
		String versionSeq = "S" + StringFunction.getToday("");  //初始化家谱版本号
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_FAMILY_MEMBER");
		BizObject bo = bm.newObject();
		
		bo.setAttributeValue("GroupID", groupCustomer.getGroupID());
		bo.setAttributeValue("VersionSeq", versionSeq);
		bo.setAttributeValue("MemberName", groupCustomer.getGroupName()); //集团客户名称=集团母公司客户名称
		bo.setAttributeValue("MemberCustomerID", groupCustomer.getKeyMemberCustomerID());			//客户编号本身
		bo.setAttributeValue("ParentMemberID", "None");					//母公司父成员编号设为None
		bo.setAttributeValue("MemberType", "01");						//母公司
		bo.setAttributeValue("MemberCertType", "Ent01");				//集团母公司必须是以组织机构代码建立客户的公司客户
		bo.setAttributeValue("MemberCertID", groupCustomer.getGroupCorpID());
		bo.setAttributeValue("MemberCorpID", groupCustomer.getGroupCorpID());
		bo.setAttributeValue("ReviseFlag", "CHECKED");
		bo.setAttributeValue("InfoSource", "S");						//消息来源:系统内部
		bo.setAttributeValue("InputUserID", groupCustomer.getInputUserID());
		bo.setAttributeValue("InputOrgID", groupCustomer.getInputOrgID());
		bo.setAttributeValue("InputDate", groupCustomer.getInputDate());
		bo.setAttributeValue("UpdateDate", groupCustomer.getUpdateDate());
		
		tx.join(bm);
		bm.saveObject(bo);
	}
	/**
	 * 新增集团客户概况信息(CUSTOMER_INFO)
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
	 * 根据客户编号获取客户名称
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
	 * 加入总行管理名单
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
	 * 根据客户编号获取客户名称
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
	 * 判断该客户是否已属于集团
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
		   //排除当前所在集团  
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
			   //将当前所在现在所属集团排除掉，在概况页面保存时会再次校验客户是否属于集团
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
	 * 检查核心企业是否为其他集团的成员
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
				sReturn="已选择核心企业属于["+sName+"]的成员，不能作为核心企业了";
			}
		}
		return sReturn;
	}
	/**
	 * 检查集团下成员，查看那该成员是否在其他集团中已经存在 @
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
					sReturn+="成员["+sName+"]已属于集团["+sName2+"]\n";
				}
			}
			
		} 
		if(sReturn.equals("")) {
			sReturn="true";
		}else{
			sReturn="不能进行提交复核，请注意以下问题:\n"+sReturn;
		}
		return sReturn;
		
	}
}
