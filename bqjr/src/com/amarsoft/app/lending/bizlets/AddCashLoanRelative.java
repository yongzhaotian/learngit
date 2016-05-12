/*
		Author: rqiao
		describe:交叉现金贷活动维护关联信息导入
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

	String ObjectNo;//协议编号
	String UserID;//用户ID
	String FilePath;//文件路径
	
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

	//开始处理前根据当前操作人编号删除临时表数据
	public String del_CashLoan_Relatemp_before(Transaction Sqlca,String UserID) throws Exception {
		//根据当前操作人员编号删除临时表数据（过大的数据量会造成JBO查询结果集崩溃，故此处不再通过JBO的处理方式进行临时表的数据清理）
		Sqlca.executeSQL(new SqlObject("DELETE BUSINESS_CASHLOAN_RELATEMP WHERE INPUTUSERID=:INPUTUSERID").setParameter("INPUTUSERID", UserID));
		Sqlca.commit();
		return "Success";
	}
	
	//处理结束后根据当前操作人员编号和活动编号删除临时表数据
	public String del_CashLoan_Relatemp_after(Transaction Sqlca,String UserID,String ObjectNo) throws Exception {
		//根据当前操作人员编号和活动编号删除临时表数据（过大的数据量会造成JBO查询结果集崩溃，故此处不再通过JBO的处理方式进行临时表的数据清理）
		Sqlca.executeSQL(new SqlObject("DELETE BUSINESS_CASHLOAN_RELATEMP WHERE INPUTUSERID=:INPUTUSERID AND EVENTSERIALNO=:EVENTSERIALNO").setParameter("INPUTUSERID", UserID).setParameter("EVENTSERIALNO", ObjectNo));
		Sqlca.commit();
		return "Success";
	}
	
	/*
	 * 格式检查
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
		//初始化用户信息
		String sReturn =  "success";
		ASUser CurUser = ASUser.getUser(UserID, Sqlca);
		try {
			File file = new File(FilePath);
			BufferedReader fileReader = null;
			fileReader = new BufferedReader(new InputStreamReader(new FileInputStream(file),"GBK"));
			String filesLine = "";
			del_CashLoan_Relatemp_before(Sqlca,CurUser.getUserID()); //update tangyb 导入之前清空当前人该活动数据
			
			int i = 1; //记录文件行数[从第一行开始]
			
			while((filesLine = fileReader.readLine()) != null){
				//校验格式是否正确
				if(!filesLine.contains("|")){
					sReturn = "faild@文本第["+ i +"]行格式不正确。\n请检查文本内容格式是否为：\n【客户编号|现金贷活动系列编号|信用额度|月还款额|产品特征|客户类型|活动客户所属阶段】";
					break;
				}
				
				//校验格式是否正确
				String[] fileInfos = filesLine.split("\\|"); 
				if(fileInfos.length != 7){
					sReturn = "faild@文本第["+ i +"]行格式不正确。\n请检查文本内容格式是否为：\n【客户编号|现金贷活动系列编号|信用额度|月还款额|产品特征|客户类型|活动客户所属阶段】";
					break;
				}
				
				String customerid = fileInfos[0] == null ? "" : fileInfos[0].trim(); //客户编号
				String productid = fileInfos[1] == null ? "" : fileInfos[1].trim(); //现金贷产品系列编号
				String creditlimit = fileInfos[2] == null ? "" : fileInfos[2].trim(); //信用额度
				String monthlimit = fileInfos[3] == null ? "" : fileInfos[3].trim(); //月还款额
				String productfeatures = fileInfos[4] == null ? "" : fileInfos[4].trim(); //产品特征
				String customertype =fileInfos[5] == null ? "" : fileInfos[5].trim(); //客户类型
				String customerphase = fileInfos[6] == null ? "" : fileInfos[6].trim(); //活动客户所属阶段
				String isrepetition = "0"; //是否重复[0:否,1:是]
				
				if(!isNumber(customerid, 8, "int")){
					sReturn = "faild@【客户ID】格式不正确，请检查";
					break;
				}
				
				if(!isNumber(productid, 11, "int")){
					sReturn = "faild@【现金贷活动系列ID】格式不正确，请检查";
					break;
				}
				
				if(!isNumber(creditlimit, 0, "double")){
					sReturn = "faild@【信用额度】格式不正确，请检查";
					break;
				}
				
				if(!isNumber(monthlimit, 0, "double")){
					sReturn = "faild@【月还款额】格式不正确，请检查";
					break;
				}
				
				//导入文档数据插入临时表
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
				// 1000笔数据提交一次数据库
				if(i % 1000 == 0){
					Sqlca.commit(); //提交事物
				}
				
				i++;
			}
			
			if(fileReader!=null)fileReader.close();
			
			if(sReturn!=null&&sReturn.startsWith("success")){
				
				Sqlca.commit(); //提交事物
				
				sReturn = CheckCashLoanInfo(Sqlca,ObjectNo,CurUser.getUserID());
				
				if(sReturn!=null&&sReturn.startsWith("success")){ //数据正常入库实体表
					//deleteExistCustomer(Sqlca,ObjectNo); //update tangyb 已过滤重复客户无需删除
					sReturn = InsertCashLoanRelative(Sqlca,ObjectNo,CurUser.getOrgID(),CurUser.getUserID());
				}else{
					//数据有问题，删除本次导入的数据
					del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
				}
			}else{
				//数据有问题，删除本次导入的数据
				del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
			}
			
		} catch(Exception e) {
			//数据有问题，删除本次导入的数据
			del_CashLoan_Relatemp_after(Sqlca,CurUser.getUserID(),ObjectNo);
			e.printStackTrace();
			sReturn = "faild@文件导入失败！";
		}
		
		return sReturn;
	}
	
	public String CheckCashLoanInfo(Transaction Sqlca,String EventSerialNo,String UserID) throws Exception{
			String Customer_SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp bcr WHERE bcr.inputuserid = :inputuserid AND bcr.eventserialno = :eventserialno AND NOT EXISTS (SELECT 1 FROM customer_info ci WHERE ci.customerid = bcr.customerid)";
			String Customer_Count = Sqlca.getString(new SqlObject(Customer_SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(Integer.parseInt(Customer_Count)>0){
				return "faild@存在无效客户数据，请检查";	
			} 
			String Product_SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp bcr WHERE bcr.inputuserid = :inputuserid AND bcr.eventserialno = :eventserialno AND NOT EXISTS (SELECT 1 FROM product_types pt WHERE  pt.producttype = '020' AND pt.productid = bcr.productid)";
			String Product_Count = Sqlca.getString(new SqlObject(Product_SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(Integer.parseInt(Product_Count)>0){
				return "faild@存在无效产品系列，请检查";
			}
			String SQL = "SELECT COUNT(1) FROM business_cashloan_relatemp t WHERE t.inputuserid = :inputuserid AND t.eventserialno = :eventserialno GROUP BY t.customerid, t.productid HAVING COUNT(1) > 1";
			String Count = Sqlca.getString(new SqlObject(SQL).setParameter("inputuserid", UserID).setParameter("eventserialno", EventSerialNo));
			if(null == Count) Count = "0";
			if(Integer.parseInt(Count)>0){
				return "faild@数据文件有重复数据，请检查";
			}
			/**update tangyb CCS-817修改临时表已参与活动客户状态为已重复start*/
//			String SQL_01 = "select count(*) from Business_CashLoan_RelaTemp BCR where exists(select 1 from Business_CashLoan_Relative BCR1 where BCR1.CustomerID = BCR.CustomerID and BCR1.EventSerialNo in(select SerialNo from Business_CashLoanevent where EventStatus <> '03')  and BCR1.EventSerialNo <> :EventSerialNo)";
//			String Count_01 = Sqlca.getString(new SqlObject(SQL_01).setParameter("EventSerialNo", ObjectNo));
//			if(Integer.parseInt(Count_01)>0){
//				return "faild@同一客户不允许重复参与活动";
//			}
			String SQL_01 = "UPDATE business_cashloan_relatemp t SET t.isrepetition = '1' WHERE t.eventserialno = :eventserialno AND t.inputuserid =:inputuserid AND EXISTS  (SELECT 1 FROM business_cashloan_relative a, business_cashloanevent b WHERE a.customerid = t.customerid AND a.eventserialno = b.serialno AND b.eventstatus IN ('01', '02'))";
			Sqlca.executeSQL(new SqlObject(SQL_01).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", UserID));
			/**end */
			return "success";
	}
	
	public String InsertCashLoanRelative(Transaction Sqlca,String EventSerialNo,String OrgID,String userid) throws Exception{
		//		String del_SQL = " delete Business_CashLoan_Relative where EventSerialNo = :EventSerialNo " ;
		//		Sqlca.executeSQL(new SqlObject(del_SQL).setParameter("EventSerialNo", EventSerialNo));
		/**update tangyb CCS-817导入非重复参与活动的数据start*/
		String Insert_SQL = "Insert Into Business_CashLoan_Relative(EVENTSERIALNO,CUSTOMERID,PRODUCTID,CREDITLIMIT,MONTHLIMIT,INPUTUSERID,PRODUCTFEATURES,CUSTOMERTYPE,CUSTOMERPHASE,INPUTORGID,INPUTTIME)select EVENTSERIALNO,CUSTOMERID,PRODUCTID,CREDITLIMIT,MONTHLIMIT,INPUTUSERID, PRODUCTFEATURES,CUSTOMERTYPE,CUSTOMERPHASE,"+OrgID+",to_char(SYSDATE, 'yyyy/MM/dd') from Business_CashLoan_RelaTemp where isrepetition='0' and eventserialno = :eventserialno AND inputuserid =:inputuserid";
		Sqlca.executeSQL(new SqlObject(Insert_SQL).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", userid));
		
		Sqlca.commit();
		
		String SQL_01 = "SELECT COUNT(1) FROM Business_CashLoan_RelaTemp t WHERE t.eventserialno = :eventserialno AND t.inputuserid =:inputuserid AND t.isrepetition = '1'";
		String Count_01 = Sqlca.getString(new SqlObject(SQL_01).setParameter("eventserialno", EventSerialNo).setParameter("inputuserid", userid));
		if(Integer.parseInt(Count_01)>0){
			return "success@文件中有客户重复参与活动，是否查看？";
		}
		/**end */
		return "success";
	}
	
	
	/**
	 * 若导入的客户中已存在当前活动中，那么要把该客户从活动关联表中删除
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
