package com.amarsoft.app.billions;

import java.sql.SQLException;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * ��ͬ��������ע��ͬһ���������ͳһ��ɾ��
 * @author qizhong.chi
 * @date 2015-07-13
 *
 */
public class RunInTransaction {
	
	private String quSerialNo; // �����ȼ����к�
	private String contractNo; // ��ͬ��
	private String reSerialNo; // ������ע��¼�����к�
	private String upUserName; // ������
	private String errorType; //��������
	private String qualityTagging; //������ע
	private String qualityFile; //�ļ�����
	private String currentQG; // ��ǰ�������ȼ�
	
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
	 * ɾ��������ע
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String delQualityGrade(Transaction Sqlca) {
		
		String result = "";
		ASResultSet oldRs = null; //����ǰ��ͬ��������ע�����
		ASResultSet newRs = null; // ������ĺ�ͬ������ע�����
		ASResultSet currentRs = null; // ɾ����ǰ������ע�Ľ����
		try{
			
			//����ǰ��ͬ��������ע�����
			oldRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo order by c.itemattribute asc) where rownum=1 ").setParameter("contractNo", contractNo));
			String oldQualityGrade = ""; // ɾ��ǰ�������ȼ�
			String startQualityGrade = ""; // ɾ��ǰ�������ȼ�����
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
			
			// ɾ����ǰ������ע�Ľ����
			currentRs = Sqlca.getASResultSet(new SqlObject("select qualitygrade from quality_grade where serialno =:quSerialNo").setParameter("quSerialNo", quSerialNo));
			if(currentRs.next()){
				currentQG = currentRs.getString("qualitygrade");
				if(currentQG == null){
					currentQG = "";
				}
			}
			String newQualityGrade = ""; // ɾ�����������ע�ȼ�
			String updateQualityGrade = ""; // ɾ����������ȼ�����
			String landMarkStatus = ""; // ɾ�����Ӧ�ĵر�״̬
			/**
			 * ���պ�ͬ������ע�ĵȼ����ȼ�
			 * �ϸ񡷹ؼ����ذ�-�ؼ����ذ�-�ǹؼ����ǹؼ����ذ�-�ϸ�
			 */
			newRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname, c.attribute1 from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo and q.serialno<>:quSerialNo order by c.itemattribute asc) where rownum=1").setParameter("contractNo", contractNo).setParameter("quSerialNo", quSerialNo));
			if(newRs.next()){
				newQualityGrade = newRs.getString("qualitygrade");
				updateQualityGrade = newRs.getString("itemname");
				landMarkStatus = newRs.getString("attribute1");
			}
			
			@SuppressWarnings("deprecation")
			String lastCheckTime = StringFunction.getToday(); // ��ͬ�����������
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
			int inCount = Sqlca.executeSQL(osql); // ¼��������ע��¼��
			
			StringBuffer sb = new StringBuffer("update business_contract set upUserName=:upUserName,qualityGrade=:newQualityGrade,lastCheckTime=:lastCheckTime");
			if(landMarkStatus != null && landMarkStatus != ""){
				sb.append(",landmarkStatus=:landMarkStatus");
			}
			sb.append(" where serialno =:contractNo ");
			SqlObject osql1 = new SqlObject(sb.toString());
			osql1.setParameter("upUserName", upUserName);
			osql1.setParameter("newQualityGrade", newQualityGrade);
			osql1.setParameter("lastCheckTime", lastCheckTime); // ���º�ͬ�������ʱ��
			if(landMarkStatus != null && landMarkStatus != ""){
				osql1.setParameter("landMarkStatus", landMarkStatus);
			}
			osql1.setParameter("contractNo", contractNo);
			int upCount = Sqlca.executeSQL(osql1); // ���º�ͬ��
			
			if(inCount > 0 && upCount > 0){
				result = "success";
			}else{// ��������͸���ʧ�ܾͻع�����
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
	 * ����������ע
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	public String insQualityGrade(Transaction Sqlca) throws Exception {
		
		String result = "";
		ASResultSet oldRs = null; //����ǰ��ͬ��������ע�����
		ASResultSet currentRs = null; // ������ǰ������ע�Ľ����
		try{
			
			//����ǰ��ͬ��������ע�����
			oldRs = Sqlca.getASResultSet(new SqlObject("select * from (select q.qualitygrade, c.itemname, c.itemattribute, c.attribute1 from quality_grade q, code_library c where q.qualitygrade = c.itemno and c.codeno = 'QualityGrade' and c.isinuse = '1' and q.artificialno = :contractNo order by c.itemattribute asc) where rownum=1 ").setParameter("contractNo", contractNo));
			String oldQualityGrade = ""; // ����ǰ�������ȼ�
			String startQualityGrade = ""; // ����ǰ�������ȼ�����
			int oldLevel = 1000;	// ����ǰ�����ȼ���Ӧ�����ȼ�
			String oldLandMarkStatus = ""; // ����ǰ�������ȼ���Ӧ�ĵر�״̬
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
			
			// ������ǰ������ע�Ľ����
			String currentQualityGrade = ""; // ��ǰ�����ȼ�����
			int currentLevel = 1000; // ��ǰ�����ȼ���Ӧ�����ȼ���
			String currentLandMarkStatus = ""; // ��ǰ�����ȼ���Ӧ�ĵر�״̬
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
			
			String newQualityGrade = ""; // �������������ע�ȼ�
			String updateQualityGrade = ""; // ������������ȼ�����
			String landMarkStatus = ""; // ������ĵر�״̬
			
			//�����ǰ�������ȼ����ȼ���������ǰ�����ȼ���������Ϊ׼
			if(currentLevel < oldLevel){
				newQualityGrade = currentQG;
				updateQualityGrade = currentQualityGrade;
				landMarkStatus = currentLandMarkStatus;
			} else { //����������ǰ��Ϊ׼
				newQualityGrade = oldQualityGrade;
				updateQualityGrade = startQualityGrade;
				landMarkStatus = oldLandMarkStatus;
			}
			
			@SuppressWarnings("deprecation")
			String lastCheckTime = StringFunction.getToday(); // ��ͬ�����������
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
			int inCount = Sqlca.executeSQL(osql); // ¼��������ע��¼��
			
			StringBuffer sb = new StringBuffer("update business_contract set upUserName=:upUserName,qualityGrade=:newQualityGrade,lastCheckTime=:lastCheckTime");
			if(landMarkStatus != null && landMarkStatus != ""){
				sb.append(",landmarkStatus=:landMarkStatus");
			}
			sb.append(" where serialno =:contractNo ");
			SqlObject osql1 = new SqlObject(sb.toString());
			osql1.setParameter("upUserName", upUserName);
			osql1.setParameter("newQualityGrade", newQualityGrade);
			osql1.setParameter("lastCheckTime", lastCheckTime); // ���º�ͬ�������ʱ��
			if(landMarkStatus != null && landMarkStatus != ""){
				osql1.setParameter("landMarkStatus", landMarkStatus);
			}
			osql1.setParameter("contractNo", contractNo);
			int upCount = Sqlca.executeSQL(osql1); // ���º�ͬ��
			
			if(inCount > 0 && upCount > 0){
				result = "success";
			}else{// ��������͸���ʧ�ܾͻع�����
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
