/**
 * <p>===========================================================</p>
 * <p>��Ȩ���� 2010-2020 ��Ǫ���ڷ������޹�˾������������Ȩ��</p>
 * <p>-----------------------------------------------------------</p>
 * <p>�ⲻ��һ�������������������δ�������ǰ���¶Գ����������޸ĺ�ʹ�ã�</p> 
 * <p>������Գ���������κ���ʽ�κ�Ŀ�ĵ��ٷ���</p>
 * <p>===========================================================</p>
 * @ClassName: BaibaobagManageInfo 
 * @Description: �۱���ҵ������ 
 * @author tangyb
 * @date 2016��2��20�� ����3:39:45
 */

package com.amarsoft.app.lending.bizlets;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * �۱���ҵ������
 * @ClassName: BaibaobagManageInfo 
 * @Description: �۱���ҵ������ 
 * @author tangyb
 * @date 2016��2��20�� ����3:39:45
 */
public class BaibaobagManageInfo {
	
	/** ��ͬ���� **/
	private String serialno;

	/** �����û� **/
	private String userid;

	/** ��Ʒ����2 **/
	private String typename2;
	
	/**�ֻ�����**/
	private String mobnumber;
	
	/**��Ӧ��ID**/
	private String providerid;
	
	/**�ӱ�����**/
	private String serveyear;
	
	/**�ٱ������ͱ���**/
	private String modelno;
	
	/**�ٱ����ۼ�**/
	private String price;
	
	/**�������**/
	private String deduct;
	
	/**��Ʒ����1**/
	private String businessrange1;
	
	/**
	 * �۱�����Ʒ��ΧУ��
	 * @Title bbdBusinessCheck
	 * @Description �۱�����Ʒ��ΧУ�� CCS-1255 tangyb
	 * @return void
	 * @param Sqlca
	 * @throws Exception
	 */
	public String bbdBusinessCheck(Transaction Sqlca) throws Exception{
		ARE.getLog().info("�۱�����Ʒ��ΧУ�飺��Ʒ����1[businessrange1]=" + businessrange1);
		
		Boolean isExist = false; //�Ƿ��������
		String names = ""; //�����õ���Ʒ�������Ƽ�
		String msginfo = "" ; // ��ʾ��Ϣ
		
		if(businessrange1 == null || "".equals(businessrange1)){
			msginfo = "ѡ��۱���������Ʒ����1������Ϊ��";
		} else{
			String sql = "select businessrange, businessrangename from bbd_treasurebag_business where status = '1'";
			ASResultSet rs  = Sqlca.getASResultSet(new SqlObject(sql));
			
			while (rs.next()) {
				String businessrange = rs.getString("businessrange"); //��Ʒ�������
				if("".equals(names))
					names = rs.getString("businessrangename"); //��Ʒ�������Ƽ�
				else 
					names = names + "," + rs.getString("businessrangename"); //��Ʒ�������Ƽ�
				
				//У����Ʒ����1�Ƿ�����
				if(businessrange1.equals(businessrange)) {
					isExist = true;
					break;
				}
			}
			
			if(!isExist){
				msginfo = "ѡ��۱���������Ʒ����1������Ϊ["+names+"]֮����һ";
			}
		}
		return msginfo;
	}
	
	/**
	 * �ֻ������ظ���֤
	 * @Title bbdBusinessCheck
	 * @Description �ֻ������ظ���֤ CCS-1255 tangyb
	 * @return void
	 * @param Sqlca
	 * @throws Exception
	 */
	public String mobnumberCheck(Transaction Sqlca) throws Exception{
		ARE.getLog().info("�ֻ������ظ���֤����ͬ���[serialno]=" + serialno + ",��Ʒ����1[mobnumber]=" + mobnumber);
		
		String msginfo = "" ; // ��ʾ��Ϣ
		
		if(mobnumber == null || "".equals(mobnumber)){
			msginfo = "ѡ��۱��������ֻ����š�����Ϊ��";
		} else{
			String sql = "SELECT COUNT(1) isapply FROM bbd_treasurebag_info bb, business_contract bc "
						+ "WHERE bb.serialno = bc.serialno AND bb.serialno <> '" + serialno + "' "
						+ "AND bb.mobile_serial_number = '" + mobnumber + "' "
						+ "AND bc.contractstatus not in ('010', '030', '040', '100', '120', '170', '200', '210', '240') ";
			String isapply = Sqlca.getString(new SqlObject(sql));
			
			if (Integer.parseInt(isapply) > 0) {
				msginfo = "�ֻ�����[" + mobnumber + "]�ѹ�����۱����������ظ����� ";
			}
		}
		
		ARE.getLog().info("�ֻ������ظ���֤msginfo=" + msginfo);
		return msginfo;
	}

	/**
	 * 
	 * �����ͬ�����۱�����Ϣ
	 * @Title saveBbdInfo
	 * @Description CCS-1255 �����ͬ�����۱�����Ϣ tangyb
	 * @return String
	 * @param Sqlca
	 */
	public String saveBbdInfo(Transaction Sqlca){
		try {
			ARE.getLog().info("�����ͬ�����۱�����Ϣ��" + toString());
			
			String selectSql = "select count(1) from bbd_treasurebag_info t where t.serialno = :serialno";
			
			String insertSql = "INSERT INTO bbd_treasurebag_info (serialno, mobile_serial_number, provider_id, modelno, price, deduct, serveyear, inputuser, inputtime) "
					+ "VALUES (:serialno, :mobnumber, :providerid, :modelno, :price, :deduct, :serveyear, :userid, :time)";
			
			String updateSql = "update bbd_treasurebag_info set mobile_serial_number=:mobnumber,provider_id=:providerid,modelno=:modelno,"
					+ "price=:price,deduct=:deduct,serveyear=:serveyear,updateuser=:userid,updatetime=:time,lastdealdate=sysdate where serialno=:serialno";
			
			String deleteSql = "delete bbd_treasurebag_info where serialno = :serialno";
			
			String time = getTime(); //��ȡ��ǰʱ��
			
			//��ѯ�ñʺ�ͬ�Ƿ���ڰ۱�����Ϣ
			String num = Sqlca.getString(new SqlObject(selectSql).setParameter("serialno", serialno));
			if("0".equals(num)){ //������
				if("2015061500000017".equals(typename2)){ //�û�ѡ��۱�������2015061500000017[�۱���]
					Sqlca.executeSQL(new SqlObject(insertSql).setParameter("serialno", serialno)
							.setParameter("mobnumber", mobnumber)
							.setParameter("providerid", providerid)
							.setParameter("modelno", modelno)
							.setParameter("price", price)
							.setParameter("deduct", deduct)
							.setParameter("serveyear", serveyear)
							.setParameter("userid", userid)
							.setParameter("time", time)); //�����۱�����Ϣ
				}
			}else{ //����
				if("2015061500000017".equals(typename2)){ //�û�ѡ��۱�������2015061500000017[�۱���]
					Sqlca.executeSQL(new SqlObject(updateSql)
							.setParameter("mobnumber", mobnumber)
							.setParameter("providerid", providerid)
							.setParameter("modelno", modelno)
							.setParameter("price", price)
							.setParameter("deduct", deduct)
							.setParameter("serveyear", serveyear)
							.setParameter("userid", userid)
							.setParameter("time", time)
							.setParameter("serialno", serialno)); //�޸İ۱�����Ϣ
				} else {  //�û�δѡ��۱�������
					Sqlca.executeSQL(new SqlObject(deleteSql).setParameter("serialno", serialno)); //ɾ���۱�����Ϣ
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return "Error";
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		}
		return "";
	}
	
	/**
	 * ��ȡ��ǰʱ���ַ���
	 * @Title getTime
	 * @Description ��ȡ��ǰʱ���ַ���
	 * @return String "yyyy/MM/dd HH:mm:ss"��ʽ�������ַ���
	 */
	private String getTime() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

		return formatter.format(new Date());
	}

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getUserid() {
		return userid;
	}

	public void setUserid(String userid) {
		this.userid = userid;
	}

	public String getTypename2() {
		return typename2;
	}

	public void setTypename2(String typename2) {
		this.typename2 = typename2;
	}

	public String getMobnumber() {
		return mobnumber;
	}

	public void setMobnumber(String mobnumber) {
		this.mobnumber = mobnumber;
	}

	public String getProviderid() {
		return providerid;
	}

	public void setProviderid(String providerid) {
		this.providerid = providerid;
	}

	public String getServeyear() {
		return serveyear;
	}

	public void setServeyear(String serveyear) {
		this.serveyear = serveyear;
	}

	public String getModelno() {
		return modelno;
	}

	public void setModelno(String modelno) {
		this.modelno = modelno;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public String getDeduct() {
		return deduct;
	}

	public void setDeduct(String deduct) {
		this.deduct = deduct;
	}

	public String getBusinessrange1() {
		return businessrange1;
	}

	public void setBusinessrange1(String businessrange1) {
		this.businessrange1 = businessrange1;
	}
	
	public String toString() {
		return "BaibaobagManageInfo [serialno=" + serialno + ", userid="
				+ userid + ", typename2=" + typename2 + ", mobnumber="
				+ mobnumber + ", providerid=" + providerid + ", serveyear="
				+ serveyear + ", modelno=" + modelno + ", price=" + price
				+ ", deduct=" + deduct + ", businessrange1=" + businessrange1
				+ "]";
	}
}
