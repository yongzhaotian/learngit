package com.amarsoft.app.billions;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.amarsoft.app.util.DBKeyUtils;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.app.als.rating.model.ResCustomerExcelVO;
import com.amarsoft.are.ARE;

/**
 * �����ֽ����ͻ���������������
 * @author fangxiaoqing
 *
 */
public class ResCashExcelImport {
	private String filePath; // �ļ�·��
	private String userid; //������
	private String orgid; //���벿��
	private String inputdate; //����ʱ��

	public String getFilePath() {
		return filePath;
	}
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String getUserid() {
		return userid;
	}
	public void setUserid(String userid) {
		this.userid = userid;
	}
	public String getOrgid() {
		return orgid;
	}
	public void setOrgid(String orgid) {
		this.orgid = orgid;
	}
	public String getInputdate() {
		return inputdate;
	}
	public void setInputdate(String inputdate) {
		this.inputdate = inputdate;
	}
	
	/**
	 * �����ֽ����ͻ���������
	 * @param sqlca
	 * @return
	 * @throws Exception
	 */
	public String dataImportResCash(Transaction sqlca)
			throws Exception{
		ARE.getLog().info("�����ֽ����ͻ�����������ʼ");
		
		DataExcelCommon dataExcelCommon = new DataExcelCommon(filePath);
		
		// ������ʼ������ BEGIN
		String[][] allData = dataExcelCommon.getAllData12();
		
		List<ResCustomerExcelVO> list = new ArrayList<ResCustomerExcelVO>();
		
		if(allData.length == 0){
			ARE.getLog().info("�����ֽ���ͻ�����ʧ��,xls�ļ�����Ϊ��");
			
			return "�����ֽ���ͻ�����ʧ��,xls�ļ�����Ϊ��";
		}
		
		String flag = ""; //У��ṹ��ʾ
		for(int i = 0; i < allData.length; i++){
			String[] arow = allData[i];//��ȡһ������
			
			if(StringUtils.isBlank(arow[11])){
				ARE.getLog().info("����ʧ��,xls��" + (i + 2) + "��,[���ʼʱ��]����Ϊ�գ�����");
				
				return "����ʧ��,xls��" + (i + 2) + "��,[���ʼʱ��]����Ϊ�գ�����";
			}
			
			flag =checkDate(arow[11]);
			if(flag.equals("0")){
				ARE.getLog().info("����ʧ��,xls��" + (i + 2) + "��,[���ʼʱ��]��ʽ��������");
				
				return "����ʧ��,xls��" + (i + 2) + "��,[���ʼʱ��]��ʽ��������";
			}
			
			// �����ʱ�� ��Ϊ��,��֤ʱ���ʽ,Ϊ��Ĭ��Ϊ"9999/12/31"
			if(StringUtils.isNotBlank(arow[12])){
				flag =checkDate(arow[12]);
				if(flag.equals("0")){
					ARE.getLog().info("����ʧ��,xls��" + (i + 2) + "��,[�����ʱ��]��ʽ��������");
					
					return "����ʧ��,xls��" + (i + 2) + "��,[�����ʱ��]��ʽ��������";
				}
			} else {
				arow[12] = "9999/12/31";
			}
			
			String beginTime="";
			String endTime="";
			
			if (arow[11] != null && !arow[11].equals("")) {
				if (arow[11].split("/").length > 1) {
					beginTime=arow[11].replaceAll("[/\\s:]","-");//��ʼʱ�� 
				}else{
					beginTime=arow[11];
				}
			}
			
			
			if (arow[12] != null && !arow[12].equals("")) {
				if (arow[12].split("/").length > 1) {
					endTime = arow[12].replaceAll("[/\\s:]","-");//����ʱ�� 
				}else {
					endTime = arow[12];
				}
			}
			
			java.text.DateFormat df = new java.text.SimpleDateFormat( "yyyy-MM-dd");
			java.util.Calendar c1 = java.util.Calendar.getInstance();
			java.util.Calendar c2 = java.util.Calendar.getInstance();
			c1.setTime(df.parse(beginTime));//��ʼʱ�� 
			c2.setTime(df.parse(endTime));//����ʱ�� 
			
			int result = c1.compareTo(c2);
			if (result == 0){
				ARE.getLog().info("����ʧ��,xls��" + (i + 2) + "��,���ʼʱ��������ʱ�䲻��һ�£�����");
				
				return "����ʧ��,xls��" + (i + 2) + "��,���ʼʱ��������ʱ�䲻��һ�£�����";
			}else if (result > 0){
				ARE.getLog().info("����ʧ��,xls��" + (i + 2) + "��,���ʼʱ���ڻ����ʱ��֮������");
				
				return "����ʧ��,xls��" + (i + 2) + "��,���ʼʱ���ڻ����ʱ��֮������";
			}

			//��ֵ�ͻ���ϢVO
			ResCustomerExcelVO rcvo = setResCustomerExcelVO(arow);
			
			list.add(rcvo);
		}
		
		//��ѯ��ʷ�ͻ����
		String sql = "SELECT CUSTOMERID FROM CUSTOMER_CENTER WHERE CUSTOMERNAME=:customername AND CERTID=:certid";
		
		/*//��ѯRESCASHACCESSCUSTOMER�����Ƿ�����ظ�����
		String resSql = "SELECT CUSTOMERID FROM RESCASHACCESSCUSTOMER WHERE CUSTOMERNAME=:customername AND CERTID=:certid";*/

		//�����ͻ��ؼ���Ϣ��
		String ccSql = "INSERT INTO CUSTOMER_CENTER(CUSTOMERID,CUSTOMERNAME,CERTID,CERTTYPE) VALUES (:CUSTOMERID,:CUSTOMERNAME,:CERTID,:CERTTYPE)";
		
		//�����ͻ�������Ϣ��
		String customerSql = "INSERT INTO CUSTOMER_INFO (CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,CUSTOMERTYPE,CUSTOMERNAME,CERTID) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:CUSTOMERTYPE,:CUSTOMERNAME,:CERTID)";
		
		//�����ͻ���ϸ��Ϣ��
		String indSql = "INSERT INTO IND_INFO(CUSTOMERID,CERTTYPE,INPUTORGID,INPUTUSERID,INPUTDATE,UPDATEDATE,FAMILYADD,SEX,CUSTOMERNAME,CERTID,MOBILETELEPHONE,COUNTRYSIDE,VILLAGECENTER,PLOT,ROOM) VALUES (:CUSTOMERID,:CERTTYPE,:INPUTORGID,:INPUTUSERID,:INPUTDATE,:UPDATEDATE,:FAMILYADD,:SEX,:CUSTOMERNAME,:CERTID,:MOBILETELEPHONE,:COUNTRYSIDE,:VILLAGECENTER,:PLOT,:ROOM)";

		//���������ֽ����Excel���������
		String resCustomersql = "INSERT INTO RESCASHACCESSCUSTOMER (SERIALNO,CUSTOMERID,CUSTOMERNAME,SEX,TELEPHONE,CERTID,PROVINCE,CITY,WORKADDRESS,ADDRESS,PRODUCTTYPE,PRODUCTFEATURE,EVENTNAME,EVENTDATE,EVENTENDDATE,EVENTPHASE,AMOUNTLIMIT,TOPMONTHPAYMENT,TERM,BATCHNO,INPUTDATE) "
				+ "values (:SERIALNO,:CUSTOMERID,:CUSTOMERNAME,:SEX,:TELEPHONE,:CERTID,:PROVINCE,:CITY,:WORKADDRESS,:ADDRESS,:PRODUCTTYPE,:PRODUCTFEATURE,:EVENTNAME,:EVENTDATE,:EVENTENDDATE,:EVENTPHASE,:AMOUNTLIMIT,:TOPMONTHPAYMENT,:TERM,:BATCHNO,:INPUTDATE)";
		
		//����ͻ���Ϣǰ��ɾ��RESCASHACCESSCUSTOMER���е���������
		sqlca.executeSQL(new SqlObject("DELETE FROM RESCASHACCESSCUSTOMER"));

		//�洢�Ա�,�����ֵ伯
		Map<String, String> codeMap = new HashMap<String, String>();

		//��ѯ�ֵ������[�Ա�,����]
		String codeSql = "SELECT ITEMNO, ITEMNAME FROM CODE_LIBRARY CL WHERE CL.CODENO in ('AreaCode', 'Sex') order by CODENO desc";
		
		//��ѯ�ֵ������[�Ա�,����]
		ASResultSet rs = sqlca.getASResultSet(codeSql);
		while (rs.next()) {
			codeMap.put(rs.getString("ITEMNAME"), rs.getString("ITEMNO")); 
		}
		rs.getStatement().close();
		
		int i = 1; //������
		
		//����ͻ���Ϣ
		for (Iterator<ResCustomerExcelVO> iterator = list.iterator(); iterator.hasNext();) {
			ResCustomerExcelVO resCustomerExcelVO = iterator.next();
			resCustomerExcelVO.setSerialno(DBKeyUtils.getSerialNo("RC")); // ��ȡ׼��ͻ����к�

			// У�����ݿ����Ƿ��Ѿ��иÿͻ�����
			String customerID = sqlca.getString(new SqlObject(sql)
					.setParameter("customername", resCustomerExcelVO.getCustomername())
					.setParameter("certid", resCustomerExcelVO.getCertid()));
			
			//�¿ͻ�
			if (StringUtils.isBlank(customerID)) {
				//��ȡ�¿ͻ����
				GenerateSerialNo generateSerialNo = new GenerateSerialNo();
				generateSerialNo.setTableName("IND_INFO");
				generateSerialNo.setColName("CUSTOMERID");
				customerID = generateSerialNo.getCustomerId(sqlca);//�ͻ�ID
				
				String sex = codeMap.get(resCustomerExcelVO.getSex()); //ʡ�ݳ���[�ͻ���ס��ַ]
				String familyadd = codeMap.get(resCustomerExcelVO.getFamilyadd()); //ʡ�ݳ���[�ͻ���ס��ַ]

				//�����ͻ��ؼ���Ϣ��customer_center
				sqlca.executeSQL(new SqlObject(ccSql)
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype()));
				
				//�����ͻ�������Ϣ��customer_info
				sqlca.executeSQL(new SqlObject(customerSql)
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype())
					.setParameter("INPUTORGID", resCustomerExcelVO.getInputorgid())
					.setParameter("INPUTUSERID", resCustomerExcelVO.getInputuserid())
					.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate())
					.setParameter("CUSTOMERTYPE", resCustomerExcelVO.getCustomertype())
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())); 
				
				//�����ͻ���ϸ��Ϣ��ind_info
				sqlca.executeSQL(new SqlObject(indSql)
					.setParameter("SERIALNO", resCustomerExcelVO.getSerialno())
					.setParameter("CUSTOMERID", customerID)
					.setParameter("CERTTYPE", resCustomerExcelVO.getCerttype())
					.setParameter("INPUTORGID", resCustomerExcelVO.getInputorgid())
					.setParameter("INPUTUSERID", resCustomerExcelVO.getInputuserid())
					.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate())
					.setParameter("UPDATEDATE", resCustomerExcelVO.getUpdatedate())
					.setParameter("FAMILYADD", familyadd == null ? "" :familyadd)
					.setParameter("SEX", sex == null ? "0" : sex)
					.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
					.setParameter("CERTID", resCustomerExcelVO.getCertid())
					.setParameter("MOBILETELEPHONE", resCustomerExcelVO.getMobiletelephone())
					.setParameter("COUNTRYSIDE", resCustomerExcelVO.getCountryside())
					.setParameter("VILLAGECENTER", resCustomerExcelVO.getVillagecenter())
					.setParameter("PLOT", resCustomerExcelVO.getPlot())
					.setParameter("ROOM", resCustomerExcelVO.getRoom()));

			}
			
			/*// У��rescashaccesscustomer�����Ƿ��Ѿ��иÿͻ�����
			String customerID_res = sqlca.getString(new SqlObject(resSql)
						.setParameter("customername", resCustomerExcelVO.getCustomername())
						.setParameter("certid", resCustomerExcelVO.getCertid()));
			
			//�ж��µ����excel�����Ƿ�����ظ��У�������ֻ����ǰ�����������
			if (StringUtils.isBlank(customerID_res)) {*/
			//���������ֽ����Excel���������rescashaccesscustomer
			sqlca.executeSQL(new SqlObject(resCustomersql)
				.setParameter("SERIALNO", resCustomerExcelVO.getSerialno())
				.setParameter("CUSTOMERID", customerID)
				.setParameter("CUSTOMERNAME", resCustomerExcelVO.getCustomername())
				.setParameter("SEX", resCustomerExcelVO.getSex())
				.setParameter("TELEPHONE", resCustomerExcelVO.getTelephone())
				.setParameter("CERTID", resCustomerExcelVO.getCertid())
				.setParameter("PROVINCE", resCustomerExcelVO.getProvince())
				.setParameter("CITY", resCustomerExcelVO.getCity())
				.setParameter("WORKADDRESS", resCustomerExcelVO.getWorkaddress())
				.setParameter("ADDRESS", resCustomerExcelVO.getAddress())
				.setParameter("PRODUCTTYPE", resCustomerExcelVO.getProducttype())
				.setParameter("PRODUCTFEATURE", resCustomerExcelVO.getProductfeature())
				.setParameter("EVENTNAME", resCustomerExcelVO.getEventname())
				.setParameter("EVENTDATE", resCustomerExcelVO.getEventdate())
				.setParameter("EVENTENDDATE", resCustomerExcelVO.getEventenddate())
				.setParameter("EVENTPHASE", resCustomerExcelVO.getEventphase())
				.setParameter("AMOUNTLIMIT", resCustomerExcelVO.getAmountlimit())
				.setParameter("TOPMONTHPAYMENT", resCustomerExcelVO.getTopmonthpayment())
				.setParameter("TERM", resCustomerExcelVO.getTerm())
				.setParameter("BATCHNO", resCustomerExcelVO.getBatchno())
				.setParameter("INPUTDATE", resCustomerExcelVO.getInputdate()));
			//}
			
			/*if(i % 1000 == 0){
				sqlca.commit();// �ύ����
			}
			
			i++;*/
			
			// ɾ�������ļ�·��
			File tmpFile = new File(filePath);
			if (tmpFile != null && tmpFile.isFile()) {
					tmpFile.delete();
			}
			
		}
		
		sqlca.commit(); // �ύ����
		
		ARE.getLog().info("�����ֽ����ͻ�������������");
		
		return "����ɹ�";
	}
	/*********����ֶ�����Ϊ�����ԵĺϷ��Է��� huzp ***************/
	public static String checkDate(String checkValue) throws Exception {
		String flag = "0";
		DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		Date d = null;
		if (checkValue != null && !checkValue.equals("")) {
			if (checkValue.split("/").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy/MM/dd");
			}
			if (checkValue.split("-").length > 1) {
				dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			}
		} else {
			return flag;
		}
		try {
			d = dateFormat.parse(checkValue);
		} catch (Exception e) {
			return flag;
		}
		String eL = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-9]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
		Pattern p = Pattern.compile(eL);
		Matcher m = p.matcher(checkValue);
		boolean b = m.matches();
		if (b) {
			flag="1";
			return flag;

		} else {
			flag="0";
			return flag;
		}
	}
	
	/**
	 * ��ֵ�ͻ���ϢVO
	 * @param arow
	 * @return
	 */
	private ResCustomerExcelVO setResCustomerExcelVO(String[] arow){
		ResCustomerExcelVO resCustomerExcelVO = new ResCustomerExcelVO();
		// �ͻ�����
		resCustomerExcelVO.setCustomername(arow[0]);
		// �Ա�
		resCustomerExcelVO.setSex(arow[1]);
		// ��ϵ�绰
		resCustomerExcelVO.setTelephone(arow[2]);
		// ���֤��
		resCustomerExcelVO.setCertid(arow[3]);
		// ʡ��
		resCustomerExcelVO.setProvince(arow[4]);
		// ����
		resCustomerExcelVO.setCity(arow[5]);
		// ������ַ
		resCustomerExcelVO.setWorkaddress(arow[6]);
		// ��ϵ��ַ
		resCustomerExcelVO.setAddress(arow[7]);
		// ��Ʒ����
		resCustomerExcelVO.setProducttype(arow[8]);
		// ��Ʒ����
		resCustomerExcelVO.setProductfeature(arow[9]);
		// �����
		resCustomerExcelVO.setEventname(arow[10]);
		// ���ʼʱ��
		resCustomerExcelVO.setEventdate(arow[11]);
		// �����ʱ��
		resCustomerExcelVO.setEventenddate(arow[12]);
		// ��ͻ������׶�
		resCustomerExcelVO.setEventphase(arow[13]);
		// �ֽ����������
		resCustomerExcelVO.setAmountlimit(arow[14]);
		// ����»����
		resCustomerExcelVO.setTopmonthpayment(arow[15]);
		// �ֽ�������
		resCustomerExcelVO.setTerm(arow[16]);
		// ���κ�
		resCustomerExcelVO.setBatchno(arow[17]);
		// ������
		resCustomerExcelVO.setCountryside(arow[18]);
		// �ֵ���
		resCustomerExcelVO.setVillagecenter(arow[19]);
		// С��¥��
		resCustomerExcelVO.setPlot(arow[20]);
		// ��\��Ԫ\�����
		resCustomerExcelVO.setRoom(arow[21]);
		// ʡ�ݳ���[�ͻ���ס��ַ]
		resCustomerExcelVO.setFamilyadd(arow[22]);

		//֤������
		resCustomerExcelVO.setCerttype("Ind01");
		//�ͻ�����
		resCustomerExcelVO.setCustomertype("0310");
		// ����id
		resCustomerExcelVO.setInputorgid(orgid);
		// �û����
		resCustomerExcelVO.setInputuserid(userid);
		// ����ʱ��
		resCustomerExcelVO.setInputdate(inputdate);
		// ����ʱ��
		resCustomerExcelVO.setUpdatedate("");
		// �ļ�·��
		resCustomerExcelVO.setFilePath(filePath);
		
		ARE.getLog().info(resCustomerExcelVO.toString());
		
		return resCustomerExcelVO;
	}
}
