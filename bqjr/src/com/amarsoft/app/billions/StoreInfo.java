package com.amarsoft.app.billions;

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * 
 * ��ԤԼ�ֽ�����ⲿ�����ͻ��ύ��ͬ����
 * 
 * @author tangyb
 * @date 2015-05-22
 */
public class StoreInfo {
	
	private String serialno; // ��ˮ��
	private String sno; //�ŵ���
	private String salesmanno; //������Ա

	public String getSerialno() {
		return serialno;
	}

	public void setSerialno(String serialno) {
		this.serialno = serialno;
	}

	public String getSno() {
		return sno;
	}

	public void setSno(String sno) {
		this.sno = sno;
	}

	public String getSalesmanno() {
		return salesmanno;
	}

	public void setSalesmanno(String salesmanno) {
		this.salesmanno = salesmanno;
	}

	/**
	 * ��ѯ�ŵ�ؼ���ϢΪ�յ���Ϣ
	 * @param Sqlca
	 * @return errorMes
	 * @throws Exception
	 */
	public String queryStoreKeyInfoIsNull(Transaction Sqlca) throws Exception{
		System.out.println("--------------serialno:"+serialno); //��ˮ�ţ�������
		String errorMes = ""; //������Ϣ
		
		StringBuffer sql = new StringBuffer();
		ASResultSet rs = null;
		try {
			sql.append("SELECT a.sname, ");
			sql.append("a.operatemode, ");
			sql.append("a.storetype, ");
			sql.append("a.city, ");
			sql.append("a.salesmanager, ");
			sql.append("d.superid, ");
			sql.append("d.mobiletel, ");
			sql.append("a.productcategoryname, ");
			sql.append("a.address, ");
			sql.append("a.shophours, ");
			sql.append("a.account, ");
			sql.append("a.accountname, ");
			sql.append("a.accountbank, ");
			sql.append("a.mainbusinesstype, ");
			sql.append("a.predictloanamount, ");
			sql.append("d.email, ");
			sql.append("a.reponsibleman, ");
			sql.append("a.reponsiblemanphone, ");
			sql.append("a.accountbankcity, ");
			sql.append("a.isnetbank, ");
			sql.append("b.bankname, ");
			sql.append("c.rname ");
			sql.append("FROM store_info a, ");
			sql.append("bankput_info b, ");
			sql.append("retail_info c, ");
			sql.append("user_info d ");
			sql.append("WHERE a.branchcode = b.bankno ");
			sql.append("AND a.accountbankcity = b.city ");
			sql.append("AND a.rserialno = c.serialno ");
			sql.append("AND a.salesmanager = d.userid(+) ");
			sql.append("AND a.serialno = :serialno");
			
			//���ݱ����Ż�ȡ������Ϣ
			rs= Sqlca.getASResultSet(new SqlObject(sql.toString()).setParameter("serialno", serialno));
			while(rs.next()){
				String sname = DataConvert.toString(rs.getString("SNAME")); //�ŵ����� 
				String rname = DataConvert.toString(rs.getString("RNAME")); //����������
				String operatemode = DataConvert.toString(rs.getString("OPERATEMODE")); //����ģʽ 
				String storetype = DataConvert.toString(rs.getString("STORETYPE")); //�ŵ����� 
				String shophours = DataConvert.toString(rs.getString("SHOPHOURS")); //�ŵ�Ӫҵʱ��(24ʱ��) 
				String reponsibleman = DataConvert.toString(rs.getString("REPONSIBLEMAN")); //����������
				String reponsiblemanphone = DataConvert.toString(rs.getString("REPONSIBLEMANPHONE")); //��������ϵ�绰
				String isnetbank = DataConvert.toString(rs.getString("ISNETBANK")); //�Ƿ�����̻����� 
				String accountbank = DataConvert.toString(rs.getString("ACCOUNTBANK")); //�ŵ�����˺ſ�����
				String accountbankcity = DataConvert.toString(rs.getString("ACCOUNTBANKCITY")); //�ŵ�����˺ſ���������ʡ��
				String accountname = DataConvert.toString(rs.getString("ACCOUNTNAME")); //�ŵ�����˺Ż��� 
				String productcategoryname = DataConvert.toString(rs.getString("PRODUCTCATEGORYNAME")); //�ŵ����Ʒ����
				String account = DataConvert.toString(rs.getString("ACCOUNT")); //�ŵ�����˺� 
				String bankname = DataConvert.toString(rs.getString("BANKNAME")); //�ŵ�����˺ſ���֧�� 
				String mainbusinesstype = DataConvert.toString(rs.getString("MAINBUSINESSTYPE")); //����Ʒ�� 
				String predictloanamount = DataConvert.toString(rs.getString("PREDICTLOANAMOUNT")); //Ԥ��ÿ�·��ڴ���� 
				String city = DataConvert.toString(rs.getString("CITY")); //�ŵ����ڳ��� 
				String superid = DataConvert.toString(rs.getString("SUPERID")); //���о��� 
				//String seniorSalesmanager = DataConvert.toString(rs.getString("SENIOR_SALESMANAGER")); //�߼����۾��� 
				String address = DataConvert.toString(rs.getString("ADDRESS")); //�ŵ��ַ���� 
				String salesmanager = DataConvert.toString(rs.getString("salesmanager")); //���۾��� 
				String email = DataConvert.toString(rs.getString("EMAIL")); //���۾������� 
				String mobiletel = DataConvert.toString(rs.getString("MOBILETEL")); //���۾�����ϵ��ʽ 
				
				if(sname == null || "".equals(sname)){ errorMes = errorMes + "\n�ŵ����Ʋ���Ϊ��";}
				if(rname == null || "".equals(rname)){ errorMes = errorMes + "\n���������Ʋ���Ϊ��";}
				if(operatemode == null || "".equals(operatemode)){ errorMes = errorMes + "\n����ģʽ����Ϊ��";}
				if(storetype == null || "".equals(storetype)){ errorMes = errorMes + "\n�ŵ����Ͳ���Ϊ��";}
				if(shophours == null || "".equals(shophours)){ errorMes = errorMes + "\n�ŵ�Ӫҵʱ��(24ʱ��)����Ϊ��";}
				if(reponsibleman == null || "".equals(reponsibleman)){ errorMes = errorMes + "\n��������������Ϊ��";}
				if(reponsiblemanphone == null || "".equals(reponsiblemanphone)){ errorMes = errorMes + "\n��������ϵ�绰����Ϊ��";}
				if(isnetbank == null || "".equals(isnetbank)){ errorMes = errorMes + "\n�Ƿ�����̻���������Ϊ��";}
				if(accountbank == null || "".equals(accountbank)){ errorMes = errorMes + "\n�ŵ�����˺ſ����в���Ϊ��";}
				if(accountbankcity == null || "".equals(accountbankcity)){ errorMes = errorMes + "\n�ŵ�����˺ſ���������ʡ�в���Ϊ��";}
				if(accountname == null || "".equals(accountname)){ errorMes = errorMes + "\n�ŵ�����˺Ż�������Ϊ��";}
				if(productcategoryname == null || "".equals(productcategoryname)){ errorMes = errorMes + "\n�ŵ����Ʒ���벻��Ϊ��";}
				if(account == null || "".equals(account)){ errorMes = errorMes + "\n�ŵ�����˺Ų���Ϊ��";}
				if(bankname == null || "".equals(bankname)){ errorMes = errorMes + "\n�ŵ�����˺ſ���֧�в���Ϊ��";}
				if(mainbusinesstype == null || "".equals(mainbusinesstype)){ errorMes = errorMes + "\n����Ʒ�Ʋ���Ϊ��";}
				if(predictloanamount == null || "".equals(predictloanamount)){ errorMes = errorMes + "\nԤ��ÿ�·��ڴ��������Ϊ��";}
				if(city == null || "".equals(city)){ errorMes = errorMes + "\n�ŵ����ڳ��в���Ϊ��";}
				if(superid == null || "".equals(superid)){ errorMes = errorMes + "\n���о�����Ϊ��";}
				if(address == null || "".equals(address)){ errorMes = errorMes + "\n�ŵ��ַ���岻��Ϊ��";}
				if(salesmanager == null || "".equals(salesmanager)){ errorMes = errorMes + "\n���۾�����Ϊ��";}
				if(email == null || "".equals(email)){ errorMes = errorMes + "\n���۾������䲻��Ϊ��";}
				if(mobiletel == null || "".equals(mobiletel)){ errorMes = errorMes + "\n���۾�����ϵ��ʽ����Ϊ��";}
			}
		} catch (Exception e) { 
			e.printStackTrace(); 
			throw new RuntimeException("��ѯ����ʧ��");
		} finally {
			if (rs != null) {
				rs.getStatement().close();
			}
		}
		return errorMes;
	}
	

	/**
	 * ��ѯ������Ա���ŵ꾭�������ŵ��Ƿ񻹴��ڹ�ϵ
	 * @param Sqlca
	 * @return isThere (0:��,1:��)
	 * @throws Exception
	 */
	public String querySalesManagerRelation(Transaction Sqlca) throws Exception{
		System.out.println("�ŵ���=" +sno); 
		System.out.println("������Ա=" +salesmanno); 
		
		String isThere = "0";
		String sql = "SELECT COUNT(1) FROM store_info a, storerelativesalesman b, store_info c "
				+ "WHERE a.sno = b.sno AND a.salesmanager = c.salesmanager AND b.stype IS NULL "
				+ "AND a.sno <> :snoOne AND c.sno = :snoTwo AND b.salesmanno = :salesmanno";
		String count = Sqlca.getString(new SqlObject(sql)
								.setParameter("snoOne", sno)
								.setParameter("snoTwo", sno)
								.setParameter("salesmanno", salesmanno));
		if(count != null && Integer.parseInt(count) > 0){
			isThere = "1";
		}
		
		return isThere;
	}
	
}
