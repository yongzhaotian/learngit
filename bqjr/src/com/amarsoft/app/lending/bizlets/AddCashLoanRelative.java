/*
		Author: rqiao
		describe:�����ֽ���ά��������Ϣ����
		modify:20141119
 */
package com.amarsoft.app.lending.bizlets;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;

public class AddCashLoanRelative {

	String ObjectNo;//Э����
	String UserID;//�û�ID
	String FilePath;//�ļ�·��
	
	public String getFilePath() {
		return FilePath;
	}

	public void setFilePath(String filePath) {
		FilePath = filePath;
	}

	public String getObjectNo() {
		return ObjectNo;
	}

	public void setObjectNo(String objectNo) {
		ObjectNo = objectNo;
	}

	public String getUserID() {
		return UserID;
	}

	public void setUserID(String userID) {
		UserID = userID;
	}

	//��ʼ����ǰ���ݵ�ǰ�����˱��ɾ����ʱ������
	public String del_CashLoan_Relatemp_before(Transaction Sqlca,String UserID) throws Exception {
		//���ݵ�ǰ������Ա���ɾ����ʱ�����ݣ�����������������JBO��ѯ������������ʴ˴�����ͨ��JBO�Ĵ���ʽ������ʱ�����������
		Sqlca.executeSQL(new SqlObject("DELETE BUSINESS_CASHLOAN_RELATEMP WHERE INPUTUSERID=:INPUTUSERID").setParameter("INPUTUSERID", UserID));
		Sqlca.commit();
		return "Success";
	}
	
	//�����������ݵ�ǰ������Ա��źͻ���ɾ����ʱ������
	public String del_CashLoan_Relatemp_after(Transaction Sqlca,String UserID,String ObjectNo) throws Exception {
		//���ݵ�ǰ������Ա��źͻ���ɾ����ʱ�����ݣ�����������������JBO��ѯ������������ʴ˴�����ͨ��JBO�Ĵ���ʽ������ʱ�����������
		Sqlca.executeSQL(new SqlObject("DELETE BUSINESS_CASHLOAN_RELATEMP WHERE INPUTUSERID=:INPUTUSERID AND EVENTSERIALNO=:EVENTSERIALNO").setParameter("INPUTUSERID", UserID).setParameter("EVENTSERIALNO", ObjectNo));
		Sqlca.commit();
		return "Success";
	}
	
	/*
	 * ��ʽ���
	 */
	public boolean isNumber(String str,int num,String Flag)
    {
		String p = "";
		if("int".equals(Flag)){
			p = "^\\d{"+num+"}$";
		}else if("double".equals(Flag)){
			p = "^[0-9]+\\.{0,1}[0-9]{0,2}$";
		}
        
		Pattern pattern=Pattern.compile(p);
        Matcher match=pattern.matcher(str);
        if(match.matches()==false){
        	return false;
        }else{
        	return true;
        }
    }
	
	public String dealExpFile(Transaction Sqlca) throws Exception{
		//��ʼ���û���Ϣ
		String sReturn =  "success";
		ASUser CurUser = ASUser.getUser(UserID, Sqlca);
		try {
			File file = new File(FilePath);
			BufferedReader fileReader = null;
			fileReader = new BufferedReader(new InputStreamReader(new FileInputStream(file),"GBK"));
			String filesLine = "";
			del_CashLoan_Relatemp_before(Sqlca,CurUser.getUserID()); //update tangyb ����֮ǰ��յ�ǰ�˸û����
			
			int i = 1; //��¼�ļ�����[�ӵ�һ�п�ʼ]
			
			while((filesLine = fileReader.readLine()) != null){
				//У���ʽ�Ƿ���ȷ
				if(!filesLine.contains("|")){
					sReturn = "faild@�ı���["+ i +"]�и�ʽ����ȷ��\n�����ı����ݸ�ʽ�Ƿ�Ϊ��\n���ͻ����|�ֽ���ϵ�б��|���ö��|�»����|��Ʒ����|�ͻ�����|��ͻ������׶Ρ�";
					break;
				}
				
				//У���ʽ�Ƿ���ȷ
				String[] fileInfos = filesLine.split("\\|"); 
				if(fileInfos.length != 7){
					sReturn = "faild@�ı���["+ i +"]�и�ʽ����ȷ��\n�����ı����ݸ�ʽ�Ƿ�Ϊ��\n���ͻ����|�ֽ���ϵ�б��|���ö��|�»����|��Ʒ����|�ͻ�����|��ͻ������׶Ρ�";
					break;
				}
				
				String customerid = fileInfos[0] == null ? "" : fileInfos[0].trim(); //�ͻ����
				String productid = fileInfos[1] == null ? "" : fileInfos[1].trim(); //�ֽ����Ʒϵ�б��
				String creditlimit = fileInfos[2] == null ? "" : fileInfos[2].trim(); //���ö��
				String monthlimit = fileInfos[3] == null ? "" : fileInfos[3].trim(); //�»����
				String productfeatures = fileInfos[4] == null ? "" : fileInfos[4].trim(); //��Ʒ����
				String customertype =fileInfos[5] == null ? "" : fileInfos[5].trim(); //�ͻ�����
				String customerphase = fileInfos[6] == null ? "" : fileInfos[6].trim(); //��ͻ������׶�
				String isrepetition = "0"; //�Ƿ��ظ�[0:��,1:��]
				
				if(!isNumber(customerid, 8, "int")){
					sReturn = "faild@���ͻ�ID����ʽ����ȷ������";
					break;
				}
				
				if(!isNumber(productid, 11, "int")){
					sReturn = "faild@���ֽ���ϵ��ID����ʽ����ȷ������";
					break;
				}
				
				if(!isNumber(creditlimit, 0, "double")){
					sReturn = "faild@�����ö�ȡ���ʽ����ȷ������";
					break;
				}
				
				if(!isNumber(monthlimit, 0, "double")){
					sReturn = "faild@���»�����ʽ����ȷ������";
					break;
				}
				
				//�����ĵ����ݲ�����ʱ��
				String sql = "INSERT INTO BUSINESS_CASHLOAN_RELATEMP (eventserialno, customerid, productid, creditlimit, monthlimit, inputuserid, productfeatures, customertype, customerphase, isrepetition) "
						+ "VALUES (:eventserialno, :customerid, :productid, :creditlimit, :monthlimit, :inputuserid, :productfeatures, :customertype, :customerphase, :isrepetition)";
				Sqlca.executeSQL(new SqlObject(sql).setParameter("eventserialno", ObjectNo)
												   .setParameter("customerid", customerid)
												   .setParameter("productid", productid)
												   .setParameter("creditlimit", Double.parseDouble(creditlimit))
												   .setParameter("monthlimit", Double.parseDouble(monthlimit))
												   .setParameter("inputuserid", CurUser.getUserID())
												   .setParameter("productfeatures", productfeatures)
												   .setParameter("customertype", customertype)
												   .setParameter("customerphase", customerphase)
												   .setParameter("isrepetition", isrepetition));
				// 1000�������ύһ�����ݿ�
				if(i % 1000 == 0){
					Sqlca.commit(); //�ύ����
				}
				
				i++;
			}
			
			if(fileReader!=null)fileReader.close();
			
			if(sReturn!=null&&sReturn.startsWith("success")){
				
				Sqlca.commit(); //�ύ����
				
				sReturn = CheckCashLoanInfo(Sqlca,ObjectNo,CurUser.getUserID());
				
				if(sReturn!=null&&sReturn.startsWith("success")){ //�����������ʵ���
					//deleteExistCustomer(Sqlca,ObjectNo); //update tangyb �ѹ����ظ��ͻ�����ɾ��
					sReturn = InsertCashLoanRelative(Sqlca,ObjectNo,CurUser.getOrgID(),CurUser.getUserID());
				}else{
					//���������⣬ɾ�����ε��������
					del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
				}
			}else{
				//���������⣬ɾ�����ε��������
				del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
			}
			
		} catch(Exception e) {
			//���������⣬ɾ�����ε��������
			del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
			e.printStackTrace();
			sReturn = "faild@�ļ�����ʧ�ܣ�";
		}
		
		return sReturn;
	}
	
	public String CheckCashLoanInfo(Transaction Sqlca,String EventSerialNo,String UserID) throws Exception{
			String Customer_SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp bcr WHERE bcr.inputuserid = :inputuserid AND bcr.eventserialno = :eventserialno AND NOT EXISTS (SELECT 1 FROM customer_info ci WHERE ci.customerid = bcr.customerid)";
			String Customer_Count = Sqlca.getString(new SqlObject(Customer_SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(Integer.parseInt(Customer_Count)>0){
				return "faild@������Ч�ͻ����ݣ�����";	
			} 
			String Product_SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp bcr WHERE bcr.inputuserid = :inputuserid AND bcr.eventserialno = :eventserialno AND NOT EXISTS (SELECT 1 FROM product_types pt WHERE  pt.producttype = '020' AND pt.productid = bcr.productid)";
			String Product_Count = Sqlca.getString(new SqlObject(Product_SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(Integer.parseInt(Product_Count)>0){
				return "faild@������Ч��Ʒϵ�У�����";
			}
			String SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp t WHERE t.inputuserid = :inputuserid AND t.eventserialno = :eventserialno GROUP BY t.customerid, t.productid HAVING COUNT(1) > 1";
			String Count = Sqlca.getString(new SqlObject(SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(null == Count) Count = "0";
			if(Integer.parseInt(Count)>0){
				return "faild@�����ļ����ظ����ݣ�����";
			}
			/**update tangyb CCS-817�޸���ʱ���Ѳ����ͻ�״̬Ϊ���ظ�start*/
//			String SQL_01 = "select count(*) from Business_CashLoan_RelaTemp BCR where exists(select 1 from Business_CashLoan_Relative BCR1 where BCR1.CustomerID = BCR.CustomerID and BCR1.EventSerialNo in(select SerialNo from Business_CashLoanevent where EventStatus <> '03')  and BCR1.EventSerialNo <> :EventSerialNo)";
//			String Count_01 = Sqlca.getString(new SqlObject(SQL_01).setParameter("EventSerialNo", ObjectNo));
//			if(Integer.parseInt(Count_01)>0){
//				return "faild@ͬһ�ͻ��������ظ�����";
//			}
			String SQL_01 = "UPDATE business_cashloan_relatemp t SET t.isrepetition = '1' WHERE t.eventserialno = :eventserialno AND t.inputuserid =:inputuserid AND EXISTS  (SELECT 1 FROM business_cashloan_relative a, business_cashloanevent b WHERE a.customerid = t.customerid AND a.eventserialno = b.serialno AND b.eventstatus IN ('01', '02'))";
			Sqlca.executeSQL(new SqlObject(SQL_01).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", UserID));
			/**end */
			return "success";
	}
	
	public String InsertCashLoanRelative(Transaction Sqlca,String EventSerialNo,String OrgID,String userid) throws Exception{
		//		String del_SQL = " delete Business_CashLoan_Relative where EventSerialNo = :EventSerialNo " ;
		//		Sqlca.executeSQL(new SqlObject(del_SQL).setParameter("EventSerialNo", EventSerialNo));
		/**update tangyb CCS-817������ظ�����������start*/
		String Insert_SQL = "Insert Into Business_CashLoan_Relative(EVENTSERIALNO,CUSTOMERID,PRODUCTID,CREDITLIMIT,MONTHLIMIT,INPUTUSERID,PRODUCTFEATURES,CUSTOMERTYPE,CUSTOMERPHASE,INPUTORGID,INPUTTIME)select EVENTSERIALNO,CUSTOMERID,PRODUCTID,CREDITLIMIT,MONTHLIMIT,INPUTUSERID, PRODUCTFEATURES,CUSTOMERTYPE,CUSTOMERPHASE,"+OrgID+",to_char(SYSDATE, 'yyyy/MM/dd') from Business_CashLoan_RelaTemp where isrepetition='0' and eventserialno = :eventserialno AND inputuserid =:inputuserid";
		Sqlca.executeSQL(new SqlObject(Insert_SQL).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", userid));
		
		Sqlca.commit();
		
		String SQL_01 = "SELECT COUNT(1) FROM Business_CashLoan_RelaTemp t WHERE t.eventserialno = :eventserialno AND t.inputuserid =:inputuserid AND t.isrepetition = '1'";
		String Count_01 = Sqlca.getString(new SqlObject(SQL_01).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", userid));
		if(Integer.parseInt(Count_01)>0){
			return "success@�ļ����пͻ��ظ��������Ƿ�鿴��";
		}
		/**end */
		return "success";
	}
	
	
	/**
	 * ������Ŀͻ����Ѵ��ڵ�ǰ��У���ôҪ�Ѹÿͻ��ӻ��������ɾ��
	 * @param Sqlca
	 * @param EventSerialno
	 * @throws Exception
	 * add by ybpan at 20150505 CCS-395
	 */
	public void deleteExistCustomer(Transaction Sqlca,String EventSerialno) throws Exception{
		String deleteCustomerSql = "DELETE FROM BUSINESS_CASHLOAN_RELATIVE BCR WHERE EVENTSERIALNO=:EVENTSERIALNO AND EXISTS (SELECT 1 FROM BUSINESS_CASHLOAN_RELATEMP BCRP WHERE BCR.CUSTOMERID  = BCRP.CUSTOMERID )";
		Sqlca.executeSQL(new SqlObject(deleteCustomerSql).setParameter("EVENTSERIALNO", EventSerialno));
		Sqlca.commit();
	}
}
