package com.amarsoft.app.creditline.cache;

import java.sql.SQLException;
import java.util.LinkedHashMap;

import com.amarsoft.app.creditline.model.CreditLineType;
import com.amarsoft.app.creditline.model.CreditLineTypeTable;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class CreditLineTypeCache  extends AbstractCache {

	private CreditLineTypeTable clTypeTable = null;
	private static CreditLineTypeCache instance = null;

	/**
	 * 构造函数
	 */
	private CreditLineTypeCache() {
	}

	/**
	 * 每次使用的时候,能过调用本方法,来得到全局唯一的对象实例引用 
	 * @return RoleCache 返回一个全局唯一的对象实例引用
	 */
	public static synchronized CreditLineTypeCache getInstance() {
		if (instance == null) {
			instance = new CreditLineTypeCache();
		}
		return instance;
	}

	/**
	 * 每次使用的时候,能过调用本方法,来得到全局唯一的对象实例引用 
	 * @return 返回一个全局唯一的对象实例引用
	 */
	private synchronized CreditLineTypeTable getCLTypeTable() throws Exception{
		if (clTypeTable == null) {
			clTypeTable = new CreditLineTypeTable(new LinkedHashMap<String,CreditLineType>());
		}
		return clTypeTable;
	}

	/**
	 * 从数据库装载
	 * @param Sqlca
	 * @throws Exception
	 */
	public boolean load(Transaction Sqlca) throws Exception{
		ARE.getLog().info("[CACHE] CreditLineType Cache bulid Begin .................");
		clTypeTable = getCLTypeTable(Sqlca);
		//将缓存装入ASValuePool，以便老的应用调用
		//loadConfig(Sqlca);
		ARE.getLog().info("[CACHE] CreditLineType Cache bulid CL_TYPE["+clTypeTable.getSize()+"] End ...................");
		return true;
	}

	public void clear() throws Exception {
		if (clTypeTable != null) {
			getCLTypeTable().clear();
			clTypeTable = null;
		}
	}
	
	private static CreditLineTypeTable getCLTypeTable(Transaction Sqlca) throws SQLException {
		CreditLineTypeTable table = new CreditLineTypeTable(new LinkedHashMap<String,CreditLineType>());
		CreditLineType clType = null;
		String sql = "select CLTypeID,CLTypeName,CLKeeperClass,Line1BalExpr,Line2BalExpr,Line3BalExpr,CheckExpr,EffStatus," +
				" Circulatable,BeneficialType,CreationWizard,DONo,OverviewComp,CurrencyMode,ApprovalPolicy,ContractFlag,SubContractFlag,DefaultLimitation " +
				" from CL_TYPE where EffStatus='1' Order by CLTypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
		while (rs.next()) {
			clType = new CreditLineType(rs.getString("CLTypeID"), rs.getString("CLTypeName"));
			clType.setClKeeperClass(rs.getString("CLKeeperClass"));
			clType.setLine1BalExpr(rs.getString("Line1BalExpr"));
			clType.setLine2BalExpr(rs.getString("Line2BalExpr"));
			clType.setLine3BalExpr(rs.getString("Line3BalExpr"));
			clType.setCheckExpr(rs.getString("CheckExpr"));
			clType.setEffStatus(rs.getString("EffStatus"));
			clType.setCirculatable(rs.getString("Circulatable"));
			clType.setBeneficialType(rs.getString("BeneficialType"));
			clType.setCreationWizard(rs.getString("CreationWizard"));
			clType.setDoNo(rs.getString("DONo"));
			clType.setOverviewComp(rs.getString("OverviewComp"));
			clType.setCurrencyMode(rs.getString("CurrencyMode"));
			clType.setApprovalPolicy(rs.getString("ApprovalPolicy"));
			clType.setContractFlag(rs.getString("ContractFlag"));
			clType.setSubContractFlag(rs.getString("SubContractFlag"));
			clType.setDefaultLimitation(rs.getString("DefaultLimitation"));
			//添加3个参数
			clType.setLineSum1(rs.getString("Line1BalExpr"));
			clType.setLineSum2(rs.getString("Line2BalExpr"));
			clType.setLineSum3(rs.getString("Line3BalExpr"));
			table.addCreditLineType(clType);
		}
		rs.getStatement().close();
		ARE.getLog().info("[CACHE] CreditLineType Cache get CL_TYPE["+table.getSize()+"] End ...................");

		return table;
	}
	
	/**
	 * 根据sCLTypeID获取CreditLineType对象
	 */
	public static CreditLineType getCreditLineType(String sCLTypeID) throws Exception {
		CreditLineTypeTable table = getInstance().getCLTypeTable();
		if (table.getCreditLineTypeMap().isEmpty()) {
			Transaction Sqlca = getSqlca();
			try {
				return getCreditLineType(sCLTypeID, Sqlca);
			} finally {
				if (Sqlca != null)
					Sqlca.disConnect();
			}
		} else {
			return table.getCreditLineType(sCLTypeID);
		}
	}
	
	private static CreditLineType getCreditLineType(String sCLTypeID, Transaction Sqlca) throws Exception {
		String sql = "select CLTypeID,CLTypeName,CLKeeperClass,Line1BalExpr,Line2BalExpr,Line3BalExpr,CheckExpr,EffStatus," +
				" Circulatable,BeneficialType,CreationWizard,DONo,OverviewComp,CurrencyMode,ApprovalPolicy,ContractFlag,SubContractFlag,DefaultLimitation " +
				" from CL_TYPE where EffStatus='1' and CLTypeID=:CLTypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("CLTypeID", sCLTypeID));
		while (rs.next()) {
			CreditLineType type = new CreditLineType(rs.getString("CLTypeID"), rs.getString("CLTypeName"));
			type.setClKeeperClass(rs.getString("CLKeeperClass"));
			type.setLine1BalExpr(rs.getString("Line1BalExpr"));
			type.setLine2BalExpr(rs.getString("Line2BalExpr"));
			type.setLine3BalExpr(rs.getString("Line3BalExpr"));
			type.setCheckExpr(rs.getString("CheckExpr"));
			type.setEffStatus(rs.getString("EffStatus"));
			type.setCirculatable(rs.getString("Circulatable"));
			type.setBeneficialType(rs.getString("BeneficialType"));
			type.setCreationWizard(rs.getString("CreationWizard"));
			type.setDoNo(rs.getString("DONo"));
			type.setOverviewComp(rs.getString("OverviewComp"));
			type.setCurrencyMode(rs.getString("CurrencyMode"));
			type.setApprovalPolicy(rs.getString("ApprovalPolicy"));
			type.setContractFlag(rs.getString("ContractFlag"));
			type.setSubContractFlag(rs.getString("SubContractFlag"));
			type.setDefaultLimitation(rs.getString("DefaultLimitation"));
			//添加3个参数
			type.setLineSum1(rs.getString("Line1BalExpr"));
			type.setLineSum2(rs.getString("Line2BalExpr"));
			type.setLineSum3(rs.getString("Line3BalExpr"));
			rs.getStatement().close();
			return type;
		}
		rs.getStatement().close();
		return null;
	}
	
	/**
	 * 考虑对原来应用的兼容，将缓存装入ASValuePool，以便老的应用调用
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	/*private ASValuePool loadConfig(Transaction Sqlca) throws Exception {
        String sCLTypeKey = null;
        ASValuePool vpCLTypeDef = new ASValuePool();
        ASValuePool attributes = new ASValuePool();
        String[] sKeys = {"CLTypeID",
        		"CLTypeName",
        		"CLKeeperClass",
        		"Line1BalExpr",
        		"Line2BalExpr",
        		"Line3BalExpr",
        		"CheckExpr",
        		"EffStatus",
        		"Circulatable",
        		"BeneficialType",
        		"CreationWizard",
        		"DONo",
        		"OverviewComp",
        		"CurrencyMode",
        		"ApprovalPolicy",
        		"ContractFlag",
        		"SubContractFlag",
        		"DefaultLimitation"
        		};
        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sKeys.length;i++) sbSelect.append(sKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_TYPE where EffStatus='1'");
        
        SqlObject so = new SqlObject(sbSelect.toString());
        String[][] sValueMatrix = Sqlca.getStringMatrix(so);
        for(int i=0;i<sValueMatrix.length;i++){
        	sCLTypeKey = sValueMatrix[i][0];
        	for(int j=0;j<sValueMatrix[i].length;j++){
        		attributes.setAttribute(sKeys[j],sValueMatrix[i][j]);
            }
            //添加3个参数
        	attributes.setAttribute("LineSum1",attributes.getAttribute("Line1BalExpr"));
        	attributes.setAttribute("LineSum2",attributes.getAttribute("Line2BalExpr"));
        	attributes.setAttribute("LineSum3",attributes.getAttribute("Line3BalExpr"));
        	
            vpCLTypeDef.setAttribute(sCLTypeKey,attributes,false);
        }
        ASConfigure.setSysConfig("SYSCONF_CLTYPE",vpCLTypeDef);
        return vpCLTypeDef;		
	}*/
}
