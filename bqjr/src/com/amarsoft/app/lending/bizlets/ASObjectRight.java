package com.amarsoft.app.lending.bizlets;
/**
 * Ȩ���ж�
 * @author ��ҵ� 2005-08-11
 * 			syang ������࣬����������رտ��ܴ��ڵ�����
 */
import java.sql.SQLException;
import java.util.ArrayList;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.context.ASUser;


public class ASObjectRight extends Bizlet 
{

	/**
	 * @param
	 * 	<li>MethodName ������</li>
	 * 	<li>ObjectType ��������</li>
	 * 	<li>ObjectNo ������</li>
	 * 	<li>ViewID ��ͼID</li>
	 * 	<li>UserID �û�ID</li>
	 */
	public Object  run(Transaction Sqlca) throws Exception
	{
		//��ȡ�������������������ţ���ͼID���û����		
		String sMethodName = (String)this.getAttribute("MethodName");	
		String sObjectType=(String)this.getAttribute("ObjectType");
		String sObjectNo=(String)this.getAttribute("ObjectNo");
		String sViewID=(String)this.getAttribute("ViewID");
		String sUserID=(String)this.getAttribute("UserID");
		if(sMethodName == null) sMethodName = "";
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sViewID == null) sViewID = "";
		if(sUserID == null) sUserID = "";
		
		String sReturn="";
		if(sMethodName.equals("rightOfCustomer")){
			sReturn=rightOfCustomer(Sqlca,sObjectNo,sViewID,sUserID,sObjectType);
		}else if(sMethodName.equals("rightOfApply")){
			sReturn=rightOfApply(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfApprove")){
			sReturn=rightOfApprove(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfContract")){
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfCreditLine")){
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.equals("rightOfPutOut")){
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}else if(sMethodName.endsWith("rightOfPayment")){
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}
		//������ӻ��޸�-start
		else if(sMethodName.endsWith("rightOfTrans")){
			sReturn=rightOfTrans(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		}
		//������ӻ��޸�-end
		else{
			sReturn=rightOfViewId(sObjectNo,sViewID,sUserID);
		}
		
		return sReturn;
	}
	
    //  ����ViewID�ж�,001�ɱ༭������ֻ��
	public String rightOfViewId(String pObjectNo, String pViewID, String pUserID) {
		if (pViewID.equals("001"))
			return "All";
		else
			return "ReadOnly";
	}
	
	/**
	 * �ͻ�����Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pCustomerID �ͻ�ID</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
    public String rightOfCustomer(Transaction Sqlca,String pCustomerID, String pViewID, String pUserID, String sObjectType) throws Exception {
    	String sReturn = "ReadOnly";
    	/*String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //�ܻ��˿��Խ�������ά��
        String sBelongAttribute1 = ""; //��Ϣ�鿴Ȩ
        String sBelongAttribute2 = ""; //��Ϣά��Ȩ
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select BelongAttribute1,BelongAttribute2 from CUSTOMER_BELONG " +
        		"where CustomerID = :CustomerID and UserID = :UserID").setParameter("CustomerID", pCustomerID).setParameter("UserID", pUserID));
        if (rs.next()) {
        	sBelongAttribute1 = rs.getString("BelongAttribute1");
        	sBelongAttribute2 = rs.getString("BelongAttribute2");
        	//����ֵת��Ϊ���ַ���
        	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
        	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
        	if(sBelongAttribute2.equals("1")){
        		sReturn = "All";
        	}else if(sBelongAttribute1.equals("1")){
        		sReturn = "ReadOnly";
        	
        }
        
        // for customer view
        
        rs.getStatement().close();
        rs = null;}*/
    	/*String sPhaseNo = "";
    	String sContractNo = "";
    	ASResultSet rs = null;
    	if(sObjectType.equals("Customer")){
    		//�ÿͻ���ȡ���µĺ�ͬ
        	rs = Sqlca.getASResultSet("Select PhaseNo From Flow_Object Where Objectno "+
        			"in(select serialno from Business_Contract where CustomerID = '"+pCustomerID+"') and UserID = '"+pUserID+"' and PhaseNo = '0010'");
        	if(rs.next()){
        		sReturn = "All";
        	}
        	
    	}else{
    		sPhaseNo = Sqlca.getString(new SqlObject("Select PhaseNo From Flow_Object Where Objectno=:ObjectNo and UserID =:UserID")
        	.setParameter("ObjectNo", pCustomerID).setParameter("UserID", pUserID));
    		if ("0010".equals(sPhaseNo)) sReturn = "All";
    	}*/
    	
    	sReturn = "All";
    	
        return sReturn;
    }

    /**
     * �������Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
     */
	public String rightOfApply(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception {
        String sReturn = "ReadOnly";
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //����Ǽ��˿���������δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject("select ObjectNo from FLOW_OBJECT " +
        		"where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId " +
        		"and  (PhaseNo='0010' or PhaseNo='3000' or PhaseType='1010')").setParameter("ObjectType", pObjectType)
        		.setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next())  {
        	sReturn = "All";
        }
        rs.getStatement().close();
        rs = null;
        return sReturn;
    }
	
	/**
	 * ���������������Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
	public String rightOfApprove(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception {
        String sReturn = "ReadOnly";
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //������������Ǽ��˿����������������δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo='0010' or PhaseNo='3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()) {
        	sReturn = "All";
        	rs.getStatement().close(); // add by cbsu 2009-10-20
        	return sReturn;
        }
        rs.getStatement().close();
        rs = null;
        return sReturn;
    }
	
	/**
	 * ��ͬȨ���ж�
	 * 1.�û�Ԥ��Ȩ���жϣ��Ƿ񳬼��û�����ͼ��
	 * 2.��ͬ�ڲ��Ǳ�־Ϊδ���ȣ��ҵ�ǰ�û�Ϊ��Ͻ����ʱ������ά������
	 * 3.��ͬΪ�ۺ�����Э��ʱ������Ѿ��������������ҵ������ռ�ã�Ҳ���ܽ����޸�
	 * 4.��ͬ�ܻ��ˡ��Ǽ��ˡ���ȫ�ܻ����ں�ͬû������Ŵ��Һ�ͬ����û�н��ʱ����ά������
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
	public String rightOfContract(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        /*boolean bContinue = true;

    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
       
        ASResultSet rs = null;
        //ʵ�����û�
        ASUser CurUser = ASUser.getUser(pUserID,Sqlca);
        //��ͬ�ڲ��Ǳ�־Ϊδ���ȣ��ҵ�ǰ�û�Ϊ��Ͻ����ʱ������ά������
        rs = Sqlca.getASResultSet(new SqlObject("select ReinforceFlag from BUSINESS_CONTRACT where SerialNo=:SerialNo and ManageOrgID like :OrgID")
        		.setParameter("SerialNo", pObjectNo).setParameter("OrgID", CurUser.getOrgID()+"%"));
        if (rs.next()){
        	String sReinforceFlag = rs.getString("ReinforceFlag");
        	if (sReinforceFlag==null) sReinforceFlag="";
        	if (sReinforceFlag.equals("010")){ //���Ǳ�־ReinforceFlag��010��δ���ǣ�020���Ѳ��ǣ�
        		sReturn = "All";
        		bContinue = false;
        	}
        }
        rs.getStatement().close();
        //������ܼ������򷵻ؽ��
        if(!bContinue){	
        	return sReturn;
        }
        
        //��ͬΪ�ۺ�����Э��ʱ������Ѿ��������������ҵ������ռ�ã�Ҳ���ܽ����޸�
        String sBusinessType = "";
        rs = Sqlca.getASResultSet(new SqlObject("select BusinessType from BUSINESS_CONTRACT where SerialNo=:SerialNo ").setParameter("SerialNo", pObjectNo));
        if (rs.next()) {
        	sBusinessType = rs.getString("BusinessType");
        	if(sBusinessType == null) sBusinessType = "";
        }
        rs.getStatement().close();
        
        if(sBusinessType.length() >=1 && sBusinessType.substring(0,1).equals("3")){ //���
        	rs = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_APPLY where CreditAggreement = :CreditAggreement").setParameter("CreditAggreement", pObjectNo));
        	if (!rs.next()){        		
    			sReturn = "All";
    			bContinue = false;
        	}
        	rs.getStatement().close();
        	//������ܼ������򷵻ؽ��
        	if(!bContinue){
        		return sReturn;
        	}
        }else{        
	        //��ͬ�ܻ��ˡ��Ǽ��ˡ���ȫ�ܻ����ں�ͬû������Ŵ��Һ�ͬ����û�н��ʱ����ά������
	        String sSql = "select SerialNo from BUSINESS_CONTRACT where SerialNo=:SerialNo and (InputUserID = :InputUserID or ManageUserID = :ManageUserID) and (PigeonholeDate is null or PigeonholeDate=' ')";
	        rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("SerialNo", pObjectNo).setParameter("InputUserID", pUserID).setParameter("ManageUserID", pUserID));
	        if (rs.next()){        	
	        	rs.getStatement().close();
	        	rs = Sqlca.getASResultSet(new SqlObject("select SerialNo from BUSINESS_PUTOUT where ContractSerialNo = :ContractSerialNo").setParameter("ContractSerialNo", pObjectNo));
	        	if(!rs.next()){
	        		rs.getStatement().close();
	        		rs = Sqlca.getASResultSet(new SqlObject("select RelativeSerialNo2  from BUSINESS_DUEBILL where RelativeSerialNo2=:RelativeSerialNo2").setParameter("RelativeSerialNo2", pObjectNo));
	        		if (!rs.next()){
	        			sReturn = "All";
	        			bContinue = false;
	        			return sReturn;
	        		}
        			rs.getStatement().close();
        			//������ܼ������򷵻ؽ��
        			if(!bContinue){
        				return sReturn;
        			}
	        	}else{
	        		rs.getStatement().close();
	        	}
	        }else{
	        	rs.getStatement().close();
	        }
        }*/
        //String sPhaseNo = Sqlca.getString(new SqlObject("Select PhaseNo From Flow_Object Where Objectno=:ObjectNo and UserID =:UserID").setParameter("ObjectNo", pObjectNo).setParameter("UserID", pUserID));
        //if ("0010".equals(sPhaseNo)) sReturn = "All";
        // �����ͬ״̬Ϊ�Ѿ�ǩ�� ֻ��
        String sContractStatus = Sqlca.getString(new SqlObject("SELECT CONTRACTSTATUS from BUSINESS_CONTRACT where SERIALNO=:ObjectNo").setParameter("ObjectNo", pObjectNo));
        if ("060".equals(sContractStatus)) sReturn = "All";
        
        return sReturn;
    }
	
	/**
	 * ���ʶ���Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
	public String rightOfPutOut(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //���ʵǼ��˿����ڳ���δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
    }
	
	/**
	 * ֧������Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
	public String rightOfPayment(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception
	{
		String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //֧���Ǽ��˿�����֧��δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", pObjectType).setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
	}
	
	//������ӻ��޸�-start
	/**
	 * ���׶���Ȩ���ж�
	 * @param ������
	 * 	<li>Sqlca�����ݿ�����</li>
	 * 	<li>pObjectType ��������</li>
	 * 	<li>pObjectNo ������</li>
	 * 	<li>pUserID �û�ID</li>
	 * 	<li>pViewID ��ͼID
	 * 		000����ALL,
	 * 		��Ϊ001����ReadOnly,
	 * 		001�����û���ɫ��Ϣά��Ȩ�ж�
	 * 	</li>
	 */
	public String rightOfTrans(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
    	String sPreChk = rightPreCheck(Sqlca,pViewID,pUserID);
    	//�Ȼ�ȡԤ�ȴ����������Ԥ�ȴ�������ΪContinue,�򷵻�Ȩ�ޣ������������
        if(!sPreChk.equals("Continue")){	
        	return sPreChk;
        }
        //���ʵǼ��˿����ڳ���δ�ύPhaseNo='0010'���˻ز������Ͻ׶�PhaseNo='3000'��������ά��
        String sSql = "select ObjectNo from FLOW_OBJECT where ObjectType = :ObjectType and ObjectNo = :ObjectNo and UserId = :UserId and  (PhaseNo = '0010' or PhaseNo = '3000')";
        ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sSql).setParameter("ObjectType", "TransactionApply").setParameter("ObjectNo", pObjectNo).setParameter("UserId", pUserID));
        if (rs.next()){
        	sReturn = "All";
        }
        rs.getStatement().close();
       
        return sReturn;
    }
	//������ӻ��޸�-end
	
	/**
	 * Ȩ��Ԥ�ȴ���
	 * <p>
	 * <li>pViewID��Ϊ000 ��ֱ�ӷ���ALL</li>
	 * <li>pViewID��Ϊ001 ִ�к���ļ�飬Continue</li>
	 * <li>pViewID����Ϊ001 ִ�к���ļ�飬����ReadOnly</li>
	 * </p>
	 * <p>
	 * �����ǰ�û�Ϊ�����û��򷵻�ALL,����Continue
	 * </p>
	 * @param Sqlca
	 * @param pViewID
	 * @param pUserID
	 * @return
	 * @throws Exception 
	 * @throws SQLException 
	 */
	private String rightPreCheck(Transaction Sqlca,String pViewID,String pUserID) throws SQLException, Exception{
        String sReturn = "Continue";
        
		if (pViewID.equals("000")){
			sReturn = "All";
			return sReturn;
		}else if (!pViewID.equals("001")){
			sReturn = "ReadOnly";
			return sReturn;
		}
        ASResultSet rs = null;

        //����ǳ����û�����ֱ�ӷ�������Ȩ��
        rs = Sqlca.getASResultSet(new SqlObject("select RoleID from USER_ROLE where RoleID = '000' and UserID = :UserID").setParameter("UserID", pUserID));
        if (rs.next()) {
        	sReturn = "All";
        }
        rs.getStatement().close();
        rs = null;
	    return sReturn;
	}
}
