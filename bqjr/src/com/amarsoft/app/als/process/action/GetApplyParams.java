package com.amarsoft.app.als.process.action;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;
/**
 * ��ȡ���õ������̲���
 * @author xfliu
 * 07/27/2011
 */
public class GetApplyParams {
	/**
	 * ���������Ż�ȡҵ��Ʒ�ֺͿͻ����
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getApplyParams(String ApplyNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPLY");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", ApplyNo);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * ���ݺ�ͬ��Ż�ȡ��ͬ������Ϣ  yrma 2011-10-9 20:31:22
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getBusApproveParams(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo);
		bo = bq.getSingleResult();
		return bo;
	}
	
	
	/**
	 * ���ݺ�ͬ��Ż�ȡ��ͬ������Ϣ  yrma 2011-10-9 20:31:22
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getBusContractParams(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_CONTRACT");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo);
		bo = bq.getSingleResult();
		return bo;
	}
	
	
	/**
	 * ���ݳ��˱�Ż�ȡ���˻�����Ϣ  
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getBusPutOutParams(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_PUTOUT");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo", SerialNo);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * ���ݶ����Ż�ȡ������Ϣ  xjzhao
	 * @param ObjectNo,ObjectType
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getObjectParams(String ObjectNo,String ObjectType) throws JBOException {
		
		if(ObjectType.equalsIgnoreCase("BusinessContract")) return getBusContractParams(ObjectNo);
		else  if(ObjectType.equalsIgnoreCase("ApproveApply")) return getBusApproveParams(ObjectNo);
		else  if(ObjectType.equalsIgnoreCase("PutOutApply")) return getBusPutOutParams(ObjectNo);
		else  if(ObjectType.equalsIgnoreCase("CreditApply")) return getApplyParams(ObjectNo);
		else throw new JBOException("����Ķ�������"+ObjectType+"����ȷ�����飡");
	}
	
	
	/** add by yrma 2011-9-23 9:56:04
	 * ���������Ż�ȡ�����������Ϣ
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getApprovebyBAParams(String ApplyNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
		bq = bm.createQuery("RelativeSerialNo=:SerialNo").setParameter("SerialNo", ApplyNo);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/** add by yrma 2011-9-23 9:56:04
	 * ����������Ż�ȡ����зֵ������Ϣ
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */
	public static List getCLdetailParams(String SerialNo,String SplitType) throws JBOException {
		List bos = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.CL_DETAIL");
		bq = bm.createQuery("Select \"O.*\" from o,jbo.app.CL_INFO CI where CI.BAPSERIALNO=:SerialNo and o.LINEID=CI.LINEID and o.SplitType=:SplitType").setParameter("SerialNo", SerialNo).setParameter("SplitType", SplitType);
		bos = bq.getResultList();
		return bos;
	}
	
	/** add by yrma 2011-9-23 9:56:04
	 * ���ݺ�ͬ��Ż�ȡԭʼ����зֵ������Ϣ
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */
	public static List getCLdetailBCParams(String SerialNo,String SplitType) throws JBOException {
		List bos = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.CL_DETAIL");
		bq = bm.createQuery("Select \"O.*\" from o,jbo.app.CL_INFO CI where CI.BCSERIALNO=:SerialNo and o.LINEID=CI.LINEID and o.SplitType=:SplitType").setParameter("SerialNo", SerialNo).setParameter("SplitType", SplitType);
		bos = bq.getResultList();
		return bos;
	}
	
	/** add by yrma 2011-9-23 9:56:04
	 * ����������Ż�ȡ����зֵ������Ϣ
	 * @param ApplyNo
	 * @return
	 * @throws JBOException
	 */  
	public static List getCreditGuaParams(String SerialNo,String GuarantyType) throws JBOException {
		List bos = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		
		bm = JBOFactory.getFactory().getManager("jbo.app.CREDIT_GUARANTY");
		bq = bm.createQuery("ObjectNo=:SerialNo and ObjectType='ApproveApply' and GuarantyType like :GuarantyType").setParameter("SerialNo", SerialNo).setParameter("GuarantyType", GuarantyType+"%");
		bos = bq.getResultList();
		return bos;
	}
	
	/**
	 * ���ݼ��ſͻ���ţ��Լ����ԣ���ȡ�������¶�Ӧ�Ŀͻ����
	 * @param SerialNo��GROUPTYPE3
	 * @return
	 * @throws JBOException
	 */
	public static List getgroupMemberID(String CustomerID,String GroupType) throws JBOException {
		List bos = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		bq = bm.createQuery(" select \"O.*\" from jbo.app.GROUP_INFO GI, o " +
				"  where O.GroupID=GI.GroupID and GI.GROUPTYPE3=:GroupType" +
				" and GI.GroupID=:CustomerID")  
				.setParameter("GroupType",GroupType).setParameter("CustomerID",CustomerID);
		bos = bq.getResultList();
		return bos;
	}
	
	/**
	 * ���ݿͻ���ţ���ȡ���ſͻ����
	 * @param SerialNo��GROUPTYPE3
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getgroupID(String CustomerID,String GroupType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		bq = bm.createQuery(" select \"O.*\" from jbo.app.GROUP_INFO GI, o " +
				"  where O.GroupID=GI.GroupID and GI.GROUPTYPE3=:GroupType" +
				" and o.MemberCustomerID=:CustomerID")
				.setParameter("GroupType",GroupType).setParameter("CustomerID",CustomerID);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * ��ȡ�ͻ���Ӧ��Ч�����Ŷ��(��������Ķ��)
	 * @param CustomerID �ͻ����
	 * @param CLType �������
	 * @return 
	 * @throws JBOException
	 */
	public static BizObject getCLInfo(String CustomerID,String CLType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		String sToday = StringFunction.getToday();
		
		bm = JBOFactory.getFactory().getManager("jbo.app.CL_INFO"); 
		bq = bm.createQuery("CustomerID=:CustomerID and CLType=:BusinessType and BEGINDATE <=:sToday " +
		" and ENDDATE >=:sToday1  and STATUS in ('Frozen','Efficient','Thawy')")
		.setParameter("CustomerID",CustomerID).setParameter("BusinessType",CLType)
		.setParameter("sToday",sToday).setParameter("sToday1",sToday);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * ����ҵ���ţ���ȡ������Ϣ���
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getBASerilNo(String SerialNo,String ObjectType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		if(ObjectType.equals("CreditApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE");
		else if(ObjectType.equals("ApproveApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPROVE_RELATIVE");
		else
			bm = JBOFactory.getFactory().getManager("jbo.app.CONTRACT_RELATIVE");

		bq = bm.createQuery("SerialNo=:SerialNo and OBJECTTYPE =:OBJECTTYPE").setParameter("SerialNo",SerialNo).setParameter("OBJECTTYPE",ObjectType);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sOBJECTNO = bo.getAttribute("OBJECTNO").toString();
			sReturn = sOBJECTNO;
		}
		return sReturn;
	}
	
	/**
	 * ����ҵ���ţ�ԭʼҵ����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getsOldSerilNo(String SerialNo,String ObjectType,String bObjectType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		if(ObjectType.equals("CreditApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE");
		else if(ObjectType.equals("ApproveApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPROVE_RELATIVE");
		else
			bm = JBOFactory.getFactory().getManager("jbo.app.CONTRACT_RELATIVE");

		bq = bm.createQuery("SerialNo=:SerialNo and OBJECTTYPE =:OBJECTTYPE").setParameter("SerialNo",SerialNo).setParameter("OBJECTTYPE",bObjectType);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sOBJECTNO = bo.getAttribute("OBJECTNO").toString();
			sReturn = sOBJECTNO;
		}
		return sReturn;
	}
	
	/**
	 * ����ҵ���ţ�ԭʼҵ����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static List getOldSerilNo(String SerialNo,String ObjectType,String bObjectType) throws JBOException {
		List bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		if(ObjectType.equals("CreditApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPLY_RELATIVE");
		else if(ObjectType.equals("ApproveApply"))
			bm = JBOFactory.getFactory().getManager("jbo.app.APPROVE_RELATIVE");
		else
			bm = JBOFactory.getFactory().getManager("jbo.app.CONTRACT_RELATIVE");

		bq = bm.createQuery("SerialNo=:SerialNo and OBJECTTYPE =:OBJECTTYPE")
			.setParameter("SerialNo",SerialNo).setParameter("OBJECTTYPE",bObjectType);
		bo = bq.getResultList();
		return bo;
	}
	
	
	/**
	 * ����ҵ���ţ�ȡԭʼ��ȱ��
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static List getRelaCreditNo(String ObjectNo,String ObjectType) throws JBOException {
		List bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.CL_Replace");
		bq = bm.createQuery("ObjectNo=:ObjectNo and OBJECTTYPE =:OBJECTTYPE").setParameter("ObjectNo",ObjectNo).setParameter("ObjectType",ObjectType);
		bo = bq.getResultList();
		return bo;
	}
	
	
	/**
	 * ��ͬ�׶θ������Ŷ�ȱ�ţ���ȡ��ȵ�LINEID
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getLineID(String SerialNo,String ObjectType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.CL_INFO");
		if(ObjectType.equals("CreditApply"))
			bq = bm.createQuery("BASERIALNO=:applyNo").setParameter("applyNo",SerialNo);
		else if(ObjectType.equals("ApproveApply"))
			bq = bm.createQuery("BAPSERIALNO=:applyNo").setParameter("applyNo",SerialNo);
		else
			bq = bm.createQuery("BCSERIALNO=:applyNo").setParameter("applyNo",SerialNo);
		
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sLineID = bo.getAttribute("LineID").toString();
			sReturn = sLineID;
		}
		return sReturn;
	}
	
	
	/**
	 * �������̱�Ż�ȡ����״̬
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getFlowState(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sFlowState = bo.getAttribute("FlowState").toString();
			sReturn = sFlowState;
		}
		return sReturn;
	}

	/**
	 * �������̱�Ż�ȡ�����������
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getFlowTaskParams(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult(false);
		return bo;
	}
	
	/**
	 * �������̱�Ż�ȡ���̴�����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getSignUserID(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sSignUserID = bo.getAttribute("InputUser").toString();
			sReturn = sSignUserID;
		}
		return sReturn;
	}
	/**
	 * ���������ź��������ͻ�ȡͨ����ҵ������������
	 * @param ApplyNo
	 * @param ApplyType
	 * @return
	 * @throws JBOException
	 */
	public static String getPassBusinessTaskNo(String ApplyNo,String ApplyType) throws JBOException{
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("ApplyNo=:ApplyNo and ApplyType=:ApplyType and PhaseType='1000'").setParameter("ApplyNo",ApplyNo).setParameter("ApplyType", ApplyType);
		bo = bq.getSingleResult();
		String sPassBusinessTaskNo = "";
		if(bo != null){
			sPassBusinessTaskNo = bo.getAttribute("RelativeSerialNo").toString();
		}
		return sPassBusinessTaskNo;
	}

	/**
	 * �����û�ID��ȡ��ɫID
	 * @param UserID
	 * @return
	 * @throws JBOException
	 */
	public static String getRoleID(String UserID) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.sys.USER_ROLE");
		bq = bm.createQuery("UserID=:UserID").setParameter("UserID",UserID);
		bo = bq.getSingleResult();
		String sRoleID = "";
		if(bo != null){
			sRoleID = bo.getAttribute("RoleID").toString();
		}
		return sRoleID;
	}
	/**
	 * �����������з��ص��û��б���д������û��ַ���
	 * @param UserList
	 * @return
	 * @throws JBOException
	 */
	public static String getUserList(String UserList) throws JBOException {
		String sUserString = "";
		if(!"".equals(UserList)){
			for(int i = 0;i<UserList.split(",").length;i++){
				String sUser = UserList.split(",")[i];
				sUser = sUser.replace("[\"", "").replace("\"]", "");
				String sUserID = sUser.split(" ")[0];
				//String sRoleID = sUser.split(" ")[2];
				if("".equals(sUserString)){
					sUserString = sUserID;
				}else{
					sUserString = sUserString +"@"+sUserID;
				}
			}
		}
		return sUserString;
	}
	
	/**
	 * �������̱�Ż�ȡOperateArea����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getOperateArea(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sOperateArea = bo.getAttribute("OperateArea").toString();
			if("".equals(sOperateArea) || "null".equals(sOperateArea) || sOperateArea==null) sOperateArea="";
			sReturn = sOperateArea;
		}
		return sReturn;
	}
	
	/**
	 * �������̱�Ż�ȡInfoArea����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getInfoArea(String serialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",serialNo);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sInfoArea = bo.getAttribute("InfoArea").toString();
			if(StringX.isSpace(sInfoArea)) sInfoArea ="";
			sReturn = sInfoArea;
		}
		return sReturn;
	}
	
	/**
	 * ����������ˮ�Ż���������͡�
	 * @throws JBOException 
	 * 
	 */
	public static String getApproveParams(String applyNo) throws JBOException{
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_APPROVE");
		bq = bm.createQuery("SerialNo=:ApplyNo").setParameter("ApplyNo",applyNo);
		bo = bq.getSingleResult();
		String sReturn = "";
		if(bo != null){
			String sApplyType = bo.getAttribute("ApplyType").toString();
			String sBusinessType = bo.getAttribute("BusinessType").toString();
			String sRelativeSerialNo = bo.getAttribute("RelativeSerialNo").toString();
			String sCustomerID = bo.getAttribute("CustomerID").toString();
			if(StringX.isSpace(sApplyType)) sApplyType ="";
			if(StringX.isSpace(sBusinessType)) sBusinessType ="";
			if(StringX.isSpace(sRelativeSerialNo)) sRelativeSerialNo ="";
			if(StringX.isSpace(sCustomerID)) sCustomerID ="";
			sReturn = sApplyType+"@"+sBusinessType+"@"+sRelativeSerialNo+"@"+sCustomerID;
		}
		return sReturn;
	}
	/**
	 * ��ȡ�����ίԱ����б�
	 * @param SerialNo
	 * @return
	 * @throws Exception
	 */
	public static List<BizObject> getOpinionList(String SerialNo) throws Exception{
		List<BizObject> list = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		bq = bm.createQuery("SerialNo=:SerialNo and Flag2='1000'").setParameter("SerialNo",SerialNo);
		list = bq.getResultList();
		return list;
	}
	/**
	 * ��ȡ����᲻ͬͶƱ�����ίԱ����
	 * @param SerialNo
	 * @return
	 * @throws Exception
	 */
	public static String getNums(String SerialNo) throws Exception{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		int AgreeNum = 0,DisAgreeNum = 0,ReconsiderationNum = 0;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_OPINION");
		bq = bm.createQuery("SerialNo=:SerialNo and Flag2='1000' and PhaseChoice='01'").setParameter("SerialNo",SerialNo);
		AgreeNum = bq.getTotalCount();
		bq = bm.createQuery("SerialNo=:SerialNo and Flag2='1000' and PhaseChoice='02'").setParameter("SerialNo",SerialNo);
		DisAgreeNum = bq.getTotalCount();
		bq = bm.createQuery("SerialNo=:SerialNo and Flag2='1000' and PhaseChoice='03'").setParameter("SerialNo",SerialNo);
		ReconsiderationNum = bq.getTotalCount();
		return String.valueOf(AgreeNum)+"@"+String.valueOf(DisAgreeNum)+"@"+String.valueOf(ReconsiderationNum);
	}
	
	/**
	 * ����������ˮ�Ż�ȡ����������ƺͿ���ʱ��
	 * @param SerialNo
	 * @return
	 * @throws Exception
	 */
	public static String getCommissionInfo(String SerialNo) throws Exception{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String sCommissionNo = "",sCommissionName = "",sCommissionTime = "";
		String sReturn = "";
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		if(bo != null){
			sCommissionNo = bo.getAttribute("RelativeVoteNo").getString();
		}
		bm = JBOFactory.getFactory().getManager("jbo.app.CREDIT_COMMISSION");
		bq = bm.createQuery("CommissionNo=:CommissionNo").setParameter("CommissionNo",sCommissionNo);
		bo = bq.getSingleResult();
		if(bo != null){
			sCommissionName = bo.getAttribute("CommissionName").getString();
			sCommissionTime = bo.getAttribute("CommissionTime").getString();
			if(sCommissionName == null) sCommissionName = "";
			if(sCommissionTime == null) sCommissionTime = "";
			sReturn = sCommissionName + "@" + sCommissionTime + "@" + sCommissionNo;
		}
		return sReturn;
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ��Ӧ�ļ��ſͻ����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getGroupID(String CustomerID,String CustomerType) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.GROUP_MEMBER_RELATIVE");
		bq = bm.createQuery("GroupCustomerType=:CustomerType AND MemberCustomerID=:CustomerID")
		.setParameter("CustomerType",CustomerType).setParameter("CustomerID",CustomerID);
		bo = bq.getSingleResult(false);
		String sReturn = ""; 
		if(bo != null){
			String sGroupID = bo.getAttribute("GroupID").toString();
			if(StringX.isSpace(sGroupID)) sGroupID ="";
			sReturn = sGroupID;
		}
		return sReturn;
	}
	
	/**
	 * ��ȡָ���ύ�׶�
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getAssignedPhaseAction(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sAssignedTaskNo = "",sUserID = "",sUserName = "";
		String sReturn = "";
		if(bo != null){
			sAssignedTaskNo = bo.getAttribute("AssignedTaskNo").getString();
		}
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",sAssignedTaskNo);
		bo = bq.getSingleResult();
		if(bo != null){
			sUserID = bo.getAttribute("UserID").getString();
			sUserName = bo.getAttribute("UserName").getString();
			sReturn = sAssignedTaskNo + "@" + sUserID + "," +sUserName;
		}
		return sReturn;
	}
	
	/**
	 * ���ݵ�ǰ�����Ż�ȡǰһ�׶�������
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String getPreTaskNo(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sPreTaskNo = "";
		if(bo != null){
			sPreTaskNo = bo.getAttribute("RelativeSerialNo").getString();
		}
		
		return sPreTaskNo;
	}
	
	/**
	 * �жϸ������Ƿ��ǻ�ǩ����
	 * @param SerialNo
	 * @return
	 * @throws JBOException
	 */
	public static String isNoticeTaskFlag(String SerialNo) throws JBOException {
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",SerialNo);
		bo = bq.getSingleResult();
		String sPhaseNo = "";
		if(bo != null){
			sPhaseNo = bo.getAttribute("PhaseNo").toString();
			if(StringX.isSpace(sPhaseNo)) sPhaseNo = "";
		}
		String sReturn = "";
		if(sPhaseNo.indexOf("CounterSign")>-1){
			sReturn = "true";
		}else{
			sReturn = "false";
		}
		return sReturn;
	}
	
	
	public static String getMaxFTSerialNo(String sApplyType,String sBASerialNo) throws Exception {
		String sMaxFTSerialNo="";
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		bq = bm.createQuery("select max(SerialNo) as V.SerialNo from O where ApplyType=:ApplyType and ApplyNo=:ApplyNo");
		bq.setParameter("ApplyType",sApplyType);
		bq.setParameter("ApplyNo",sBASerialNo);
		bo = bq.getSingleResult();
		if(bo!= null){
			sMaxFTSerialNo = bo.getAttribute("SerialNo").toString();
		}else{
			throw new Exception("û���ҵ��������������Ϣ!FLOW_TASK.ApplyType=["+sApplyType+"],ApplyNo=["+sBASerialNo+"]");
		}
		return sMaxFTSerialNo;
	}
	/**
	 * ���ݻ��� ��Ż�ȡ������鷢�ͳ�Ա�ͳ��ͳ�Ա
	 * @param SerialNo
	 * @return
	 * @throws Exception
	 */
	public static String getCommissionMembers(String CommissionNo) throws Exception{
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		BizObject bo = null;
		String sMembers = "",sOtherMembers = "";
		String sReturn = "";
		bm = JBOFactory.getFactory().getManager("jbo.app.CREDIT_COMMISSION");
		bq = bm.createQuery("CommissionNo=:CommissionNo").setParameter("CommissionNo",CommissionNo);
		bo = bq.getSingleResult();
		if(bo != null){
			sMembers = bo.getAttribute("Members").getString();
			sOtherMembers = bo.getAttribute("OtherMembers").getString();
			if(StringX.isSpace(sMembers)) sMembers = "";
	    	if(StringX.isSpace(sOtherMembers)) sOtherMembers = "";
			if("".equals(sOtherMembers)){
				sReturn = sMembers;
			}else if("".equals(sMembers)){
				sReturn = "@"+sOtherMembers;
			}else{
				sReturn = sMembers+"@"+sOtherMembers;
			}
		}
		return sReturn;
	}
	
	/**
	 * ��ȡ����������ϸ��Ϣ
	 * @param refAppSetID
	 * @return
	 * @throws JBOException
	 */
	public static BizObject getPackApplyInfo(String refAppSetID) throws JBOException{
		BizObject bo = null;
		BizObjectManager bm = null;
		BizObjectQuery bq = null;
		bm = JBOFactory.getFactory().getManager("jbo.app.BUSINESS_SET");
		bq = bm.createQuery("SerialNo=:SerialNo").setParameter("SerialNo",refAppSetID);
		bo = bq.getSingleResult();
		return bo;
	}
	
	/**
	 * ��ȡ�ͻ��Ƿ������й����ͻ�
	 * @param certID
	 * @param certType
	 * @return �Ƿ��־��1��ʾ�ǣ�2��ʾ���ǣ�
	 * @throws JBOException
	 */
	public static String getIsRelativeCustoemr(String certID,String certType) throws JBOException{
		BizObject bo = null;
		BizObjectManager bm = null;
		String sReturn = "";
		bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RELATIVE_INFO");
		bo = bm.createQuery("CertID=:CertID and CertType=:CertType").setParameter("CertID", certID).setParameter("CertType", certType).getSingleResult();
		//��ÿͻ��Ƿ�Ϊ���й�����
		if(bo!=null){
			sReturn="1";
		}else{
			sReturn="2";
		}
		return sReturn;
	} 

	
}
