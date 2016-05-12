package com.amarsoft.app.als.image;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ImageUploadAfterLoan {
	private String sNo;
	private String sObjectNo;
	private String OVERDUE_REGISTRATION_DATE = "ORD"; //�������������ϴ����ڷ�����Ϣ
	private String NOT_IN_DEFINED_CITY = "NIDC"; //����ָ�����з�����Ϣ
	private String UPLOAD_IMAGE_ENABLED = "PASS"; //�����ϴ���������
	private String IMAGE_UPLOAD_STATUS_ENABLED = "δ�ϴ�";
	private String IMAGE_UPLOAD_STATUS_DISABLED = "�����ϴ�";
	public String getSNo() {
		return sNo;
	}

	public void setSNo(String sNo) {
		this.sNo = sNo;
	}
	
	public String getSObjectNo() {
		return sObjectNo;
	}

	public void setSObjectNo(String sObjectNo) {
		this.sObjectNo = sObjectNo;
	}
	/*
	 * ������Ʒ���ʹ����������ã���ѯ��ǰ��ͬ�Ƿ�����ϴ���������
	 */
	public String checkUploadImageEnabled(Transaction Sqlca){
		// ��ȡ��ǰ�ͻ�¼���ͬ�ŵ����ڳ�������
		String flag = "false";
		ASResultSet tmpRs = null;
		try{
			String sStoreCity = Sqlca.getString(new SqlObject("select City from Store_Info where SNo=:SNo").setParameter("SNo", sNo));
				String sStoreCityName = Sqlca.getString(new SqlObject("select ITEMNAME from CODE_LIBRARY where CODENO = 'AreaCode' and ITEMNO = :ITEMNO").setParameter("ITEMNO", sStoreCity));
				//��ȡ��ͬע��ʱ��
				String sRegistrationDate = Sqlca.getString( new SqlObject("select RegistrationDate from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
				//��ȡ��ǰ��Ʒ���������ϴ���Ӧ��Ȩ������
				String sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
			               " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
				while(sProductID.endsWith(",")){
					sProductID = sProductID.substring(0, sProductID.length()-1);
				}
				if( sProductID == null ) sProductID = " ";
				
				tmpRs = Sqlca.getASResultSet(new SqlObject("select uploadCity, uploadCity2, uploadCity3, uploadCity4, uploadCity5, uploadCity6 from product_ecm_upload where PRODUCT_TYPE_ID in ("+sProductID+")"));
				String cityDefined = ""; //���������ϴ�Ԥ��ĳ�������
				String dayLimitDefined = ""; //���������ϴ�Ԥ�����������
				StringBuffer strBuffer = new StringBuffer();
				if(tmpRs.next()){
					strBuffer.append(tmpRs.getString("uploadCity")==null?"":tmpRs.getString("uploadCity")).append(tmpRs.getString("uploadCity2")==null?"":tmpRs.getString("uploadCity2")).append(tmpRs.getString("uploadCity3")==null?"":tmpRs.getString("uploadCity3")).append(tmpRs.getString("uploadCity4")==null?"":tmpRs.getString("uploadCity4")).append(tmpRs.getString("uploadCity5")==null?"":tmpRs.getString("uploadCity5")).append(tmpRs.getString("uploadCity6")==null?"":tmpRs.getString("uploadCity6"));
				}
				cityDefined = strBuffer.toString();
				tmpRs = Sqlca.getASResultSet(new SqlObject("select uploaddaylimit from product_ecm_upload where PRODUCT_TYPE_ID in ("+sProductID+")"));
				while(tmpRs.next()){
					String tmpDayLimit = tmpRs.getString("uploaddaylimit");
					if(tmpDayLimit!=null && tmpDayLimit!="" && !dayLimitDefined.contains(tmpDayLimit)){
						tmpDayLimit+=",";
						dayLimitDefined += tmpDayLimit;
					}
				}
				int dayLimit = 0;
				if(""!=dayLimitDefined.trim()){
					dayLimit = getMaxNumber(dayLimitDefined);
				}
				
				Date sDate = new Date(sRegistrationDate);
				Date bDate = new Date();
				int dayRange = daysBetween(sDate, bDate);
				if(cityDefined.indexOf(sStoreCityName)<0){
					flag = NOT_IN_DEFINED_CITY;
				}else if (dayLimit<dayRange){
					flag = OVERDUE_REGISTRATION_DATE;
				}else if(dayLimit>dayRange && cityDefined.indexOf(sStoreCityName)!=-1){
					flag = UPLOAD_IMAGE_ENABLED;
				}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(null != tmpRs){
				try {
					tmpRs.getStatement().close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return flag;
	}
	
	/*
	 * ������Ʒ�����жϸú�ͬ�Ƿ���Ҫ�ϴ���������
	 */
	public String isNeedUploadImageAfterLoan(Transaction Sqlca){
		String uploadStatus = "";
		try{
			String sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
		               " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
			while(sProductID.endsWith(",")){
				sProductID = sProductID.substring(0, sProductID.length()-1);
			}
			if( sProductID == null || "".equals(sProductID.trim())){
				return uploadStatus;
			}
			String amount = Sqlca.getString(new SqlObject("select count(1) from product_ecm_upload where PRODUCT_TYPE_ID in ("+sProductID+")"));
			if(new Integer(amount).intValue()>0){
				uploadStatus = IMAGE_UPLOAD_STATUS_ENABLED;
			}else {
				uploadStatus = IMAGE_UPLOAD_STATUS_DISABLED;
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return uploadStatus;
	}
	/*
	 * ������Ʒ���Ͳ�ѯ����δ�ϴ��������Ϻ�ĺ�ͬ״̬
	 */
	public String getUploadStatusWhenOverdue(Transaction Sqlca){
		String sOverdueStatus = "";
		ASResultSet tmpRs = null;
		try{
			String sProductID = Sqlca.getString( new SqlObject("Select COALESCE(businesstype1,'0') || ',' || COALESCE(businesstype2,'0') || ',' || COALESCE(businesstype3,'0') as ProductID " +
			               " from business_contract where serialno = :SerialNo ").setParameter( "SerialNo", sObjectNo ) );
			while(sProductID.endsWith(",")){
				sProductID = sProductID.substring(0, sProductID.length()-1);
			}
			if( sProductID == null ) sProductID = " ";
		    tmpRs = Sqlca.getASResultSet(new SqlObject("select OVERDUESTATUS from product_ecm_upload where PRODUCT_TYPE_ID in ("+sProductID+")"));
			//�����Ʒ�����Ϳ��ܻ����ö������δ�ϴ�״̬����ͬһ��ͬ�ж����Ʒ�����ͣ���ֻȡ��һ��
			if(tmpRs.next()){
				sOverdueStatus = tmpRs.getString("OVERDUESTATUS");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				tmpRs.getStatement().close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return sOverdueStatus;
	}
	
	public static int getMaxNumber(String str){
		String[] dayStr = str.split(",");
		int maxNum = new Integer(dayStr[0]).intValue();
		for(int i = 0; i < dayStr.length; i++){
			String tmpStr = dayStr[i];
			int tmpNum = new Integer(tmpStr).intValue();
			if(tmpNum > maxNum){
				maxNum = tmpNum;
			}
		}
		return maxNum;
	}
	
	public static int daysBetween(Date smdate,Date bdate) throws ParseException     
    {     
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");   
        smdate=sdf.parse(sdf.format(smdate));   
        bdate=sdf.parse(sdf.format(bdate));   
        Calendar cal = Calendar.getInstance();     
        cal.setTime(smdate);     
        long time1 = cal.getTimeInMillis();                  
        cal.setTime(bdate);     
        long time2 = cal.getTimeInMillis();          
        long between_days=(time2-time1)/(1000*3600*24);   
             
       return Integer.parseInt(String.valueOf(between_days));            
    }  
}
