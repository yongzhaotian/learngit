package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 *  ����ͨ���ķŴ����룬����ʾģʽ�£�֧���ֶ�ת�����
 * @author syang
 * 
 */
public class TransToAfterLoan extends Bizlet {
	
	/**
	 * ��������
	 * <dt>Ŀǰϵͳ֧�ֵĶ���������</dt>
	 * <li>CreditApply ���ż���������</li>
	 * <li>ApproveApply ������������Ǽ�</li>
	 * <li>PutOutApply �Ŵ�����</li>
	 * <li>Customer ���õȼ���������</li>
	 * <li>Classify �弶��������</li>
	 * <li>Reserve ��������ֵ׼���϶�����</li>
	 * <li>SMEApply ��С��ҵ�ʸ��϶�����</li>
	 */
	private String sObjectType = "";
	/**
	 * ������
	 */
	private String sObjectNo = "";
	
	/**
	 * ���ݿ����Ӷ���
	 */
	private Transaction Sqlca = null;

	/**
	 * bizlet���
	 * @param ����˵��
	 * 		<li>ObjectType ��������</li>
	 * 		<li>ObjectNo��������</li>
	 * cbsu 2009/11/17 �����BUSINESS_DUEBILL������¼ʱ������ActualMaturity(ִ�е�����),UpdateDate(��������),
     *                 PaymentType(����֤��������),ClassifyResult(�弶������)�ĸ��ֶε�ֵ��
	 */
	public Object run(Transaction Sqlca) throws Exception{
		this.sObjectType = (String)this.getAttribute("ObjectType");
		this.sObjectNo = (String)this.getAttribute("ObjectNo");
		this.Sqlca = Sqlca; 
		//String sUserID = (String)this.getAttribute("UserID");
		//String sOrgID = (String)this.getAttribute("OrgID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";		
		//if(sUserID == null) sUserID = "";
		//if(sOrgID == null) sOrgID = "";
		String sDuebillNo ="";//��ݺ�
		try{
			sDuebillNo = DBKeyHelp.getSerialNo("BUSINESS_DUEBILL","SerialNo","",Sqlca);
			//��1�������ɽ��
			insertBusinessDuebill(sDuebillNo);
			//��2����������ˮ���¼
			insertBusinessWaste(sDuebillNo);
			//��3�������º�ͬ
			updateBusinessContract();
			//��4�������˹鵵
			updateBusinessPutout();
			
			return "1";
		}catch(Exception e){
			ARE.getLog().error("ת����������������ͣ�"+sObjectType+"�����ţ�"+sObjectNo, e);
			return "0";
		}
	}
	
	/**
	 * ���ƽ����Ϣ
	 * @throws Exception
	 */

	private void insertBusinessDuebill(String sDuebillNo) throws Exception{

	    String sSql = "";
	    ASResultSet rs = null;
		
		//�弶������
		String sClassifyResult = "";
		//����֤�������ޣ�������ȡ���Ŵ���
		String sLCtermType = "";
		//�������ڣ���ֵΪ��ǰ����
		String sUpdateDate = StringFunction.getToday();
		//�Ӻ�ͬ����ȡ���弶������������֤��������ֵ
		sSql = " Select ClassifyResult,LCtermType from BUSINESS_CONTRACT where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql);
		so.setParameter("SerialNo", sObjectNo);
		rs = Sqlca.getASResultSet(so);
		while (rs.next()) {
		    sClassifyResult = rs.getString("ClassifyResult");
		    sLCtermType = rs.getString("LCtermType");
		}
		if (sClassifyResult == null) sClassifyResult = "";
		if (sLCtermType == null) sLCtermType = "";
		
		//���õ�������֤�������޵�ֵת��Ϊ��Ӧ�����Ŵ��룬����������LCTermType
		if (!"".equals(sLCtermType)) {
		    if ("01".equals(sLCtermType)) {
		        sLCtermType = "1";
		    } else {
		        sLCtermType = "2";
		    }
		}
		
		sSql = " INSERT INTO BUSINESS_DUEBILL("
			+" SerialNO,"
			+" RelativeSerialNO1,"
			+" RelativeSerialNO2,"
			+" SubjectNO,"
			+" CustomerID,"
			+" CustomerName,"
			+" BusinessSum,"
			+" OccurDate,"
			+" OperateOrgID,"
			+" OperateUserID,"
			+" BusinessType,"
			+" BusinessCurrency,"
			+" ActualBusinessRate,"
			+" PutoutDate,"
			+" Maturity,"
			+" ActualMaturity,"
			+" NormalBalance,"
			+" Balance,"
			+" OverdueBalance,"
			+" DullBalance,"
			+" BadBalance,"
			+" UpdateDate,"
			+" ClassifyResult,"
			+" PaymentType"
			+" )"
			+" SELECT "
			+"'"+sDuebillNo+"',"
			+" SerialNO,"
			+" ContractSerialNO,"
			+" SubjectNO,"
			+" CustomerID,"
			+" CustomerName,"
			+" BusinessSum,"
			+" OccurDate,"
			+" OperateOrgID,"
			+" OperateUserID,"
			+" BusinessType,"
			+" BusinessCurrency,"
			+" BusinessRate,"
			+" PutoutDate,"
			+" Maturity,"
			+" Maturity,"
			+" BusinessSum,"
			+" BusinessSum,"
			+" 0,"
			+" 0,"
			+" 0,"
			+"'"+sUpdateDate+"',"
			+"'"+sClassifyResult+"',"
			+"'"+sLCtermType+"'"
			+" FROM BUSINESS_PUTOUT"
			+" WHERE SerialNo='"+sObjectNo+"'"
			;
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * ������ˮ��Ϣ
	 * @throws Exception
	 */
	private void insertBusinessWaste(String sDuebillNo) throws Exception{
		String sWasteBoolNo = DBKeyHelp.getSerialNo("BUSINESS_WASTEBOOK","SerialNo","",Sqlca);
		String sSql = "INSERT INTO BUSINESS_WASTEBOOK("
			+" SerialNO,"
			+" RelativeSerialNo,"
			+" RelativeContractNO,"
			+" OccurDate,"
			+" ActualdebitSum,"
			+" OccurType,"
			+" TransactionFlag,"
			+" OccurDirection,"
			+" OccurSubject,"
			+" BackType,"
			+" OrgID,"
			+" UserID"
			+")"
			+" SELECT "
			+" '"+sWasteBoolNo+"',"
			+" '"+sDuebillNo+"',"
			+" ContractSerialNO,"
			+" OccurDate,"
			+" BusinessSum,"
			+" '0',"
			+" '0',"
			+" '1',"
			+" '0',"
			+" '3001',"
			+" InputOrgID,"
			+" InputUserID"
			+" FROM BUSINESS_PUTOUT"
			+" WHERE SerialNo='"+sObjectNo+"'"
			;
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * ���³�����Ϣ
	 * @throws Exception
	 */
	private void updateBusinessPutout() throws Exception{
		String sSql = "update BUSINESS_PUTOUT set PigeonholeDate =:PigeonholeDate where SerialNo =:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("PigeonholeDate", StringFunction.getToday()).setParameter("SerialNo", sObjectNo);
		Sqlca.executeSQL(so);
	}
	
	/**
	 * ���º�ͬ��Ϣ
	 * @throws Exception 
	 */
	private void updateBusinessContract() throws Exception{
		String sSql = "select ContractSerialNo,BusinessSum from business_putout where SerialNo=:SerialNo ";
		SqlObject so = new SqlObject(sSql).setParameter("SerialNo", sObjectNo);
		ASResultSet rs = Sqlca.getResultSet(so);
		String sContractNo = "";
		double businessSum = 0.0;
		if(rs.next()){
			sContractNo = rs.getString("ContractSerialNo");
			businessSum = rs.getDouble("BusinessSum");
		}
		rs.getStatement().close();
		rs = null;
		if(sContractNo == null) sContractNo = "";
		if(!sContractNo.equals("")){
			sSql = "update BUSINESS_CONTRACT set Balance = nvl(Balance,0)+"+businessSum+" where SerialNo =:SerialNo ";
			so = new SqlObject(sSql).setParameter("SerialNo", sContractNo);
			Sqlca.executeSQL(so);
		}else{
			throw new Exception("�����쳣���˳��˼�¼��û�ҵ���غ�ͬ��Ϣ��");
		}
	}
	
}