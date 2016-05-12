package com.amarsoft.app.creditline.cache;

import java.sql.SQLException;
import java.util.LinkedHashMap;

import com.amarsoft.app.creditline.model.LimitationType;
import com.amarsoft.app.creditline.model.LimitationTypeTable;
import com.amarsoft.are.ARE;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.dict.als.cache.AbstractCache;

public class LimitationTypeCache  extends AbstractCache {

	private LimitationTypeTable limitationTypeTable = null;
	private static LimitationTypeCache instance = null;

	/**
	 * ���캯��
	 */
	private LimitationTypeCache() {
	}

	/**
	 * ÿ��ʹ�õ�ʱ��,�ܹ����ñ�����,���õ�ȫ��Ψһ�Ķ���ʵ������
	 * @return ����һ��ȫ��Ψһ�Ķ���ʵ������
	 */
	public static synchronized LimitationTypeCache getInstance() {
		if (instance == null) {
			instance = new LimitationTypeCache();
		}
		return instance;
	}

	/**
	 * ÿ��ʹ�õ�ʱ��,�ܹ����ñ�����,���õ�ȫ��Ψһ�Ķ���ʵ������ 
	 * @return RoleCache ����һ��ȫ��Ψһ�Ķ���ʵ������
	 */
	private synchronized LimitationTypeTable getLimitationTypeTable() throws Exception{
		if (limitationTypeTable == null) {
			limitationTypeTable = new LimitationTypeTable(new LinkedHashMap<String,LimitationType>());
		}
		return limitationTypeTable;
	}

	/**
	 * �����ݿ�װ��
	 * @param Sqlca
	 * @throws Exception
	 */
	public boolean load(Transaction Sqlca) throws Exception{
		ARE.getLog().info("[CACHE] CreditLine LimitationType Cache bulid Begin .................");
		limitationTypeTable = getLimitationTypeTable(Sqlca);
		//������װ��ASValuePool���Ա��ϵ�Ӧ�õ���
		//loadConfig(Sqlca);
		ARE.getLog().info("[CACHE] CreditLine LimitationType Cache bulid CL_LIMITATION_TYPE["+limitationTypeTable.getSize()+"] End ...................");
		return true;
	}

	public void clear() throws Exception {
		if (limitationTypeTable != null) {
			getLimitationTypeTable().clear();
			limitationTypeTable = null;
		}
	}
	
	private static LimitationTypeTable getLimitationTypeTable(Transaction Sqlca) throws SQLException {
		LimitationTypeTable table = new LimitationTypeTable(new LinkedHashMap<String,LimitationType>());
		LimitationType limitationType = null;
		String sql = "select TypeID,TypeName,CheckerClass,LimitationExpr,CompileCheckExpr,ControlType,ObjectType,CrossUsageEnabled,LimitationComp,LimitationWizard " +
				" from CL_LIMITATION_TYPE Order by TypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql));
		while (rs.next()) {
			limitationType = new LimitationType(rs.getString("TypeID"), rs.getString("TypeName"));
			limitationType.setCheckerClass(rs.getString("CheckerClass"));
			limitationType.setLimitationExpr(rs.getString("LimitationExpr"));
			limitationType.setCompileCheckExpr(rs.getString("CompileCheckExpr"));
			limitationType.setControlType(rs.getString("ControlType"));
			limitationType.setObjectType(rs.getString("ObjectType"));
			limitationType.setCrossUsageEnabled(rs.getString("CrossUsageEnabled"));
			limitationType.setLimitationComp(rs.getString("LimitationComp"));
			limitationType.setLimitationWizard(rs.getString("LimitationWizard"));
			table.addLimitationType(limitationType);
		}
		rs.getStatement().close();
		ARE.getLog().info("[CACHE] CreditLine LimitationType Cache get CL_LIMITATION_TYPE["+table.getSize()+"] End ...................");

		return table;
	}
	
	/**
	 * ����sTypeID��ȡLimitationType����
	 */
	public static LimitationType getLimitationType(String sTypeID) throws Exception {
		LimitationTypeTable table = getInstance().getLimitationTypeTable();
		if (table.getLimitationTypeMap().isEmpty()) {
			Transaction Sqlca = getSqlca();
			try {
				return getLimitationType(sTypeID, Sqlca);
			} finally {
				if (Sqlca != null)
					Sqlca.disConnect();
			}
		} else {
			return table.getLimitationType(sTypeID);
		}
	}
	
	private static LimitationType getLimitationType(String sTypeID, Transaction Sqlca) throws Exception {
		String sql = "select TypeID,TypeName,CheckerClass,LimitationExpr,CompileCheckExpr,ControlType,ObjectType,CrossUsageEnabled,LimitationComp,LimitationWizard " +
				" from CL_LIMITATION_TYPE where TypeID=:TypeID";
		ASResultSet rs = Sqlca.getASResultSet(new SqlObject(sql).setParameter("TypeID", sTypeID));
		while (rs.next()) {
			LimitationType type = new LimitationType(rs.getString("TypeID"), rs.getString("TypeName"));
			type.setCheckerClass(rs.getString("CheckerClass"));
			type.setLimitationExpr(rs.getString("LimitationExpr"));
			type.setCompileCheckExpr(rs.getString("CompileCheckExpr"));
			type.setControlType(rs.getString("ControlType"));
			type.setObjectType(rs.getString("ObjectType"));
			type.setCrossUsageEnabled(rs.getString("CrossUsageEnabled"));
			type.setLimitationComp(rs.getString("LimitationComp"));
			type.setLimitationWizard(rs.getString("LimitationWizard"));
			rs.getStatement().close();
			return type;
		}
		rs.getStatement().close();
		return null;
	}
	
	/**
	 * ���Ƕ�ԭ��Ӧ�õļ��ݣ�������װ��ASValuePool���Ա��ϵ�Ӧ�õ���
	 * @param Sqlca
	 * @return
	 * @throws Exception
	 */
	/*private ASValuePool loadConfig(Transaction Sqlca) throws Exception {
        String sLimitationTypeKey = null;
        ASValuePool vpLimitationTypeDef = new ASValuePool();
        ASValuePool attributes = new ASValuePool();
        String[] sKeys = {"TypeID",
        		"TypeName",
        		"CheckerClass",
        		"LimitationExpr",
        		"CompileCheckExpr",
        		"ControlType",
        		"ObjectType",
        		"CrossUsageEnabled",
        		"LimitationComp",
        		"LimitationWizard"
        		};
        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sKeys.length;i++) sbSelect.append(sKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_LIMITATION_TYPE");
        
        SqlObject so = new SqlObject(sbSelect.toString());
        String[][] sValueMatrix = Sqlca.getStringMatrix(so);
        for(int i=0;i<sValueMatrix.length;i++){
        	sLimitationTypeKey = sValueMatrix[i][0];
        	for(int j=0;j<sValueMatrix[i].length;j++){
        		attributes.setAttribute(sKeys[j],sValueMatrix[i][j]);
            }
        	vpLimitationTypeDef.setAttribute(sLimitationTypeKey,attributes,false);
        }
        ASConfigure.setSysConfig("SYSCONF_LIMITATIONTYPE",vpLimitationTypeDef);
        return vpLimitationTypeDef;		
	}*/
}
