package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * 合同的质量标注用同一个事物进行统一增删改
 * @author qizhong.chi
 * @date 2015-07-13
 *
 */
public class RunInTransaction {
	
	private String quSerialNo; // 质量等级序列号
	private String contractNo; // 合同号
	private String reSerialNo; // 质量标注记录表序列号
	private String upUserName; // 更新人
	private String errorType; //错误类型
	private String qualityTagging; //质量标注
	private String qualityFile; //文件名称
	private String currentQG; // 当前的质量等级
	
	public String getQuSerialNo() {
		return quSerialNo;
	}

	public void setQuSerialNo(String quSerialNo) {
		this.quSerialNo = quSerialNo;
	}

	public String getContractNo() {
		return contractNo;
	}

	public void setContractNo(String contractNo) {
		this.contractNo = contractNo;
	}

	public String getReSerialNo() {
		return reSerialNo;
	}

	public void setReSerialNo(String reSerialNo) {
		this.reSerialNo = reSerialNo;
	}
	
	public String getUpUserName() {
		return upUserName;
	}

	public void setUpUserName(String upUserName) {
		this.upUserName = upUserName;
	}

	public String getErrorType() {
		return errorType;
	}

	public void setErrorType(String errorType) {
		this.errorType = errorType;
	}

	public String getQualityTagging() {
		return qualityTagging;
	}

	public void setQualityTagging(String qualityTagging) {
		this.qualityTagging = qualityTagging;
	}

	public String getQualityFile() {
		return qualityFile;
	}

	public void setQualityFile(String qualityFile) {
		this.qualityFile = qualityFile;
	}

	public String getCurrentQG() {
		return currentQG;
	}

	public void setCurrentQG(String currentQG) {
		this.currentQG = currentQG;
	}

	/**
	 * 删除质量标注
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String delQualityGrade(Transaction Sqlca) {
		
		String result = "";
		ASResultSet oldRs = null; //新增前合同的质量标注结果集
		ASResultSet newRs = null; // 新增后的合同质量标注结果集
		ASResultSet currentRs = null; // 删除当前质量标注的结果集
		try{
			
			//新增前合同的质量标注结果集
			oldRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo order by c.itemattribute asc) where rownum=1 ").setParameter("contractNo", contractNo));
			String oldQualityGrade = ""; // 删除前的质量等级
			String startQualityGrade = ""; // 删除前的质量等级名称
			if(oldRs.next()){
				oldQualityGrade = oldRs.getString("qualitygrade");
				startQualityGrade = oldRs.getString("itemname");
				if(oldQualityGrade == null){
					oldQualityGrade = "";
				}
				if(startQualityGrade == null){
					startQualityGrade = "";
				}
			}
			
			// 删除当前质量标注的结果集
			currentRs = Sqlca.getASResultSet(new SqlObject("select qualitygrade from quality_grade where serialno =:quSerialNo").setParameter("quSerialNo", quSerialNo));
			if(currentRs.next()){
				currentQG = currentRs.getString("qualitygrade");
				if(currentQG == null){
					currentQG = "";
				}
			}
			String newQualityGrade = ""; // 删除后的质量标注等级
			String updateQualityGrade = ""; // 删除后的质量等级名称
			String landMarkStatus = ""; // 删除后对应的地表状态
			/**
			 * 按照合同质量标注的等级优先级
			 * 合格》关键》特办-关键》特办-非关键》非关键》特办-合格
			 */
			newRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname, c.attribute1 from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo and q.serialno<>:quSerialNo order by c.itemattribute asc) where rownum=1").setParameter("contractNo", contractNo).setParameter("quSerialNo", quSerialNo));
			if(newRs.next()){
				newQualityGrade = newRs.getString("qualitygrade");
				updateQualityGrade = newRs.getString("itemname");
				landMarkStatus = newRs.getString("attribute1");
			}
			
			@SuppressWarnings("deprecation")
			String lastCheckTime = StringFunction.getToday(); // 合同的最后检查日期
			String sql = "insert into record_data ("
					   + "recordID,"
					   + "inputTime,"
					   + "inputUser,"
					   + "qualityGrade,"
					   + "artificialNo,"
					   + "makeType,"
					   + "updateQualityGrade,"
					   + "startQualityGrade,"
					   + "errorType," 
					   + "qualityTagging," 
					   + "qualityFile ) values ( " 
					   + "'"+reSerialNo+"',"
					   + "'"+lastCheckTime+"',"
					   + "'"+upUserName+"',"
					   + "'"+currentQG+"',"
					   + "'"+contractNo+"',"
					   + "'02',"
					   + "'"+updateQualityGrade +"',"
					   + "'"+startQualityGrade+"',"
					   + "'"+errorType+"',"
					   + "'"+qualityTagging+"',"
					   + "'"+qualityFile+"')";
			SqlObject osql = new SqlObject(sql);
			int inCount = Sqlca.executeSQL(osql); // 录入质量标注记录表
			
			StringBuffer sb = new StringBuffer("update business_contract set upUserName=:upUserName,qualityGrade=:newQualityGrade,lastCheckTime=:lastCheckTime");
			if(landMarkStatus != null && landMarkStatus != ""){
				sb.append(",landmarkStatus=:landMarkStatus");
			}
			sb.append(" where serialno =:contractNo ");
			SqlObject osql1 = new SqlObject(sb.toString());
			osql1.setParameter("upUserName", upUserName);
			osql1.setParameter("newQualityGrade", newQualityGrade);
			osql1.setParameter("lastCheckTime", lastCheckTime); // 更新合同的最后检查时间
			if(landMarkStatus != null && landMarkStatus != ""){
				osql1.setParameter("landMarkStatus", landMarkStatus);
			}
			osql1.setParameter("contractNo", contractNo);
			int upCount = Sqlca.executeSQL(osql1); // 更新合同表
			
			if(inCount > 0 && upCount > 0){
				result = "success";
			}else{// 如果新增和更新失败就回滚操作
				Sqlca.rollback();
				result = "sysBusy";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			result = "sysException";
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}finally{
			try {
				if(null != oldRs){
					oldRs.getStatement().close();
				}
				if(null != newRs){
					newRs.getStatement().close();
				}
				if(null != currentRs){
					currentRs.getStatement().close();
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return result;
	}
	
	/**
	 * 新增质量标注
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String insQualityGrade(Transaction Sqlca) throws Exception {
		
		String result = "";
		ASResultSet oldRs = null; //新增前合同的质量标注结果集
		ASResultSet currentRs = null; // 新增当前质量标注的结果集
		try{
			
			//新增前合同的质量标注结果集
			oldRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname, c.itemattribute, c.attribute1 from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo order by c.itemattribute asc) where rownum=1 ").setParameter("contractNo", contractNo));
			String oldQualityGrade = ""; // 新增前的质量等级
			String startQualityGrade = ""; // 新增前的质量等级名称
			int oldLevel = 1000;	// 新增前质量等级对应的优先级
			String oldLandMarkStatus = ""; // 新增前的质量等级对应的地标状态
			if(oldRs.next()){
				oldQualityGrade = oldRs.getString("qualitygrade");
				startQualityGrade = oldRs.getString("itemname");
				oldLevel = oldRs.getInt("itemattribute");
				oldLandMarkStatus = oldRs.getString("attribute1");
				if(oldQualityGrade == null){
					oldQualityGrade = "";
				}
				if(startQualityGrade == null){
					startQualityGrade = "";
				}
				if(oldLandMarkStatus == null){
					oldLandMarkStatus = "";
				}
			}
			
			// 新增当前质量标注的结果集
			String currentQualityGrade = ""; // 当前质量等级名称
			int currentLevel = 1000; // 当前质量等级对应的优先级别
			String currentLandMarkStatus = ""; // 当前质量等级对应的地标状态
			currentRs = Sqlca.getASResultSet(new SqlObject("select t.itemno, t.itemname, t.itemattribute, t.attribute1 from code_library t where t.codeno = 'QualityGrade' and t.itemno=:currentQG").setParameter("currentQG", currentQG));
			if(currentRs.next()){
				currentQualityGrade = currentRs.getString("itemname");
				currentLevel = currentRs.getInt("itemattribute");
				currentLandMarkStatus = currentRs.getString("attribute1");
				if(currentQualityGrade == null){
					currentQualityGrade = "";
				}
				if(currentLandMarkStatus == null){
					currentLandMarkStatus = "";
				}
			}
			
			String newQualityGrade = ""; // 新增后的质量标注等级
			String updateQualityGrade = ""; // 新增后的质量等级名称
			String landMarkStatus = ""; // 新增后的地表状态
			
			//如果当前的质量等级优先级大于新增前的优先级则以新增为准
			if(currentLevel < oldLevel){
				newQualityGrade = currentQG;
				updateQualityGrade = currentQualityGrade;
				landMarkStatus = currentLandMarkStatus;
			} else { //否则以新增前的为准
				newQualityGrade = oldQualityGrade;
				updateQualityGrade = startQualityGrade;
				landMarkStatus = oldLandMarkStatus;
			}
			
			@SuppressWarnings("deprecation")
			String lastCheckTime = StringFunction.getToday(); // 合同的最后检查日期
			String sql = "insert into record_data ("
					   + "recordID,"
					   + "inputTime,"
					   + "inputUser,"
					   + "qualityGrade,"
					   + "artificialNo,"
					   + "makeType,"
					   + "updateQualityGrade,"
					   + "startQualityGrade,"
					   + "errorType," 
					   + "qualityTagging," 
					   + "qualityFile ) values ( " 
					   + "'"+reSerialNo+"',"
					   + "'"+ lastCheckTime +"',"
					   + "'"+upUserName+"',"
					   + "'"+currentQG+"',"
					   + "'"+contractNo+"',"
					   + "'01',"
					   + "'"+updateQualityGrade +"',"
					   + "'"+startQualityGrade+"',"
					   + "'"+errorType+"',"
					   + "'"+qualityTagging+"',"
					   + "'"+qualityFile+"')";
			SqlObject osql = new SqlObject(sql);
			int inCount = Sqlca.executeSQL(osql); // 录入质量标注记录表
			
			StringBuffer sb = new StringBuffer("update business_contract set upUserName=:upUserName,qualityGrade=:newQualityGrade,lastCheckTime=:lastCheckTime");
			if(landMarkStatus != null && landMarkStatus != ""){
				sb.append(",landmarkStatus=:landMarkStatus");
			}
			sb.append(" where serialno =:contractNo ");
			SqlObject osql1 = new SqlObject(sb.toString());
			osql1.setParameter("upUserName", upUserName);
			osql1.setParameter("newQualityGrade", newQualityGrade);
			osql1.setParameter("lastCheckTime", lastCheckTime); // 更新合同的最后检查时间
			if(landMarkStatus != null && landMarkStatus != ""){
				osql1.setParameter("landMarkStatus", landMarkStatus);
			}
			osql1.setParameter("contractNo", contractNo);
			int upCount = Sqlca.executeSQL(osql1); // 更新合同表
			
			if(inCount > 0 && upCount > 0){
				result = "success";
			}else{// 如果新增和更新失败就回滚操作
				Sqlca.rollback();
				result = "sysBusy";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			result = "sysException";
			try {
				Sqlca.rollback();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
		}finally{
			try {
				if(null != oldRs){
					oldRs.getStatement().close();
				}
				if(null != currentRs){
					currentRs.getStatement().close();
				}
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		return result;
	}

}
