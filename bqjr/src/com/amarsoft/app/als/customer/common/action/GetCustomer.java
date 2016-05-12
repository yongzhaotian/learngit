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
 * �ͻ�����ģ�� ҳ��Sql����ͨ����
 * @author qchen 2011-5-18
 *
 */
public class GetCustomer {
	private String customerID;
	private String relativeID;
	private String relationShip;
	private String serialNo;	//Customer_Relative��ˮ�� 
	private String keyManID;	//�����߹ܱ��

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
	 * �����ҵ��ģ��Ϣ
	 * @param sCustomerID
	 * @return
	 * @throws JBOException
	 */
	public static String getCustomerScope(String sCustomerID) throws Exception{
		String sScope = ""; //�ͻ���������
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.ENT_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo!=null){
			sScope = bo.getAttribute("Scope").getString();
		}else{
			throw new Exception("δ�ҵ��ÿͻ�,ENT_INFO.CustomerID=["+sCustomerID+"]");
		}
		return sScope;
	}
	/**
	 * ȡ�ͻ�����
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public static String getCustomerName(String sCustomerID) throws Exception{
		String customerName = ""; //�ͻ�����
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo!=null){
			customerName = bo.getAttribute("CustomerName").getString();
		}else{
			customerName=sCustomerID;
			ARE.getLog().warn("δ�ҵ��ÿͻ�,CUSTOMER_INFO.CustomerID=["+sCustomerID+"]");
		}
		return customerName;
	}
	
	/**
	 * ���������������ˮ���ж��Ƿ���ʾ��ҵ��ģ���в��㰴ťAttribute5
	 * @param sTaskNo	�����������ˮ��
	 * @return	sAttribute �Ƿ���ʾ��ҵ��ģ���в��㰴ť ����λ
	 * @throws Exception
	 */
	public static String getAllowFlowModelButtonIsShow(String sObjectNo,String sObjectType) throws Exception{
		String sAttribute = "";	//����λ
		String sFlowNo = "";	//���̱��
		String sPhaseNo = "";	//���̽׶α��
		BizObjectManager taskbom = JBOFactory.getFactory().getManager("jbo.app.FLOW_TASK");
		BizObject taskbo = taskbom.createQuery("select FlowNo,PhaseNo from o where ObjectNo=:ObjectNo and ObjectType=:ObjectType and (PhaseAction is null or PhaseAction=' ') and (EndTime is null or EndTime =' ')")
							.setParameter("ObjectNo", sObjectNo).setParameter("ObjectType",sObjectType).getSingleResult(false);
		if(taskbo==null){
			ARE.getLog().warn("δ�ҵ�FLOW_TASK.ObjectNo=["+sObjectNo+"],ObjectType=["+sObjectType+"]��δ��ɼ�¼");
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
	 * �������̱�ź����̽׶κŻ�ȡ���鿴�Լ�ǩ����������Ӧ�Ľ׶�
	 * @param sFlowNo ���̱��
	 * @param sPhaseNo	���̽׶κ�
	 * @return sAttribute �Լ�ǩ���������Ӧ�Ľ׶�
	 * @throws Exception
	 */
	public static String getAllowFlowSelfOpinionPhase(String sFlowNo,String sPhaseNo) throws Exception{
		String sAttribute = ""; //�Լ�ǩ���������Ӧ�Ľ׶�
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.FLOW_MODEL");
		BizObject bo = bom.createQuery("FlowNo=:FlowNo and PhaseNo=:PhaseNo").setParameter("FlowNo",sFlowNo).setParameter("PhaseNo",sPhaseNo).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�FLOW_MODEL.FlowNo=["+sFlowNo+"],PhaseNo=["+sPhaseNo+"]�ļ�¼��");
		}else{
			if(!(bo.getAttribute("Attribute6").isNull())){
				sAttribute = bo.getAttribute("Attribute6").getString();
			}
		}
		return sAttribute;
	}
	
	/**
	 * ���ݿͻ���ŷ�����ؿͻ���Ϣ
	 * @param sCustomerID �ͻ����
	 * @return sCertType@sCertID@sCustomerName ֤������@֤����@�ͻ�����
	 * @throws Exception
	 */
	public static String getCustomerCertAndName(String sCustomerID) throws Exception{
		String sCertType = "";	//֤������
		String sCertID = "";	//֤�����
		String sCustomerName = "";	//�ͻ�����
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID", sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�CUSTOMER_INFO.CustomerID=["+sCustomerID+"]�ļ�¼");
		}else{
			sCertType = bo.getAttribute("CertType").getString();
			sCertID = bo.getAttribute("CertID").getString();
			sCustomerName = bo.getAttribute("CustomerName").getString();
		}
		return sCertType+"@"+sCertID+"@"+sCustomerName;
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�����
	 * @param sCustomerID	�ͻ����
	 * @return sCustomerType �ͻ�����
	 * @throws Exception
	 */
	public static String getCustomerType(String sCustomerID) throws Exception{
		String sCustomerType = ""; //�ͻ�����
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�CUSTOMER_INFO.CustomerID=["+sCustomerID+"]�ļ�¼");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").getString();
		}
		return sCustomerType;
	}
	
	/**
	 * ��������ģ�����ͻ�ȡģ����������
	 * @param sModelType	����ģ������
	 * @return sModelTypeAttribute ģ����������
	 * @throws Exception
	 */
	public static String getModelTypeAttribute(String sModelType) throws Exception{
		String sModelTypeAttribute = ""; //ģ����������
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");
		BizObject bo = bom.createQuery("CodeNo='EvaluateModelType' and ItemNo=:ItemNo").setParameter("ItemNo", sModelType).getSingleResult(false);
		if(bo==null){
			throw new Exception("ģ������ ["+sModelType+"] û�ж��塣��鿴CODE_LIBRARY:EvaluateModelType");
		}else{
			sModelTypeAttribute = bo.getAttribute("RelativeCode").getString();
		}
		return sModelTypeAttribute;
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ����ͣ��ͻ�֤�����ͻ���ģ
	 * @param sCustomerID �ͻ����
	 * @return �ͻ�����@�ͻ�֤������@֤�����@�ͻ���ģ
	 * @throws Exception
	 */
	public static String getCustomerTypeAndCert(String sCustomerID) throws Exception{
		String sCustomerType = "";	//�ͻ�����
		String sCertType = "";	//֤������
		String sCertID = "";	//֤�����
		String sCustomerScale = "";	//�ͻ���ģ
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�CUSTOMER_INFO.CustomerID=["+sCustomerID+"]�ļ�¼");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").isNull() ? "" : bo.getAttribute("CustomerType").getString();
			sCertType = bo.getAttribute("CertType").isNull() ? "" : bo.getAttribute("CertType").getString();
			sCertID = bo.getAttribute("CertID").isNull() ? "" : bo.getAttribute("CertID").getString();
			sCustomerScale = bo.getAttribute("CustomerScale").isNull() ? "" : bo.getAttribute("CustomerScale").getString();
		}
		return sCustomerType+"@"+sCertType+"@"+sCertID+"@"+sCustomerScale;
	}
	
	/**
	 * ���ݸ��˿ͻ���Ż�ȡ�ͻ��������
	 * @param sCustomerID �ͻ����
	 * @return sMarriage �������
	 * @throws Exception
	 */
	public static String getCustomerMarriage(String sCustomerID) throws Exception{
		String sMarriage = "";	//�������
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.IND_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�CUSTOMER_INFO.CustomerID=["+sCustomerID+"]�ļ�¼");
		}else{
			sMarriage = bo.getAttribute("Marriage").getString();
		}
		return sMarriage;
	}
	
	/**
	 * ��ȡ�ͻ�׼�뵱ǰ���̽׶�����ͽ׶���Ϣ
	 * @param sUserID	��ǰ�û���
	 * @param sObjectNo	���̶�����
	 * @param sObjectType	���̶�������
	 * @param sFlowNo	���̱��
	 * @param sPhaseNo	���̽׶α��
	 * @return	bo ��ǰ���̽׶�����ͽ׶���Ϣ����
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
	 * ��ȡ���װ汾�����ѯ�����
	 * @param Sqlca
	 * @param sGroupID	���ű��
	 * @param sFamilySeq	���װ汾
	 * @return ��ѯ�����
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
	 * ��ȡ��ǰ�������е�ǰ�ͻ���Ϣ�鿴Ȩ��ά��Ȩ�ļ�¼
	 * @param Sqlca
	 * @param sCustomerID	�ͻ����
	 * @param sUserID	��ǰ�û����
	 * @return	��Ϣ�鿴Ȩ����ά��Ȩ��¼��
	 * @throws Exception
	 */
	public static int getBelongCustomerCounts(Transaction Sqlca,String sCustomerID,String sUserID) throws Exception{
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObjectQuery bq = null;
		ASUser CurUser = ASUser.getUser(sUserID, Sqlca);	//��ǰ�û�����
		//-------------�ͻ������λ������/����/֧�У�����Ա���ӿͻ�������Ϣ���в�ѯ���������Լ����е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
		if(CurUser.hasRole("080") || CurUser.hasRole("280") || CurUser.hasRole("480")){
			bq = bm.createQuery("CustomerID=:CustomerID and OrgID=:OrgID and UserID=:UserID and (BelongAttribute1='1' or BelongAttribute2='1')")
				.setParameter("CustomerID",sCustomerID).setParameter("OrgID",CurUser.getOrgID()).setParameter("UserID",sUserID);
			
		}else{ //-----------�ǿͻ������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
			bq = bm.createQuery("CustomerID=:CustomerID and OrgID in (Select OI.OrgID from jbo.sys.ORG_INFO OI where OI.SortNo like :SortNo) and (BelongAttribute1 ='1') or BelongAttribute2 = '1'")
				.setParameter("CustomerID",sCustomerID).setParameter("SortNo",CurUser.getOrgSortNo()+"%");
		}
		return  bq.getTotalCount();
	}
	
	/**
	 * ����ҵ���������ͻ�ȡ������ͼ����
	 * @param sApplyType	ҵ����������
	 * @return	sItemDescribe ������ͼ����
	 * @throws Exception
	 */
	public static String getApplyViewTreeNo(String sApplyType) throws Exception{
		String sItemDescribe = ""; //������ͼ����
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");		    
		BizObjectQuery	query = bm.createQuery("select ItemDescribe from o where CodeNo = 'ApplyType' and ItemNo =:ItemNo").setParameter("ItemNo",sApplyType);
		BizObject bizo = query.getSingleResult(false);
		if (bizo != null){   				    
			sItemDescribe=bizo.getAttribute("ItemDescribe").getString();
		}else{
			throw new Exception("û���ҵ���Ӧ���������Ͷ���(CODE_LIBRARY.CodeNo:ApplyType and ItemNo:"+sApplyType+")!");
		}
		if(sItemDescribe == null) sItemDescribe = "";
		return sItemDescribe;
	}
	
	/**
	 * ����ҵ���������ͻ�ȡ������ͼ����
	 * @param sApproveType	ҵ����������
	 * @return	sItemDescribe ������ͼ����
	 * @throws Exception
	 */
	public static String getApproveViewTreeNo(String sApproveType) throws Exception{
		String sItemDescribe = ""; //������ͼ����
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.sys.CODE_LIBRARY");		    
		BizObjectQuery	query = bm.createQuery("select ItemDescribe from o where CodeNo = 'ApproveType' and ItemNo =:ItemNo").setParameter("ItemNo",sApproveType);
		BizObject bizo = query.getSingleResult(false);
		if (bizo != null){   				    
			sItemDescribe=bizo.getAttribute("ItemDescribe").getString();
		}else{
			throw new Exception("û���ҵ���Ӧ���������Ͷ���(CODE_LIBRARY.CodeNo:ApproveType and ItemNo:"+sApproveType+")!");
		}
		if(sItemDescribe == null) sItemDescribe = "";
		return sItemDescribe;
	}
	
	/**
	 * ������Ŀ��Ż�ȡ��Ŀ����
	 * @param sProjectNo	��Ŀ���
	 * @return sProjectType ��Ŀ����
	 * @throws Exception
	 */
	public static String getProjectType(String sProjectNo) throws Exception{
		String sProjectType = ""; //��Ŀ����
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.PROJECT_INFO");
		BizObject bo = bom.createQuery("ProjectNo=:ProjectNo").setParameter("ProjectNo",sProjectNo).getSingleResult(false);
		if (bo != null){   				    
			sProjectType = bo.getAttribute("ProjectType").getString();
		}else{
			throw new Exception("û���ҵ���Ӧ���������Ͷ���(PROJECT_INFO.ProjectType:"+sProjectNo+")!");
		}
		if(sProjectType==null) sProjectType="";
		return sProjectType;
	}
	
	/**
	 * ���ݿͻ���Ż�ȡ�ͻ�֤�����
	 * @param sCustomerID �ͻ����
	 * @return sCertID ֤�����
	 * @throws Exception
	 */
	public static String getCertID(String sCustomerID) throws Exception{
		String sCertID = ""; //֤�����
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
	    BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID);
	    BizObject bo = bq.getSingleResult(false);
	    if(bo!=null){
	    	sCertID = bo.getAttribute("CertID").getString();
	    }else{
	    	throw new Exception("û���ҵ���Ӧ�Ŀͻ�(CUSTOMER_INFO.CustomerID:"+sCustomerID+")!");
	    }
	    if(sCertID==null) sCertID = "";
	    return sCertID;
	}
	
	/**
	 * �鿴�û��Ƿ��е�ǰ�ͻ�����Ȩ
	 * @param sCustomerID	�ͻ����
	 * @param sUserID	�û����
	 * @return	sRight	Ȩ�ޱ�־
	 * @throws Exception
	 */
	public static String getManageRight(String sCustomerID,String sUserID) throws Exception{
		String sRight = "";	//����Ȩ�ޱ�־
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
	 * ���ݿͻ���Ż�ȡ�ͻ����ͺͼ��ſͻ����
	 * @param sCustomerID	�ͻ����
	 * @return sCustomerType �ͻ�����
	 * @throws Exception
	 */
	public static String getCustomerTypeAndGroupID(String sCustomerID) throws Exception{
		String sCustomerType = ""; //�ͻ�����
		String sBelongGroupID = ""; //�������ű��
		BizObjectManager bom = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObject bo = bom.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID).getSingleResult(false);
		if(bo==null){
			throw new Exception("δ�ҵ�CUSTOMER_INFO.CustomerID=["+sCustomerID+"]�ļ�¼");
		}else{
			sCustomerType = bo.getAttribute("CustomerType").getString();
			sBelongGroupID = bo.getAttribute("BelongGroupID").getString();
		}
		
		if(sCustomerType==null) sCustomerType="";
		if(sBelongGroupID==null) sBelongGroupID="";
		return sCustomerType+"@"+sBelongGroupID;
	}
	
	/** add by yrma 2011-9-23 13:08:50
	 * �������ͻ���ţ���ȡ�ͻ�������Ϣ
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
	 * �жϵ�ǰ�û��Ƿ��в鿴ָ���ͻ�Ȩ��,�з���true,���򷵻�false
	 * @param sCustomerID
	 * @param CurUser
	 * @return
	 * @throws Exception 
	 */
	public static boolean checkUserRight(String sCustomerID,ASUser CurUser) throws Exception{
		boolean bFlag=true;//�û��Ƿ��жԸÿͻ��Ĳ鿴Ȩ��
		String sSql="";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_BELONG");
		BizObjectQuery bq=null;
		int iCount=0;
		//�ͻ������λ������/����/֧�У�����Ա���ӿͻ�������Ϣ���в�ѯ���������Լ����е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
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
		}else//�ǿͻ������λ����Ա���ӿͻ�������Ϣ���в�ѯ�����������������������е�ǰ�ͻ�����Ϣ�鿴Ȩ����Ϣά��Ȩ�ļ�¼��
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
		if(CurUser.hasRole("043") || CurUser.hasRole("243")){//����Ǽ��ſͻ������,����Ȩ�޿���
			iCount=1;
		}
		if(iCount<=0){
			bFlag=false;
		}
		return bFlag;
	}
	/*public static String[] getCustomerViewInfo(String sCustomerID) throws Exception{
		String[] strs = new String[3];
		String sCustomerType = "";//--�ͻ�����	
		String sBelongGroupID = "";//�������ſͻ�ID
		String sTreeViewTemplet = "";//--���custmerviewҳ����ͼ��CodeNo
		//ȡ�ÿͻ�����
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID");
		bq.setParameter("CustomerID",sCustomerID);
		BizObject boCustomerInfo=bq.getSingleResult();
		if(boCustomerInfo!=null){
			sCustomerType=boCustomerInfo.getAttribute("CustomerType").getString();
			sBelongGroupID=boCustomerInfo.getAttribute("BelongGroupID").getString();//����Ǽ��ų�Ա����ȡ���������ſͻ�ID
		}else{
			throw new Exception("û���ҵ��ÿͻ�,CUSTOMER_INFO.CustomerID=["+sCustomerID+"]");
		}
		if(sCustomerType == null) sCustomerType = "";
		if(sBelongGroupID == null) sBelongGroupID = "";
		//ȡ����ͼģ������
		Item item=CodeManager.getItem("CustomerType",sCustomerType);
		sTreeViewTemplet=item.getItemDescribe().trim();//��˾�ͻ�������ͼ����
		strs[0]=sCustomerType;
		strs[1]=sBelongGroupID;
		strs[2]=sTreeViewTemplet;
		return strs;
	}
	*/
	/**
	 * ��ȡ�ͻ���ǰ����ģ��
	 * @param sCustomerID	�ͻ����
	 * @return	sCreditBelong	����ģ��
	 * @throws Exception
	 */
	public static String getEntCreditBelong(String sCustomerID) throws Exception{
		String sCreditBelong = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_INFO");
		BizObjectQuery bq = bm.createQuery("CustomerID=:CustomerID").setParameter("CustomerID",sCustomerID);
		BizObject bo = bq.getSingleResult(false);
		if(bo!=null){
			//��ȡ�ͻ�������Ϣ�е�����ģ����Ϣ
			sCreditBelong = bo.getAttribute("CREDITBELONG").getString();
			if(sCreditBelong == null)sCreditBelong = "";
		}else{
			sCreditBelong = ""; 
		}
		return sCreditBelong;
	}
	
	/**
	 * ��ȡ�ͻ���Ч���ۼ�¼����������ģ�ͺ�
	 * @param sCustomerID	�ͻ����
	 * @return	sCreditBelong	���ۼ�¼
	 * @throws Exception
	 */
	public static String getCusRating(String sCustomerID) throws Exception{
		String sRefModelID = "";
		BizObjectManager bm = JBOFactory.getFactory().getManager("jbo.app.CUSTOMER_RATING");
		//StatusFlag����1��Ϊ��Ч����2��Ϊ��Ч
		//SaveFlag����1��Ϊ�ݴ棬��2��Ϊ����
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
	 * ���ݺ������ͻ���Ż�ȡ�������ͻ�ģ��
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
	 * ��ȡ�ͻ�������������
	 * @param sCustomerID
	 * @return
	 * @throws Exception 
	 */
	public static String getCustomerBelongGroup(String sCustomerID) throws Exception{
		String sGroupName = "��";
		
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
	 * ��ȡ������������
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
	 * ��ȡ��˾�ͻ��ͻ�����
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
	 * ��ȡ���˴���֤������
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
	 * ��ȡ�ؼ���ѧ��
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
	 * ¼����ҵ�߹���Ϣʱ�������Ϣ�ظ�¼��
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
	 * ¼����ҵ�ؼ�����Ϣʱ�������Ϣ�ظ�¼��
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
	 * ¼�������ż���ͥ��Ҫ��Ա��Ϣʱ�������Ϣ�ظ�¼��
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
	 * ��ȡ�����
	 * @param sCustomerID
	 * @return
	 * @throws Exception
	 */
	public static String getLoanNo(String sCustomerID,String customerType) throws Exception{
		String sReturn = "";
		JBOFactory f = JBOFactory.getFactory();
		BizObjectManager bm  = null;
		BizObject bo = null;
		//�Թ��ͻ��͸��幤�̻�
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
