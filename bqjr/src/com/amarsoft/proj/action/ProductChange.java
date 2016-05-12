package com.amarsoft.proj.action;

import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

public class ProductChange {
	private String BusinessType="";//��Ʒ���
	private String CperiodNew="";//�²���������
	private String CprincipalNew="";//�²����Ľ��
	private String TallPrincipal ="" ;  //��Ʒϵ���µĲ�Ʒ�������
	private String  LowPrincipal = "";  //��Ʒϵ���µĲ�Ʒ����С���
	private String businessContractSerialNo = ""; //��ͬ���
	private String oldCperiod="";//�ɵ�����
	private String oldCprincipal="";//�ɵĽ��
	private String NewBusinessType="";//�ɵĲ�Ʒ����
	private String productSeriesNo="";//��Ʒϵ�б��
	
	
	/**
	 * ����������Խ��ı�󣬸ý���Ƿ��ڲ�Ʒϵ�������в�Ʒ����������С���
	 *  @param Sqlca
	 *	@return
	 * @throws Exception 
	 * add by ybpan at 20150423  CCS-485
	 */
	public String cprincipalMapping(Transaction Sqlca) throws Exception{
		String flag = "FAIL";
		int sMaxPrincipal =0;
		int sMinPrincipal =0;
		
		String productSeriesNoSql ="select PRODUCTSERIESID from product_businessType where BUSTYPEID =:BUSTYPEID";
		productSeriesNo= Sqlca.getString(new SqlObject(productSeriesNoSql).setParameter("BUSTYPEID", BusinessType));
		String sMaxMinsql = "select max(bt.TALLPRINCIPAL),min(LOWPRINCIPAL) from business_type bt,   "+
			"(select pb.bustypeid from product_businessType pb where pb.productseriesid =:productSeriesID) b "+
					" where bt.typeno=b.bustypeid";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sMaxMinsql).setParameter("productSeriesID", productSeriesNo));
		if(rs.next()){
			 sMaxPrincipal = rs.getInt(1);
			 sMinPrincipal = rs.getInt(2);
		}
		rs.getStatement().close();		
		ARE.getLog().info("CprincipalNew"+CprincipalNew+"sMaxPrincipal"+sMaxPrincipal+"sMinPrincipal"+sMinPrincipal);
		if(Integer.parseInt(CprincipalNew)>=sMinPrincipal&&Integer.parseInt(CprincipalNew)<=sMaxPrincipal){flag = sMaxPrincipal+"@"+sMinPrincipal+"@"+productSeriesNo;}
		return flag;
	}
	/**
	 * ���ϵͳ����û�з��������Ĳ�Ʒ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 * add by ybpan at 20150424 CCS-485
	 */
	public String checkBusinessType(Transaction Sqlca)  throws Exception{
		String  changedBusinessType ="";
		String sql = "select TYPENO from business_type bt,product_businessType pb where bt.typeno=pb.bustypeid and pb.productseriesid=:productSeriesID and  TALLPRINCIPAL>=:TALLPRINCIPAL and LOWPRINCIPAL<=:LOWPRINCIPAL and term=:CperiodNew  and SUBPRODUCTTYPE='2'";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql)
		.setParameter("TALLPRINCIPAL", CprincipalNew)
		.setParameter("LOWPRINCIPAL", CprincipalNew)
		.setParameter("CperiodNew", CperiodNew)
		.setParameter("productSeriesID", productSeriesNo)
		);
		if(rs.next()){
			changedBusinessType = rs.getString(1);
		}
		rs.getStatement().close();		
		return changedBusinessType;
		
	}
	
	//�ع����ݣ�ɾ���Ѿ����ɵ���Ҫ���ݣ�
	public String RollbackContractInfo(Transaction Sqlca) throws Exception 
	{
		//����-��ϻ������α�
		Sqlca.executeSQL(new SqlObject("delete from acct_rpt_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.businessContractSerialNo));
		
		//����-�������α�
		Sqlca.executeSQL(new SqlObject("delete from acct_rate_segment where objectno = :ObjectNo").setParameter("ObjectNo", this.businessContractSerialNo));
		
		//����˺ű������ã�һ�Զ��ϵ
		Sqlca.executeSQL(new SqlObject("delete from acct_deposit_accounts where objectno = :ObjectNo").setParameter("ObjectNo", this.businessContractSerialNo));
		
		//���ü�����Ϣ��
		Sqlca.executeSQL(new SqlObject("delete from acct_fee_waive where objectno in(select serialno from acct_fee where objectno = :ObjectNo)").setParameter("ObjectNo", this.businessContractSerialNo));
		
		//���÷�����
		Sqlca.executeSQL(new SqlObject("delete from acct_fee where objectno = :ObjectNo").setParameter("ObjectNo", this.businessContractSerialNo));
		
		return "Success";
	}
	
	/**
	 * �Թ������淵�ص�������������з��������Ĳ�Ʒ����������Ա�ύ�ͻ�ͬ��ʱ���Ժ�ͬ�����޸�
	 * @param Sqlca
	 * @throws Exception
	 *  add by ybpan at 20150423  CCS-485
	 */
	public void changeBusinessType(Transaction Sqlca)  throws Exception{
		
		RollbackContractInfo(Sqlca);
		
		String businessTypeNameSql = "select typename from business_type where typeno=:typeNO";
		String businessTypeName =  Sqlca.getString(new SqlObject(businessTypeNameSql).setParameter("typeNO", NewBusinessType));
		String contractSql ="update business_contract set rpttermid=null,loanratetermid=null, businesssum =:businessSum,periods = :periods,oldbusinesssum =:oldBusinessSum,oldperiods = :oldPeriods,businessType=:businessType,oldBusinessType=:oldBusinessType,ProductName=:ProductName where serialno =:serialno ";
		Sqlca.executeSQL(new SqlObject(contractSql)
				.setParameter("businesssum", CprincipalNew)
				.setParameter("periods", CperiodNew)
				.setParameter("oldbusinesssum", oldCprincipal)
				.setParameter("oldperiods", oldCperiod)
				.setParameter("serialno",businessContractSerialNo)
				.setParameter("businessType",NewBusinessType)
				.setParameter("oldBusinessType",BusinessType)
				.setParameter("ProductName",businessTypeName)
				);
	}
	
	/**
	 * ��������׼�׶β�ѯĳ����ͬ�����������������淵�ص���������Լ�ԭ��ͬ�еĲ�Ʒ
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 * add by ybpan at 20150427
	 */
	public String subConditionCapitalPeriod(Transaction Sqlca)  throws Exception{
		//�������淵�ؽ��
		String sCprincipalSql = "select cprincipal from cashpost_data where applyno = :ObjectNo";
		String ssCprincipal=Sqlca.getString(new SqlObject(sCprincipalSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssCprincipal==null) ssCprincipal="0";
		int sCprincipal = Integer.valueOf(ssCprincipal).intValue();
		//�������淵������
		String sCperiodSql = "select nvl(cperiods,0) from cashpost_data where applyno = :ObjectNo";
		String ssCperiodSql=Sqlca.getString(new SqlObject(sCperiodSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssCperiodSql==null) ssCperiodSql="0";
		int sCperiod = Integer.valueOf(ssCperiodSql).intValue();
		
		//�ÿͻ��ں�ͬ���е�����
		String sBusinessCperiodSql = "select Periods from business_contract where serialno = :ObjectNo";
		String ssBusinessCperiodSql=Sqlca.getString(new SqlObject(sBusinessCperiodSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssBusinessCperiodSql==null) ssBusinessCperiodSql="0";
		int sBusinessCperiod = Integer.valueOf(ssBusinessCperiodSql).intValue();
		//�ÿͻ��ں�ͬ���еĽ��
		String sBusinessCprincipalSql = "select BusinessSum from business_contract where serialno= :ObjectNo";
		String ssBusinessCprincipalSql=Sqlca.getString(new SqlObject(sBusinessCprincipalSql).setParameter("ObjectNo", businessContractSerialNo));
		if(ssBusinessCprincipalSql==null) ssBusinessCprincipalSql="0";
		int sBusinessCprincipal = Integer.valueOf(ssBusinessCprincipalSql).intValue();
		//�ÿͻ��ں�ͬ����ԭ���������Ĳ�Ʒ
		String sBusinessProductSql = "select businesstype from business_contract where serialno= :ObjectNo";
		String sBusinessProduct = Sqlca.getString(new SqlObject(sBusinessProductSql).setParameter("ObjectNo", businessContractSerialNo));
		
		return sCprincipal +"@"+sCperiod+"@"+sBusinessCprincipal+"@"+sBusinessCperiod+"@"+sBusinessProduct;
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	public String getBusinessType() {
		return BusinessType;
	}
	public void setBusinessType(String businessType) {
		BusinessType = businessType;
	}
	public String getCperiodNew() {
		return CperiodNew;
	}
	public void setCperiodNew(String cperiodNew) {
		CperiodNew = cperiodNew;
	}
	public String getCprincipalNew() {
		return CprincipalNew;
	}
	public void setCprincipalNew(String cprincipalNew) {
		CprincipalNew = cprincipalNew;
	}
	public String getTallPrincipal() {
		return TallPrincipal;
	}
	public void setTallPrincipal(String tallPrincipal) {
		TallPrincipal = tallPrincipal;
	}
	public String getLowPrincipal() {
		return LowPrincipal;
	}
	public void setLowPrincipal(String lowPrincipal) {
		LowPrincipal = lowPrincipal;
	}
	public String getBusinessContractSerialNo() {
		return businessContractSerialNo;
	}
	public void setBusinessContractSerialNo(String businessContractSerialNo) {
		this.businessContractSerialNo = businessContractSerialNo;
	}
	public String getOldCperiod() {
		return oldCperiod;
	}
	public void setOldCperiod(String oldCperiod) {
		this.oldCperiod = oldCperiod;
	}
	public String getOldCprincipal() {
		return oldCprincipal;
	}
	public void setOldCprincipal(String oldCprincipal) {
		this.oldCprincipal = oldCprincipal;
	}
	public String getNewBusinessType() {
		return NewBusinessType;
	}
	public void setNewBusinessType(String newBusinessType) {
		NewBusinessType = newBusinessType;
	}
	public String getProductSeriesNo() {
		return productSeriesNo;
	}
	public void setProductSeriesNo(String productSeriesNo) {
		this.productSeriesNo = productSeriesNo;
	}
	
	
	
	
	
	
}
