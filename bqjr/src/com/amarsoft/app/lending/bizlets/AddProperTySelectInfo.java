/*
		Author: --zhfeng
		
		describe:1 资产筛选新增
				 2 资产筛选删除
				 3 资产筛选合同文件导入
		modify:2014/10/27
 */
package com.amarsoft.app.lending.bizlets;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.core.object.ScriptObject;

public class AddProperTySelectInfo {
	private final static int THRESHOLD = 1000;
	
	String ObjectType;// 申请类型
	String ObjectNo;//协议编号
	String UserID;//用户ID
	String RelaSerialNo;//关联流水号
	String FilePath;//文件路径
	String BusinessSum;//转让金额
	
	private int batchCount=0;
	private PreparedStatement psInsert = null;
	
	public String getBusinessSum() {
		return BusinessSum;
	}

	public void setBusinessSum(String businessSum) {
		BusinessSum = businessSum;
	}

	public String getFilePath() {
		return FilePath;
	}

	public void setFilePath(String filePath) {
		FilePath = filePath;
	}

	public String getRelaSerialNo() {
		return RelaSerialNo;
	}

	public void setRelaSerialNo(String relaSerialNo) {
		RelaSerialNo = relaSerialNo;
	}


	public String getObjectType() {
		return ObjectType;
	}

	public void setObjectType(String objectType) {
		ObjectType = objectType;
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

	public String initDealInfo(Transaction Sqlca) throws Exception {
		
		String applySerialNo = "";
		ASUser CurUser = ASUser.getUser(UserID, Sqlca);
		JBOTransaction tx = JBOFactory.createJBOTransaction();
		try {
			JBOFactory f = JBOFactory.getFactory();
			BizObjectManager BizA = f.getManager("jbo.app.TRANSFER_DEAL");
			BizObjectManager BizB = f.getManager("jbo.app.TRANSFER_GROUP");
			tx.join(BizA);
			tx.join(BizB);
			BizObjectQuery query = BizA.createQuery("SerialNo=:SerialNo")
					.setParameter("SerialNo", ObjectNo);
			BizObject bo = query.getSingleResult(false);
			if (bo == null)
				throw new Exception("此协议不存在！");

			BizObject property = BizB.newObject();
			property.setAttributesValue(bo);
			property.setAttributeValue("SerialNo", null);
			property.setAttributeValue("RelativeSerialNo", bo.getAttribute("SerialNo")
					.getString());
			property.setAttributeValue("ApplyType", ObjectType);
			property.setAttributeValue("DealStatus", "01");
			property.setAttributeValue("InputuserID", CurUser.getUserID());
			property.setAttributeValue("InputorgID", CurUser.getOrgID());
			property.setAttributeValue("INPUTDATE", StringFunction.getToday());
			property.setAttributeValue("DEALSTATUS", "01");//待登记的资产
			BizB.saveObject(property);
			applySerialNo = property.getAttribute("SerialNo").getString();
			tx.commit();
		} catch (Exception e) {
			tx.rollback();
			e.printStackTrace();
		}
		
		return applySerialNo;

	}
	
	public String delSelPropertyInfo(Transaction Sqlca) throws Exception {
		try{
			String sqlContracts = " delete from  DEALCONTRACT_REATIVE where Serialno=:SerialNo" ;
			String sqlDeal ="delete from TRANSFER_GROUP where Serialno=:SerialNo";
			Sqlca.executeSQL(new SqlObject(sqlContracts).setParameter("SerialNo", ObjectNo));
			Sqlca.executeSQL(new SqlObject(sqlDeal).setParameter("SerialNo", ObjectNo));
			Sqlca.commit();
		}catch(Exception e){
			e.printStackTrace();
			Sqlca.rollback();
			return "Fail";
		}
		return "Success";
	}
	
	public String dealExpFile(Transaction Sqlca) throws Exception{
		//初始化用户信息
		String sReturn =  "success";
		ASUser CurUser = ASUser.getUser(UserID, Sqlca);
		BufferedReader fileReader = null;
		ASResultSet rs = null;
		try {
			File file = new File(FilePath);
			fileReader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
			String filesLine = "";
			String sqlInsert = "INSERT INTO DEALCONTRACT_REATIVE(DEALSERIALNO,CONTRACTSERIALNO,INPUTUSERID,INPUTORGID,INPUTTIME,SERIALNO,STATUS)values(?,?,?,?,?,?,?)";
			String sqlGetContractNos = "SELECT CONTRACTSERIALNO FROM DEALCONTRACT_REATIVE WHERE SERIALNO=:serailNO";
			List<String> existContracts = new ArrayList<String>();
			List<String> contractList = new ArrayList<String>();
			List<String> strList = new ArrayList<String>();
			StringBuffer sbContract = new StringBuffer();
			psInsert = Sqlca.getConnection().prepareStatement(sqlInsert);
			rs = Sqlca.getASResultSet(new SqlObject(sqlGetContractNos).setParameter("serailNO", RelaSerialNo));
			while(rs.next()){
				existContracts.add(rs.getString(1));
			}
			rs.getStatement().close();
			rs = null;
			int count = 0;
			while((filesLine=fileReader.readLine())!=null){
				String contractNo = filesLine.trim();
				if("".equals(contractNo)) continue;
				if(existContracts.contains(contractNo)) continue;
				if(contractNo.length()>40) {
					throw new Exception("failed@合同流水号超过定义长度");
				}
				if(contractList.contains(contractNo)){
					throw new Exception("failed@合同号【"+contractNo+"】重复");
				}
				contractList.add(contractNo);
				sbContract.append("'").append(contractNo).append("'").append(",");
				count++;
				if(count==THRESHOLD){
					strList.add(sbContract.substring(0, sbContract.length()-1));
					sbContract = new StringBuffer();
					count =0;
				}
			}
			if(sbContract.length()>0){
				strList.add(sbContract.substring(0, sbContract.length()-1));
			}
			count = 0;
			List<String> tempList = null;
			for(int i=0;i<strList.size();i++){
				rs = Sqlca.getASResultSet(new SqlObject("SELECT SERIALNO FROM BUSINESS_CONTRACT WHERE SERIALNO in("+strList.get(i)+")"));
				tempList = new ArrayList<String>();
				while(rs.next()){
					tempList.add(rs.getString(1));
				}
				rs.getStatement().close();
				if(i!=strList.size()-1){
					if(tempList.size()!=THRESHOLD){
						List<String> partList =contractList.subList(i*THRESHOLD, (i+1)*THRESHOLD);
						partList.removeAll(tempList);
						throw new Exception("failed@【"+partList.get(0)+"】合同不存在");
					}
				}else{
					if(tempList.size()!=(contractList.size()-i*THRESHOLD)){
						List<String> partList =contractList.subList(i*THRESHOLD,contractList.size());
						partList.removeAll(tempList);
						throw new Exception("failed@【"+partList.get(0)+"】合同不存在");
					}
				}
				sReturn = contractInfoCheck(Sqlca,strList.get(i));
				if(sReturn!=null&&sReturn.startsWith("failed")){
					throw new Exception(sReturn);
				}
				if(i!=strList.size()-1){
					insertContractRelative(contractList.subList(i*THRESHOLD, (i+1)*THRESHOLD),CurUser);
				}else{
					insertContractRelative(contractList.subList(i*THRESHOLD,contractList.size()),CurUser);
				}
			}
			if(batchCount>0) psInsert.executeBatch();
			
			Sqlca.commit();
			
		} catch (Exception e) {
			Sqlca.rollback();
			e.printStackTrace();
			if(e.getMessage().startsWith("failed")){
				sReturn = e.getMessage();
			}else{
				sReturn = "failed@文件导入失败！";
			}
		}finally{
			if(fileReader!=null)fileReader.close();
		}
		
		return sReturn;
	}
	
	//更新资产筛选详情中的合同金额和笔数
	public String updateSelectInfo(Transaction Sqlca) throws Exception{
		//初始化用户信息
		String sReturn =  "success";
		double balance = 0.0;
		double discount = 0.0;
		int count=0;
		String value = "";
		String sum = "";
		ASResultSet rs = null;
		try{
			String sql = " SELECT count(dr.serialno) as count,sum(nvl(al.normalbalance,0)+nvl(al.overduebalance,0)) as totalSum FROM dealcontract_reative dr,acct_loan al where al.putoutno=dr.contractserialno and dr.serialno=:SerialNo group by dr.serialno " ;
			rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", RelaSerialNo));
			
			if(rs.next()){
				balance = rs.getDouble("totalSum");
				count = rs.getInt("count");
			}
			
			if(StringX.isEmpty(BusinessSum))BusinessSum="0.0";
			//转让溢折价
			discount = (Double.parseDouble(BusinessSum)- balance)/balance;
			NumberFormat nf = NumberFormat.getInstance();
			nf.setMaximumFractionDigits(2);
			nf.setMinimumFractionDigits(2);
			sum = nf.format(balance);
			value = nf.format(discount*100);
		}catch(Exception e){
			e.printStackTrace();
			sReturn = "计算错误！";
		}finally{
			if(rs!= null && rs.getStatement()!=null){
				rs.getStatement().close();
			}
		}
		return sReturn+"@"+sum+"@"+count+"@"+value;
	}
	
	public String ComputeSum(Transaction Sqlca) throws Exception{
		ASResultSet rs = null;
		double balance = 0.0;
		int count = 0;
		String sum = "";
		try{
			String sql = " SELECT count(dr.serialno) as count,sum(nvl(al.normalbalance,0)+nvl(al.overduebalance,0)) as totalSum FROM dealcontract_reative dr,acct_loan al where al.putoutno=dr.contractserialno and dr.serialno=:SerialNo group by dr.serialno " ;
			rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", RelaSerialNo));
			
			if(rs.next()){
				balance = rs.getDouble("totalSum");
				count = rs.getInt("count");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(rs!= null && rs.getStatement()!=null){
				rs.getStatement().close();
			}
		}
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMaximumFractionDigits(2);
		nf.setMinimumFractionDigits(2);
		sum = nf.format(balance);
		
		return "success"+"@"+sum+"@"+count;
	}
	
	public String contractInfoCheck(Transaction Sqlca,String contractNos) throws Exception{
		ASResultSet rs = null;
		try{
			String sql = " SELECT DR.ContractSerialNo FROM Transfer_Group TG,Dealcontract_Reative DR WHERE DR.Serialno = TG.Serialno AND  DR.STATUS='01' AND TG.DEALSTATUS='05' AND DR.ContractSerialNo in("+contractNos+ ")" ;
			rs = Sqlca.getResultSet(new SqlObject(sql));
			if(rs.next()){
				return "failed@合同号【"+rs.getString(1)+"】已存在，不能重复导入";	
			}
			
			rs = Sqlca.getResultSet(new SqlObject(" Select serialno from business_contract where serialno in("+contractNos+") and SubmitDateTime is not null " ));
			if(rs.next()){
				return "failed@合同号【"+rs.getString(1)+"】已转让，不能再次导入";	
			}
		}catch(Exception e){
			throw e;
		}finally{
			if(rs!= null && rs.getStatement()!=null){
				rs.getStatement().close();
			}
		}
			return "success";
	}
	
	private void insertContractRelative(List<String> contractNos,ASUser curUser) throws SQLException{
		for(String contractNo : contractNos){
			psInsert.setString(1, ObjectNo);
			psInsert.setString(2, contractNo);
			psInsert.setString(3, curUser.getUserID());
			psInsert.setString(4, curUser.getOrgID());
			psInsert.setString(5, StringFunction.getTodayNow());
			psInsert.setString(6, RelaSerialNo);
			psInsert.setString(7, "01");
			psInsert.addBatch();
			batchCount++;
			if(batchCount>=THRESHOLD){
				psInsert.executeBatch();
				batchCount =0;
			}
		}
	}
	
	
	public String getAgreementInfo(Transaction Sqlca) throws Exception{
		ASResultSet rs = null;
		StringBuffer result = new StringBuffer();
		try{
			String sql = "SELECT * FROM TRANSFER_DEAL WHERE SerialNo=:SerialNo" ;
			rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("SerialNo", RelaSerialNo));
			
			if(rs.next()){
				result.append(rs.getString("SERIALNO"))//
				.append("@").append(rs.getString("RivalNo")==null?"":rs.getString("RivalNo"))//
				.append("@").append(rs.getString("ISFLAG")==null?"":rs.getString("ISFLAG"))//
				.append("@").append(rs.getString("RIVALSERIALNO")==null?"":rs.getString("RIVALSERIALNO"))//
				.append("@").append(rs.getString("RIVALNAME")==null?"":rs.getString("RIVALNAME"))//
				.append("@").append(rs.getString("CREDITMAN")==null?"":rs.getString("CREDITMAN"))//
				.append("@").append(rs.getString("TRUSTCOMPANIESSERIALNO")==null?"":rs.getString("TRUSTCOMPANIESSERIALNO"))//
				.append("@").append(rs.getString("EffectiveDate")==null?"":rs.getString("EffectiveDate"))//
				.append("@").append(rs.getString("MaturityDate")==null?"":rs.getString("MaturityDate"))//
				.append("@").append(rs.getString("INTERESTRATE")==null?"":rs.getString("INTERESTRATE"))//
				.append("@").append(rs.getString("ISTRANSFER")==null?"":rs.getString("ISTRANSFER"))//
				.append("@").append(rs.getString("TRANSFERTYPE")==null?"":rs.getString("TRANSFERTYPE"))//
				.append("@").append("01")//
				.append("@").append(rs.getString("ActualDate")==null?"":rs.getString("ActualDate"))//
				.append("@").append(rs.getString("IsRight")==null?"":rs.getString("IsRight"))//
				.append("@").append(rs.getString("AssetType")==null?"":rs.getString("AssetType"))//
				.append("@").append(rs.getString("TRANSFERRATE")==null?"":rs.getString("TRANSFERRATE"))//
				.append("@").append(rs.getString("MANAGERATE")==null?"":rs.getString("MANAGERATE"))//
				.append("@").append(rs.getString("RIGHTSMADE")==null?"":rs.getString("RIGHTSMADE"))//
				.append("@").append(rs.getString("SignDate")==null?"":rs.getString("SignDate")); //
			}
			
		}catch(Exception e){
			throw e;
		}finally{
			if(rs!= null && rs.getStatement()!=null){
				rs.getStatement().close();
			}
		}
		return result.toString();
	}
	
	public void updateGroupInfo(Transaction Sqlca) throws Exception{
		String sqlForSelect = "SELECT BRANCH,ACCOUNTNO,REMARK,COMPANYNAME,ACCOUNTNAME,RIVALOPENBANK FROM TRANSFER_DEAL WHERE SERIALNO=:serialNo";
		String sqlForUpdate ="UPDATE TRANSFER_GROUP SET BRANCH=:BRANCH,ACCOUNTNO=:ACCOUNTNO,REMARK=:REMARK,COMPANYNAME=:COMPANYNAME,ACCOUNTNAME=:ACCOUNTNAME,RELATIVESERIALNO=:RELATIVESERIALNO,RIVALOPENBANK=:RIVALOPENBANK,ISNEW='1' Where SERIALNO=:serialNo";
		String branch="",accountNo="",remark="",companyName="",accountName="",rivalOpenBank="";
		ASResultSet rs = null;
		ASUser CurUser = ASUser.getUser(UserID, Sqlca);
		try{
			rs = Sqlca.getASResultSet(new SqlObject(sqlForSelect).setParameter("SerialNo", RelaSerialNo));
			if(rs.next()){
				branch = rs.getString("BRANCH");
				accountNo = rs.getString("ACCOUNTNO");
				remark = rs.getString("REMARK");
				companyName = rs.getString("COMPANYNAME");
				accountName = rs.getString("ACCOUNTNAME");
				rivalOpenBank = rs.getString("RIVALOPENBANK");
			}
			if(null == branch) branch = "";
			if(null == accountNo) accountNo = "";
			if(null == remark) remark = "";
			if(null == companyName) companyName = "";
			if(null == accountName) accountName = "";
			if(null == rivalOpenBank) rivalOpenBank = "";
			SqlObject sqlObject = new SqlObject(sqlForUpdate);
			sqlObject.setParameter("BRANCH", branch);
			sqlObject.setParameter("ACCOUNTNO", accountNo);
			sqlObject.setParameter("REMARK", remark);
			sqlObject.setParameter("COMPANYNAME", companyName);
			sqlObject.setParameter("ACCOUNTNAME", accountName);
			sqlObject.setParameter("RELATIVESERIALNO", RelaSerialNo);
			sqlObject.setParameter("RIVALOPENBANK", rivalOpenBank);
			sqlObject.setParameter("serialNo", ObjectNo);
			Sqlca.executeSQL(sqlObject);
		}catch(Exception e){
			throw e;
		}finally{
			if(rs!= null && rs.getStatement()!=null)
				rs.getStatement().close();
		}
	}
}
