package com.amarsoft.app.als.customer.common.action;

import java.util.List;

import com.amarsoft.app.als.bizobject.customer.DefaultCustomerManagerFactory;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

/**
 * 客户管理模块 页面Sql处理通用类
 * @author qchen 2011-5-18
 *
 */
public class GetCustomer {
	private String customerID;
	private String relativeID;
	private String relationShip;
	private String serialNo;	//Customer_Relative流水号 
	private String keyManID;	//关联高管编号

	public String getRelativeID() {
		return relativeID;
	}

	public void setRelativeID(String relativeID) {
		this.relativeID = relativeID;
	}

	public String getRelationShip() {
		return relationShip;
	}

	public void setRelationShip(String relationShip) {
		this.relationShip = relationShip;
	}

	public String getCustomerID() {
		return customerID;
	}

	public void setCustomerID(String customerID) {
		this.customerID = customerID;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	

	public void setKeyManID(String keyManID) {
		this.keyManID = keyManID;
	}

	public String getKeyManID() {
		return keyManID;
	}
	

	/**
	 * 获得企业规模信息
	 * @param sCustomerID
	 * @return
	 * @throws JBOException
	 */
	public static String getCustomerScope(String sCustomerID) throws Exception{
		String sScope = ""; //客户机构类型
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo!=null){
			sScope = bo.getAttribute("Scope").getString();
		}else{
			throw new Exception("未找到该客户,ENT_INFO.CustomerID=["+sCustomerID+"]");
		}
		return sScope;
	}
	/**
	 * 取客户名称
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public static String getCustomerName(String sCustomerID) throws Exception{
		String customerName = ""; //客户名称
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo!=null){
			customerName = bo.getAttribute("CustomerName").getString();
		}else{
			customerName=sCustomerID;
			ARE.getLog().warn("未找到该客户,CUSTOMER_INFO.CustomerID=["+sCustomerID+"]");
		}
		return customerName;
	}
	
	/**
	 * 根据流程任务表流水号判断是否显示企业规模人行测算按钮Attribute5
	 * @param sTaskNo	流程任务表流水号
	 * @return	sAttribute 是否显示企业规模人行测算按钮 控制位
	 * @throws Exception
	 */
	public static String getAllowFlowModelButtonIsShow(String sObjectNo,String sObjectType) throws Exception{
		String sAttribute = "";	//控制位
		String sFlowNo = "";	//流程编号
		String sPhaseNo = "";	//流程阶段编号
		BizObjectManager taskbom = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		BizObject taskbo = taskbom.createQuery("select FlowNo,PhaseNo from o where ObjectNo=:ObjectNo and ObjectType=:ObjectType and (PhaseAction is null or PhaseAction=' ') and (EndTime is null or EndTime =' ')")
							.setParameter("ObjectNo", sObjectNo).setParameter("ObjectType",sObjectType).getSingleResult(false);
		if(taskbo==null){
			ARE.getLog().warn("未找到FLOW_TASK.ObjectNo=["+sObjectNo+"],ObjectType=["+sObjectType+"]的未完成记录");
			return "";
		}else{
			sFlowNo = taskbo.getAttribute("FlowNo").getString();
			sPhaseNo = taskbo.getAttribute("PhaseNo").getString();
		}
		
		BizObjectManager modelbom = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		BizObject modelbo = modelbom.createQuery("select Attribute5 from o where FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo).getSingleResult(false);
		if(modelbo!=null){
			sAttribute = modelbo.getAttribute("Attribute5").getString();
		}
		return sAttribute;
	}
	
	/**
	 * 根据流程编号和流程阶段号获取仅查看自己签署的意见所对应的阶段
	 * @param sFlowNo 流程编号
	 * @param sPhaseNo	流程阶段号
	 * @return sAttribute 自己签署意见所对应的阶段
	 * @throws Exception
	 */
	public static String getAllowFlowSelfOpinionPhase(String sFlowNo,String sPhaseNo) throws Exception{
		String sAttribute = ""; //自己签署意见所对应的阶段
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		BizObject bo = bom.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到FLOW_MODEL.FlowNo=["+sFlowNo+"],PhaseNo=["+sPhaseNo+"]的记录。");
		}else{
			if(!(bo.getAttribute("Attribute6").isNull())){
				sAttribute = bo.getAttribute("Attribute6").getString();
			}
		}
		return sAttribute;
	}
	
	/**
	 * 根据客户编号返回相关客户信息
	 * @param sCustomerID 客户编号
	 * @return sCertType@sCertID@sCustomerName 证件类型@证件号@客户名称
	 * @throws Exception
	 */
	public static String getCustomerCertAndName(String sCustomerID) throws Exception{
		String sCertType = "";	//证件类型
		String sCertID = "";	//证件编号
		String sCustomerName = "";	//客户名称
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到CUSTOMER_INFO.CustomerID=["+sCustomerID+"]的记录");
		}else{
			sCertType = bo.getAttribute("CertType").getString();
			sCertID = bo.getAttribute("CertID").getString();
			sCustomerName = bo.getAttribute("CustomerName").getString();
		}
		return sCertType+"@"+sCertID+"@"+sCustomerName;
	}
	
	/**
	 * 根据客户编号获取客户类型
	 * @param sCustomerID	客户编号
	 * @return sCustomerType 客户类型
	 * @throws Exception
	 */
	public static String getCustomerType(String sCustomerID) throws Exception{
		String sCustomerType = ""; //客户类型
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到CUSTOMER_INFO.CustomerID=["+sCustomerID+"]的记录");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").getString();
		}
		return sCustomerType;
	}
	
	/**
	 * 根据评估模型类型获取模型类型属性
	 * @param sModelType	评估模型类型
	 * @return sModelTypeAttribute 模型类型属性
	 * @throws Exception
	 */
	public static String getModelTypeAttribute(String sModelType) throws Exception{
		String sModelTypeAttribute = ""; //模型类型属性
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObject bo = bom.createQuery("CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo", sModelType).getSingleResult(false);
		if(bo==null){
			throw new Exception("模型类型 ["+sModelType+"] 没有定义。请查看CODE_LIBRARY:EvaluateModelType");
		}else{
			sModelTypeAttribute = bo.getAttribute("RelativeCode").getString();
		}
		return sModelTypeAttribute;
	}
	
	/**
	 * 根据客户编号获取客户类型，客户证件，客户规模
	 * @param sCustomerID 客户编号
	 * @return 客户类型@客户证件类型@证件编号@客户规模
	 * @throws Exception
	 */
	public static String getCustomerTypeAndCert(String sCustomerID) throws Exception{
		String sCustomerType = "";	//客户类型
		String sCertType = "";	//证件类型
		String sCertID = "";	//证件编号
		String sCustomerScale = "";	//客户规模
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到CUSTOMER_INFO.CustomerID=["+sCustomerID+"]的记录");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").isNull() ? "" : bo.getAttribute("CustomerType").getString();
			sCertType = bo.getAttribute("CertType").isNull() ? "" : bo.getAttribute("CertType").getString();
			sCertID = bo.getAttribute("CertID").isNull() ? "" : bo.getAttribute("CertID").getString();
			sCustomerScale = bo.getAttribute("CustomerScale").isNull() ? "" : bo.getAttribute("CustomerScale").getString();
		}
		return sCustomerType+"@"+sCertType+"@"+sCertID+"@"+sCustomerScale;
	}
	
	/**
	 * 根据个人客户编号获取客户婚姻情况
	 * @param sCustomerID 客户编号
	 * @return sMarriage 婚姻情况
	 * @throws Exception
	 */
	public static String getCustomerMarriage(String sCustomerID) throws Exception{
		String sMarriage = "";	//婚姻情况
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到CUSTOMER_INFO.CustomerID=["+sCustomerID+"]的记录");
		}else{
			sMarriage = bo.getAttribute("Marriage").getString();
		}
		return sMarriage;
	}
	
	/**
	 * 获取客户准入当前流程阶段意见和阶段信息
	 * @param sUserID	当前用户名
	 * @param sObjectNo	流程对象编号
	 * @param sObjectType	流程对象类型
	 * @param sFlowNo	流程编号
	 * @param sPhaseNo	流程阶段编号
	 * @return	bo 当前流程阶段意见和阶段信息对象
	 * @throws JBOException
	 */
	public static BizObject getAllowOpinionObject(String sUserID,String sObjectNo,String sObjectType,String sFlowNo,String sPhaseNo) throws JBOException{
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		BizObject bo = bom.createQuery("select PhaseOpinion,FT.PhaseName,FT.UserName,FT.OrgName,FT.BeginTime,FT.EndTime " +
										"from jbo.app.FLOW_TASK FT,O where FT.Serialno=SerialNo and (PhaseOpinion is not null) and InputUser=:InputUser " +
										"and FT.ObjectNo=:ObjectNo and FT.ObjectType=:ObjectType and FT.FlowNo=:FlowNo and FT.PhaseNo=:PhaseNo")
										.setParameter("InputUser",sUserID).setParameter("ObjectNo", sObjectNo).setParameter("ObjectType",sObjectType)
										.setParameter("FlowNo",sFlowNo).setParameter("PhaseNo", sPhaseNo).getSingleResult();
		return bo;
	}
	
	
	/**
	 * 获取家谱版本意见查询结果集
	 * @param Sqlca
	 * @param sGroupID	集团编号
	 * @param sFamilySeq	家谱版本
	 * @return 查询结果集
	 * @throws Exception
	 */
	public static List getFamilyVersionOpinion(String sGroupID,String sFamilySeq) throws Exception{
		String sSql = 	"select ApproveUserID,ApproveUserName,Opinion,ApproveType,ApproveTime,fv.SubmitTime "+
						" from O,jbo.app.GROUP_FAMILY_VERSION fv "+
						" where GroupID = fv.GroupID "+
						" and FamilySEQ = fv.VersionSEQ "+
						" and GroupID =:GroupID "+
						" and FamilySeq=:FamilySeq order by ApproveTime ";
		BizObjectQuery bq = JBOFactory.getFactory().getManager("jbo.app.GROUP_STEMMA_OPINION").createQuery(sSql);
		bq.setParameter("GroupID", sGroupID);
		bq.setParameter("FamilySeq", sFamilySeq);
		List list=bq.getResultList();
		return list;
	}
	
	/**
	 * 获取当前机构具有当前客户信息查看权和维护权的记录
	 * @param Sqlca
	 * @param sCustomerID	客户编号
	 * @param sUserID	当前用户编号
	 * @return	信息查看权或者维护权记录数
	 * @throws Exception
	 */
	public static int getBelongCustomerCounts(Transaction Sqlca,String sCustomerID,String sUserID) throws Exception{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObjectQuery bq = null;
		ASUser CurUser = ASUser.getUser(sUserID, Sqlca);	//当前用户对象
		//-------------客户经理岗位（总行/分行/支行）的人员：从客户所属信息表中查询出本机构自己具有当前客户的信息查看权或信息维护权的记录数
		if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480")){
			bq = bm.createQuery("CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID and (BelongAttribute1='1' or BelongAttribute2='1')")
				.setParameter("CustomerID",sCustomerID).setParameter("OrgID",CurUser.getOrgID()).setParameter("UserID",sUserID);
			
		}else{ //-----------非客户经理岗位的人员：从客户所属信息表中查询出本机构及其下属机构具有当前客户的信息查看权或信息维护权的记录数
			bq = bm.createQuery("CustomerID=:CustomerID and OrgID in (Select OI.OrgID from jbo.sys.ORG_INFO OI where OI.SortNo like :SortNo) and (BelongAttribute1 ='1') or BelongAttribute2 = '1'")
				.setParameter("CustomerID",sCustomerID).setParameter("SortNo",CurUser.getOrgSortNo()+"%");
		}
		return  bq.getTotalCount();
	}
	
	/**
	 * 根据业务申请类型获取申请树图类型
	 * @param sApplyType	业务申请类型
	 * @return	sItemDescribe 申请树图类型
	 * @throws Exception
	 */
	public static String getApplyViewTreeNo(String sApplyType) throws Exception{
		String sItemDescribe = ""; //申请树图类型
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");		    
		BizObjectQuery	query = bm.createQuery("select ItemDescribe from o where CodeNo = 'ApplyType' and ItemNo =:ItemNo").setParameter("ItemNo",sApplyType);
		BizObject bizo = query.getSingleResult(false);
		if (bizo != null){   				    
			sItemDescribe=bizo.getAttribute("ItemDescribe").getString();
		}else{
			throw new Exception("没有找到相应的申请类型定义(CODE_LIBRARY.CodeNo:ApplyType and ItemNo:"+sApplyType+")!");
		}
		if(sItemDescribe == null) sItemDescribe = "";
		return sItemDescribe;
	}
	
	/**
	 * 根据业务审批类型获取审批树图类型
	 * @param sApproveType	业务审批类型
	 * @return	sItemDescribe 审批树图类型
	 * @throws Exception
	 */
	public static String getApproveViewTreeNo(String sApproveType) throws Exception{
		String sItemDescribe = ""; //申请树图类型
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");		    
		BizObjectQuery	query = bm.createQuery("select ItemDescribe from o where CodeNo = 'ApproveType' and ItemNo =:ItemNo").setParameter("ItemNo",sApproveType);
		BizObject bizo = query.getSingleResult(false);
		if (bizo != null){   				    
			sItemDescribe=bizo.getAttribute("ItemDescribe").getString();
		}else{
			throw new Exception("没有找到相应的申请类型定义(CODE_LIBRARY.CodeNo:ApproveType and ItemNo:"+sApproveType+")!");
		}
		if(sItemDescribe == null) sItemDescribe = "";
		return sItemDescribe;
	}
	
	/**
	 * 根据项目编号获取项目类型
	 * @param sProjectNo	项目编号
	 * @return sProjectType 项目类型
	 * @throws Exception
	 */
	public static String getProjectType(String sProjectNo) throws Exception{
		String sProjectType = ""; //项目类型
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.PROJECT_INFO");
		BizObject bo = bom.createQuery("ProjectNo=:ProjectNo").setParameter("ProjectNo",sProjectNo).getSingleResult(false);
		if (bo != null){   				    
			sProjectType = bo.getAttribute("ProjectType").getString();
		}else{
			throw new Exception("没有找到相应的申请类型定义(PROJECT_INFO.ProjectType:"+sProjectNo+")!");
		}
		if(sProjectType==null) sProjectType="";
		return sProjectType;
	}
	
	/**
	 * 根据客户编号获取客户证件编号
	 * @param sCustomerID 客户编号
	 * @return sCertID 证件编号
	 * @throws Exception
	 */
	public static String getCertID(String sCustomerID) throws Exception{
		String sCertID = ""; //证件编号
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
	    BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID);
	    BizObject bo = bq.getSingleResult(false);
	    if(bo!=null){
	    	sCertID = bo.getAttribute("CertID").getString();
	    }else{
	    	throw new Exception("没有找到相应的客户(CUSTOMER_INFO.CustomerID:"+sCustomerID+")!");
	    }
	    if(sCertID==null) sCertID = "";
	    return sCertID;
	}
	
	/**
	 * 查看用户是否有当前客户主办权
	 * @param sCustomerID	客户编号
	 * @param sUserID	用户编号
	 * @return	sRight	权限标志
	 * @throws Exception
	 */
	public static String getManageRight(String sCustomerID,String sUserID) throws Exception{
		String sRight = "";	//管理权限标志
		BizObject bo = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG").createQuery("CustomerID=:CustomerID and UserID=:UserID")
						.setParameter("CustomerID",sCustomerID).setParameter("UserID",sUserID).getSingleResult(false);
		if(bo!=null){
			sRight = bo.getAttribute("BelongAttribute").getString(); 
		}else{
			sRight = null; 
		}
		return sRight;
	}
	
	/**
	 * 根据客户编号获取客户类型和集团客户编号
	 * @param sCustomerID	客户编号
	 * @return sCustomerType 客户类型
	 * @throws Exception
	 */
	public static String getCustomerTypeAndGroupID(String sCustomerID) throws Exception{
		String sCustomerType = ""; //客户类型
		String sBelongGroupID = ""; //所属集团编号
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("未找到CUSTOMER_INFO.CustomerID=["+sCustomerID+"]的记录");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").getString();
			sBelongGroupID = bo.getAttribute("BelongGroupID").getString();
		}
		
		if(sCustomerType==null) sCustomerType="";
		if(sBelongGroupID==null) sBelongGroupID="";
		return sCustomerType+"@"+sBelongGroupID;
	}
	
	/** add by yrma 2011-9-23 13:08:50
	 * 根据批客户编号，获取客户基本信息
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getCustomerInfoParams(String sCustomerID) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * 判断当前用户是否有查看指定客户权限,有返回true,否则返回false
	 * @param sCustomerID
	 * @param CurUser
	 * @return
	 * @throws Exception 
	 */
	public static boolean checkUserRight(String sCustomerID,ASUser CurUser) throws Exception{
		boolean bFlag=true;//用户是否有对该客户的查看权限
		String sSql="";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObjectQuery bq=null;
		int iCount=0;
		//客户经理岗位（总行/分行/支行）的人员：从客户所属信息表中查询出本机构自己具有当前客户的信息查看权或信息维护权的记录数
		if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480"))
		{
			sSql = 	" CustomerID =:CustomerID "+
					" and OrgID =:OrgID "+
					" and UserID =:UserID "+
					" and (BelongAttribute1 = '1' "+
					" or BelongAttribute2 = '1')";
			bq=bm.createQuery(sSql);
			bq.setParameter("CustomerID",sCustomerID);
			bq.setParameter("OrgID",CurUser.getUserID());
			bq.setParameter("UserID",CurUser.getUserID());
			iCount=bq.getTotalCount();
		}else//非客户经理岗位的人员：从客户所属信息表中查询出本机构及其下属机构具有当前客户的信息查看权或信息维护权的记录数
		{	
			sSql = 	" CustomerID =:CustomerID "+
					" and OrgID in (select OI.orgid from jbo.sys.ORG_INFO OI where OI.sortno like:SortNo) "+
					" and (BelongAttribute1 = '1' "+
					" or BelongAttribute2 = '1')";
			bq=bm.createQuery(sSql);
			bq.setParameter("CustomerID",sCustomerID);
			bq.setParameter("SortNo",CurUser.getOrgSortNo()+"%");
			iCount=bq.getTotalCount();
		}
		if(CurUser.hasRole("043") || CurUser.hasRole("243")){//如果是集团客户管理岗,则不做权限控制
			iCount=1;
		}
		if(iCount<=0){
			bFlag=false;
		}
		return bFlag;
	}
	/*public static String[] getCustomerViewInfo(String sCustomerID) throws Exception{
		String[] strs = new String[3];
		String sCustomerType = "";//--客户类型	
		String sBelongGroupID = "";//所属集团客户ID
		String sTreeViewTemplet = "";//--存放custmerview页面树图的CodeNo
		//取得客户类型
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID");
		bq.setParameter("CustomerID",sCustomerID);
		BizObject boCustomerInfo=bq.getSingleResult();
		if(boCustomerInfo!=null){
			sCustomerType=boCustomerInfo.getAttribute("CustomerType").getString();
			sBelongGroupID=boCustomerInfo.getAttribute("BelongGroupID").getString();//如果是集团成员，则取得所属集团客户ID
		}else{
			throw new Exception("没有找到该客户,CUSTOMER_INFO.CustomerID=["+sCustomerID+"]");
		}
		if(sCustomerType == null) sCustomerType = "";
		if(sBelongGroupID == null) sBelongGroupID = "";
		//取得视图模板类型
		Item item=CodeManager.getItem("CustomerType",sCustomerType);
		sTreeViewTemplet=item.getItemDescribe().trim();//公司客户详情树图类型
		strs[0]=sCustomerType;
		strs[1]=sBelongGroupID;
		strs[2]=sTreeViewTemplet;
		return strs;
	}
	*/
	/**
	 * 获取客户当前评级模板
	 * @param sCustomerID	客户编号
	 * @return	sCreditBelong	评级模板
	 * @throws Exception
	 */
	public static String getEntCreditBelong(String sCustomerID) throws Exception{
		String sCreditBelong = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo!=null){
			//获取客户基本信息中的评级模板信息
			sCreditBelong = bo.getAttribute("CREDITBELONG").getString();
			if(sCreditBelong == null)sCreditBelong = "";
		}else{
			sCreditBelong = ""; 
		}
		return sCreditBelong;
	}
	
	/**
	 * 获取客户有效评价记录关联的评级模型号
	 * @param sCustomerID	客户编号
	 * @return	sCreditBelong	评价记录
	 * @throws Exception
	 */
	public static String getCusRating(String sCustomerID) throws Exception{
		String sRefModelID = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RATING");
		//StatusFlag，‘1’为有效，‘2’为无效
		//SaveFlag，‘1’为暂存，‘2’为保存
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID and StatusFlag = '1'").setParameter("CustomerID",sCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo!=null){
			sRefModelID = bo.getAttribute("RefModelID").getString();
			if(sRefModelID == null)sRefModelID = "";
		}else{
			sRefModelID = ""; 
		}
		return sRefModelID;
	}
	
	/**
	 * 根据合作方客户编号获取合作方客户模板
	 * @param sCustomerID
	 * @return
	 * @throws JBOException
	 */
	public static String getPartnerTempletNo(String sCustomerID) throws JBOException{
		String sPartnerTempletNo = "";
		BizObject partnerbo = JBOFactory.getFactory().getManager("jbo.app.PARTNER_CUSTOMER_INFO").createQuery("CustomerID=:CustomerID")
							.setParameter("CustomerID", sCustomerID).getSingleResult(false);
		
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObject bo = bom.createQuery("CodeNo='PartnerType' and ItemNo=:ItemNo")
						.setParameter("ItemNo",partnerbo.getAttribute("PartnerType").getString())
						.getSingleResult(false);
		sPartnerTempletNo = bo.getAttribute("ItemDescribe").getString();
		
		return sPartnerTempletNo;
	}
	
	/**
	 * 获取客户所属集团名称
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public static String getCustomerBelongGroup(String sCustomerID) throws Exception{
		String sGroupName = "无";
		
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		BizObject memberbo = bm.createQuery("MemberCustomerID=:MemberCustomerID and GroupCustomerType='0210'")
							   .setParameter("MemberCustomerID",sCustomerID).getSingleResult(false);
		if(memberbo!=null){
			//sGroupName = NameManager.getCustomerName(memberbo.getAttribute("GroupID").getString());
			sGroupName = memberbo.getAttribute("GroupID").getString();
		}
		return sGroupName;
	}
	
	/**
	 * 获取集团授信类型
	 * @param sGroupID
	 * @return
	 * @throws Exception
	 */
	public static String getGroupCreditType(String sGroupID) throws Exception{
		String sGroupCreditType = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_INFO");
		BizObject groupbo = bm.createQuery("GroupID=:GroupID").setParameter("GroupID", sGroupID).getSingleResult(false);
		if(groupbo!=null){
			sGroupCreditType = groupbo.getAttribute("GroupCreditType").getString();
		}
		return sGroupCreditType;
	}
	
	/**
	 * 获取公司客户客户类型
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public static String getOrgNatrue(String sCustomerID) throws Exception{
		String sOrgNature = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = bm.createQuery("select OrgNature from o where CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID).getSingleResult(false);
		if(bo!=null){
			sOrgNature = bo.getAttribute("OrgNature").getString();
		}
		return sOrgNature;
	}
	
	/**
	 * 获取法人代表证件号码
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public String getFictitiousPersonID() throws Exception{
		String sCertID = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = bm.createQuery("select FICTITIOUSPERSONID from o where CustomerID=:CustomerID").setParameter("CustomerID", customerID).getSingleResult(false);
		if(bo!=null){
			sCertID = bo.getAttribute("FICTITIOUSPERSONID").getString();
		}
		if(StringX.isEmpty(sCertID)){
			sCertID = "";
		}
		return sCertID;
	}
	
	/**
	 * 获取关键人学历
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public String getEduexperience() throws Exception{
		String sReturn = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject bo = bm.createQuery("select EDUEXPERIENCE from o where CustomerID=:CustomerID").setParameter("CustomerID", customerID).getSingleResult(false);
		if(bo!=null){
			sReturn = bo.getAttribute("EDUEXPERIENCE").getString();
		}
		if(StringX.isEmpty(sReturn)){
			sReturn = "";
		}
		return sReturn;
	}
	
	/**
	 * 录入企业高管信息时，检查信息重复录入
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public String checkUniqueEntFamily() throws Exception{
		String sReturn = "";
		if(StringX.isEmpty(serialNo)){
			serialNo = " ";
		}
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
		BizObject bo = null;
		
		if("0301".equals(relationShip)){
			bo = bm.createQuery("CustomerID=:CustomerID and RelationShip='0301' and Relative2ID=:Relative2ID and length(RelationShip)>2 AND SerialNo <> :SerialNo")
					.setParameter("CustomerID", customerID).setParameter("SerialNo", serialNo).setParameter("Relative2ID", keyManID)
					.getSingleResult(false);
		}else{
			bo = bm.createQuery("CustomerID=:CustomerID and RelativeID = :RelativeID and Relative2ID=:Relative2ID and RelationShip like '03%' and length(RelationShip)>2 AND SerialNo <> :SerialNo")
			.setParameter("CustomerID", customerID).setParameter("RelativeID", relativeID).setParameter("SerialNo", serialNo)
			.setParameter("Relative2ID", keyManID).getSingleResult(false);
		}
		if(bo!=null){
			sReturn = "Y";
		}
		return sReturn;
	}
	/**
	 * 录入企业关键人信息时，检查信息重复录入
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public String checkUniqueKeyman() throws Exception{
		String sReturn = "";
		if(StringX.isEmpty(serialNo)){
			serialNo = " ";
		}
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
		BizObject bo = bm.createQuery("CustomerID=:CustomerID AND RelativeID = :RelativeID and RelationShip = :relationShip and RelationShip like '01%' and length(RelationShip)>2 AND SerialNo <> :SerialNo")
		.setParameter("CustomerID", customerID).setParameter("RelativeID",relativeID).setParameter("RelationShip", relationShip)
		.setParameter("SerialNo", serialNo).getSingleResult(false);
		if(bo!=null){
			sReturn = "Y";
		}
		return sReturn;
	}
	
	/**
	 * 录入个人配偶或家庭主要成员信息时，检查信息重复录入
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public String checkUniqueIndFamily() throws Exception{
		String sReturn = "";
		if(StringX.isEmpty(serialNo)){
			serialNo = " ";
		}
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE");
		BizObject bo = null;
		
		if("0301".equals(relationShip)){
			bo = bm.createQuery("CustomerID=:CustomerID and RelationShip='0301' and length(RelationShip)>2 AND SerialNo <> :SerialNo")
					.setParameter("CustomerID", customerID).setParameter("SerialNo", serialNo).getSingleResult(false);
		}else{
			bo = bm.createQuery("CustomerID=:CustomerID and RelativeID = :RelativeID and RelationShip like '03%' and length(RelationShip)>2 AND SerialNo <> :SerialNo")
			.setParameter("CustomerID", customerID).setParameter("RelativeID", relativeID).setParameter("SerialNo", serialNo).getSingleResult(false);
		}
		if(bo!=null){
			sReturn = "Y";
		}
		return sReturn;
	}
	/**
	 * 获取贷款卡号
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public static String getLoanNo(String sCustomerID,String customerType) throws Exception{
		String sReturn = "";
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bm  = null;
		BizObject bo = null;
		//对公客户和个体工商户
		if(DefaultCustomerManagerFactory.LARGE_ENT_CUSTOMERTYPE.equals(customerType)||DefaultCustomerManagerFactory.INDCOM_CUSTOMERTYPE.equals(customerType)){
			bm = f.getManager("jbo.app.ENT_INFO");
		}else if(DefaultCustomerManagerFactory.PERSONAL_IND_CUSTOMERTYPE.equals(customerType)){
			bm = f.getManager("jbo.app.IND_INFO");
		}
		if(bm != null){
			bo = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID).getSingleResult(false);
			if(bo!=null){
				sReturn = bo.getAttribute("LOANCARDNO").getString();
			}
		}
		return sReturn;
	}
	
}
