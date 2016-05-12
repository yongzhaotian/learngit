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
	 * 验证集团名称是否重复（新增）
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
	 * 验证集团名称是否重复（修改集团详情）
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
	 * 查看集团是否有在途申请
	 * @return
	 */
	public String checkOnLineApply() throws Exception
	{
		BizObjectManager m = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
		BizObjectQuery q = m.createQuery("select SerialNo from o where   o.CustomerID =:CustomerID" +
				" and   o.BusinessType = '3020'"+
				" and exists (select 1 from jbo.app.FLOW_OBJECT FO where FO.ObjectNo=o.SerialNo" +
				" and FO.ApplyType =o.ApplyType and  FO.PhaseType  in ('1010','1020'))");// 未审批通过额申请
		q.setParameter("CustomerID",GroupID);
		if(q.getTotalCount()>0) return "ReadOnly";
		return "All"; 
	}
	
	/**
	 * 校验集团客户是否存在已生效版本
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
	 * 判断是否满足删除联保体的条件
	 * @throws Exception 
	 * */
	public String checkBeforeDeleteGroup() throws Exception{
		String sReturn = "";
		if("ReadOnly".equals(checkOnLineApply())||"ISEXIST".equals(getApproveInfo())
				||"ISEXIST".equals(getContractInfo())){
			sReturn = "该集团客户存在授信额度业务信息，不能删除！";
		}else{
			sReturn = "IsNotExist";
		}
		return sReturn;
	}
	
	//获取审批信息
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
	
	//获取合同信息
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
	 * 检查核心企业是否为其他集团的成员
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
				 //核心企业对应的集团客户
				bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
				bo = bm.createQuery("GroupID=:GroupID").setParameter("GroupID",snowGroupID).getSingleResult(false);
				sGroupCustomerName = bo.getAttribute("GROUPNAME").getString();
				sReturn="已选择核心企业属于["+sGroupCustomerName+"]的成员，不能再作为其他集团的核心企业";
			}
		}
		return sReturn;
		
	}
	
	/**
	 * 检查集团客户是否已通过复核,通过复核则不可以更改核心企业
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
	 * 判断该客户是否已属于集团
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
				String sGroupMemberName = bo.getAttribute("MemberName").getString();//成员名称
				 //成员对应的集团客户
				bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
				BizObject boGroupInfo = bm.createQuery("GroupID=:GroupID").setParameter("GroupID",existGroupID).getSingleResult(false);
				sGroupCustomerName = boGroupInfo.getAttribute("GROUPNAME").getString();
				sReturn="["+sGroupMemberName+"]"+"已属于集团["+sGroupCustomerName+"]，不能再作为其他集团的成员";
			}else{
				String sGroupMemberName = bo.getAttribute("MemberName").getString();//成员名称
				sReturn="["+sGroupMemberName+"]"+"已属于当前集团，不能重复添加";
			}
		}
		return sReturn;
	}
	
	/**
	 * 新增客户之前删除隐藏的集团成员
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
	 * 检查集团下成员，查看该成员是否在其他集团中已经存在 @
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
					
					sReturn+="成员["+sGroupMemberName+"]已属于集团["+sGroupCustomerName+"]\n";
				}
			}
			
		} 
		if(sReturn.equals("")) {
			sReturn="true";
		}else{
			sReturn="不能进行提交复核，请注意以下问题：\n"+sReturn;
		}
		return sReturn;
		
	}
	
	
	/**
	 * 根据客户编号获取客户名称
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
	 * 			<p>CustomerID: 客户编号
	 * @return 在途授信额度业务信息
	 * @throws Exception
	 */
	public String getBusinessMessage(JBOTransaction tx) throws Exception {
		String sReturn = "NO";
		// 申请条数、批复条数、已授信条数、授信业务总条数
		String Result = "",Result1 = "",Result2 = "",Result3 = "";
		
		// 在途的集团授信额度申请
		BizObject bo1 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY").createQuery("CustomerID=:CustomerID and (PigeonholeDate is null)").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo1 != null){
		Result1 =	bo1.getAttribute("SERIALNO").getString();// 未通过审批或未归档的申请数
		}else{
			Result1 = "";	
		}
		
		// 在有效期内的授信批复
		BizObject bo2 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE").createQuery("CustomerID=:CustomerID and (PigeonholeDate is null)").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo2 != null){
		Result2 =	bo2.getAttribute("SERIALNO").getString();// 待签合同或未归档的审批数
		}else{
			Result2 = "";	
		}

		// 在有效期内的授信额度
		BizObject bo3 = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT").createQuery("CustomerID=:CustomerID").setParameter("CustomerID",GroupID).getSingleResult();
		if(bo3 != null){
		Result3 =	bo3.getAttribute("SERIALNO").getString();	// 未归档的合同数
		}else{
			Result3 = "";	
		}
		
		Result = Result1 + Result2 + Result3;
		if(!Result.equals("")){
			sReturn = "该集团客户";
			if(!Result1.equals("")){
				sReturn += "有在途的集团授信额度申请，";
			}
			if(!Result2.equals("")){
				sReturn += "有在有效期内的授信额度批复，";
			}
			if(!Result3.equals("")){
				sReturn += "有在有效期内的授信额度，";
			}
			sReturn += "不能执行此操作！";
		}else{
			sReturn = "NO";
		}

		return sReturn;
	}
	
	/**
	 * 加入总行管理名单
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
				bo.setAttributeValue("ChangeContext", "由 非总行管理名单 变更为 是总行管理名单");
				m.saveObject(bo);
				sReturn = "Success";
			} catch (JBOException e) {
				e.printStackTrace();
				sReturn = "Faile";
			}			   
		   return sReturn;
	}
	
	/**
	 * @param 参数说明<br/>
	 * 		CustomerID	:客户ID<br/>
	 * 		UserID		:用户ID
	 * @return 返回值说明
	 * 		<p>主办权@信息查看权@信息维护权@业务申办权</p>
	 * 		<li>主办权值域　　：Y/N</li>
	 * 		<li>信息查看权值域：Y1/N1</li>
	 * 		<li>信息维护权值域：Y2/N2</li>
	 * 		<li>敞口业务申办权值域：Y3/N3</li>
	 * 		<li>低风险业务申办权值域：Y3/N3</li>
	 */
	/*
	public String checkRolesAction() throws Exception {
		String sReturnValue = "";		//主办权标志   
	    String sReturnValue1 = "";		//信息查看权标志
	    String sReturnValue2 = "";		//信息维护权标志
	    String sReturnValue3 = "";		//敞口业务申办权标志
	    String sReturnValue4 = "";		//低风险业务申办权标志
	    
	    String sBelongAttribute = "";	//客户主办权    
	    String sBelongAttribute1 = "";	//信息查看权
	    String sBelongAttribute2 = "";	//信息维护权
	    String sBelongAttribute3 = "";	//敞口业务申办权    
	    String sBelongAttribute4 = "";	//低风险业务申办权    
		   
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
	    
		//如果有客户主办权返回Y，否则返回N	
	    if(sBelongAttribute.equals("1")){
	        sReturnValue = "Y";
	    }else{ 
	    	sReturnValue = "N";
	    }
	        
	    //如果有信息查看权返回Y1，否则返回N1	
	    if(sBelongAttribute1.equals("1")){
	        sReturnValue1 = "Y1";
	    }else{ 
	    	sReturnValue1 = "N1";
	    }
	    
	    //如果有信息维护权返回Y2，否则返回N2	
	    if(sBelongAttribute2.equals("1")){
	        sReturnValue2 = "Y2";
	    }else{ 
	    	sReturnValue2 = "N2";
	    }
	    
	    //如果有敞口业务申办权返回Y3，否则返回N3	
	    if(sBelongAttribute3.equals("1")){
	        sReturnValue3 = "Y3";
	    }else{ 
	    	sReturnValue3 = "N3";
	    }
	    //如果有低风险业务申办权返回Y4，否则返回N4	
	    if(sBelongAttribute4.equals("1")){
	        sReturnValue4 = "Y4";
	    }else{ 
	    	sReturnValue4 = "N4";
	    }
		return sReturnValue+"@"+sReturnValue1+"@"+sReturnValue2+"@"+sReturnValue3+"@"+sReturnValue4;
	}
	*/
	/**
	 * 删除集团客户时删除相关信息
	 * @InputParam
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public String deleteGroupCustomer(JBOTransaction tx) throws Exception  {  
		//-----------------------------更新ENT_INFO和CUSTOMER_INFO,删除集团客户相关关联表-----------------
	    JBOFactory f = JBOFactory.getFactory();
		BizObjectManager m = null;
		BizObjectQuery q = null;
		BizObject bo = null;
		String sSql;
		
		//更新ENT_INFO
		m = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		q = m.createQuery("GroupID=:GroupID").setParameter("GroupID",GroupID);
		List<BizObject> memberList = q.getResultList();
		for(int i = 0;i<memberList.size();i++){
			BizObject tempBo = memberList.get(i);
			GroupCustomer group = new GroupCustomer();
			group.setKeyMemberCustomerID(tempBo.getAttribute("MEMBERCUSTOMERID").getString());
			OperCustomer.updateEntCustomer("0", group, tx);
		}
		
		//更新CUSTOMER_INFO
		m = f.getManager("jbo.app.CUSTOMER_INFO");
		tx.join(m);
		q = m.createQuery("update O set BelongGroupID=:BelongGroupID where BelongGroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.setParameter("BelongGroupID","");
		q.executeUpdate();
		
		// 删除对应的集团家谱成员信息GROUP_FAMILY_MEMBER
		m = f.getManager("jbo.app.GROUP_FAMILY_MEMBER");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		/*
		//删除对应的集团客户风险报告GROUP_RISKREPORT
		m = f.getManager("jbo.app.GROUP_RISKREPORT");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
	    */
		
		// 删除对应的集团客户家谱复核意见GROUP_FAMILY_OPINION
		m = f.getManager("jbo.app.GROUP_FAMILY_OPINION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		// 删除对应的集团客户家谱版本信息GROUP_FAMILY_VERSION
		m = f.getManager("jbo.app.GROUP_FAMILY_VERSION");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		
		// 删除对应的集团客户当前家谱信息GROUP_MEMBER_RELATIVE add by bcpu 
		m = f.getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		/*
		// 删除对应的集团客户事件信息GROUP_EVENT
		m = f.getManager("jbo.app.GROUP_EVENT");
		tx.join(m);
		q = m.createQuery("delete from O where GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		q.executeUpdate();
		*/
		//删除时在对应的集团客户事件信息表GROUP_EVENT添加记录
		insertGroupEvent(tx,GroupName);

		// 删除集团客户GROUP_INFO
		m = f.getManager("jbo.app.GROUP_INFO");
		tx.join(m);
		q = m.createQuery("GroupID=:GroupID");
		q.setParameter("GroupID",GroupID);
		bo = q.getSingleResult();
		if(bo != null){
			m.deleteObject(bo);
		}
		
		// 删除客户归属表CUSTOMER_BELONG
		m = f.getManager("jbo.app.CUSTOMER_BELONG");
		tx.join(m);
		q = m.createQuery("delete from O where CustomerID=:CustomerID");
		q.setParameter("CustomerID",GroupID);
		q.executeUpdate();
		
		//删除客户总表
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
	 * 插入数据至GROUP_EVENT
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
		bo.setAttributeValue("ChangeContext", "删除"+GroupName+"集团");
		m.saveObject(bo);
	}
	
	/**
	 * 验证核心企业是否改动
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
	 * 判断该客户是否已属于集团
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