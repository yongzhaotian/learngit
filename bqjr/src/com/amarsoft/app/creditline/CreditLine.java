/***********************************************************************
 * Module:  CreditLine.java
 * Author:  William
 * Modified: 2005.6.10 18:30:20
 * Purpose: Defines the Class CreditLine
 ***********************************************************************/

package com.amarsoft.app.creditline;

import java.util.Vector;

import com.amarsoft.app.creditline.model.CreditLineType;
import com.amarsoft.are.ASException;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.awe.util.DBKeyHelp;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * ���� amarbank_ALS6 ��Ŀ
 * 
 * @author William
 * @since 2005-7-7 13:28:46
 */
public class CreditLine {
    private CreditLineType type;
    private ICreditLineKeeper keeper;
    private String[][] constants = null;
    private String[] sublineid = null;
    
    /**
     * Comment for <code>id</code> CL_INFO����ȫ��Ψһ��id
     */
    private String id;

    public ASValuePool attributes;

    private LimitationSet[] limitationSets;

    public CreditLine() {
    }

    public String id(){
    	return this.id;
    }
    /**
     * @param Sqlca
     * @param sLineID
     * @throws Exception
     */
    public CreditLine(Transaction Sqlca, String sLineID) throws Exception {
    	initFirstTierCL(Sqlca, sLineID);
    	getSubLineID(Sqlca,sLineID);
		for (int i = 0; i < sublineid.length; i++) {	    	    	
    		initSecondTierCL(Sqlca, sublineid[i]);
    	}
    }
    
    public void initFirstTierCL(Transaction Sqlca, String sLineID) throws Exception {
        this.id = sLineID;
        
        //��ʼ��Attributes
        String[] sAttKeys = {
                "LineID",
          		"CLTypeID",
          		"ApplySerialNo",
          		"ApproveSerialNo",
          		"BCSerialNo",
          		"LineContractNo",
          		"CustomerID",
          		"LineSum1",
          		"LineSum2",
          		"LineSum3",
          		"Currency",
          		"LineEffDate",
          		"LineEffFlag",
          		"PutOutDeadLine",
          		"MaturityDeadLine",
          		"Rotative",
          		"ApprovalPolicy",
          		"FreezeFlag",
          		"RecentCheck",
          		"RecentCheckStatus",
          		"CheckResult",
          		"OverflowType",
          		"BeginDate",
          		"EndDate",
          		"ParentLineID",
          		"UseOrgID",
          		"BailRatio",
          		"BusinessType"
          		};

        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sAttKeys.length;i++) sbSelect.append(sAttKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        
        sbSelect.append(" from CL_INFO where LineID =:LineID ");
        String sSql = sbSelect.toString();
    	SqlObject so = new SqlObject(sSql);
		so.setParameter("LineID", sLineID);
        String[][] sAttValueMatrix = Sqlca.getStringMatrix(so);
        if(sAttValueMatrix.length!=1) throw new ASException("û���ҵ����<"+sLineID+">");
        String[] sAttValues = sAttValueMatrix[0];
        this.attributes = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);
    }

    public void initSecondTierCL(Transaction Sqlca, String sLineID) throws Exception {
        this.id = sLineID;
    	SqlObject so = null;//��������
        //��ʼ��Attributes
        String[] sAttKeys = {
                "LineID",
          		"CLTypeID",
          		"ApplySerialNo",
          		"ApproveSerialNo",
          		"BCSerialNo",
          		"LineContractNo",
          		"CustomerID",
          		"LineSum1",
          		"LineSum2",
          		"LineSum3",
          		"Currency",
          		"LineEffDate",
          		"LineEffFlag",
          		"PutOutDeadLine",
          		"MaturityDeadLine",
          		"Rotative",
          		"ApprovalPolicy",
          		"FreezeFlag",
          		"RecentCheck",
          		"RecentCheckStatus",
          		"CheckResult",
          		"OverflowType",
          		"BeginDate",
          		"EndDate",
          		"ParentLineID",
          		"UseOrgID",
          		"BailRatio",
          		"BusinessType"
          		};

        StringBuffer sbSelect = new StringBuffer("");
        sbSelect.append("select ");
        for(int i=0;i<sAttKeys.length;i++) sbSelect.append(sAttKeys[i]+",");
        sbSelect.deleteCharAt(sbSelect.length()-1);
        sbSelect.append(" from CL_INFO where LineID =:LineID ");
        String sSql = sbSelect.toString();
    	so = new SqlObject(sSql);
		so.setParameter("LineID", sLineID);
		String[][] sAttValueMatrix = Sqlca.getStringMatrix(so);
        if(sAttValueMatrix.length!=1) throw new ASException("û���ҵ����<"+sLineID+">");
        String[] sAttValues = sAttValueMatrix[0];
        this.attributes = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);

        //��ʼ��LimitationSets
        String sLSAttKeys[]={
        		"LineID",
        		"LimitationSetID",
        		"LimitationType",
        		"ObjectType",
        };
        StringBuffer sbLSSelect = new StringBuffer("");
        sbLSSelect.append("select ");
        for(int i=0;i<sLSAttKeys.length;i++) sbLSSelect.append(sLSAttKeys[i]+",");
        sbLSSelect.deleteCharAt(sbLSSelect.length()-1);
        sbLSSelect.append(" from CL_LIMITATION_SET where LineID =:LineID ");        
        sSql = sbLSSelect.toString();        
        so = new SqlObject(sSql);
		so.setParameter("LineID", sLineID);   
		String[][] sLSAttMatrix = Sqlca.getStringMatrix(so);
		
        this.limitationSets = new LimitationSet[sLSAttMatrix.length];
        for(int i=0;i<this.limitationSets.length;i++){
        	this.limitationSets[i] = new LimitationSet(this);
        	for(int j=0;j<sLSAttMatrix[i].length;j++)
        		this.limitationSets[i].setAttribute(sLSAttKeys[j],sLSAttMatrix[i][j]);
        }
    }
    
    private void getSubLineID(Transaction Sqlca,String sLineID)throws Exception {
    	this.sublineid = Sqlca.getStringArray(new SqlObject("select LineID from CL_INFO where ParentLineID =:ParentLineID").setParameter("ParentLineID", sLineID));
    }

    /**
     * <p>�Ӷ����Ϣ��������ȡ����</p>
     * 
     * <p>ȱʡ�������£�</p>
     * 
     * <table border="1">
     * <tr><td>���ID</td><td>LineID</td></tr>
     * <tr><td>������ͱ��</td><td>CLTypeID</td></tr>
     * <tr><td>����������</td><td>ApplySerialNo</td></tr>
     * <tr><td>�����������</td><td>ApproveSerialNo</td></tr>
     * <tr><td>���ź�ͬ��</td><td>BCSerialNo</td></tr>
     * <tr><td>�˹����Ŷ��Э���</td><td>LineContractNo</td></tr>
     * <tr><td>�ͻ����</td><td>CustomerID</td></tr>
     * <tr><td>�Ŵ�ҵ����</td><td>LineSum1</td></tr>
     * <tr><td>�Ŵ����ڶ��</td><td>LineSum2</td></tr>
     * <tr><td>���ⵣ�����</td><td>LineSum3</td></tr>
     * <tr><td>��λ����</td><td>Currency</td></tr>
     * <tr><td>��Ч��</td><td>LineEffDate</td></tr>
     * <tr><td>�����Ч��־</td><td>LineEffFlag</td></tr>
     * <tr><td>����ҵ�񷢷��ս�ֹ��</td><td>PutOutDeadLine</td></tr>
     * <tr><td>����ҵ�����ս�ֹ��</td><td>MaturityDeadLine</td></tr>
     * <tr><td>ѭ��or����ѭ��</td><td>Rotative</td></tr>
     * <tr><td>���̼򻯳̶�</td><td>ApprovalPolicy</td></tr>
     * <tr><td>�����־</td><td>FreezeFlag</td></tr>
     * <tr><td>���һ�μ����</td><td>RecentCheck</td></tr>
     * <tr><td>���һ�μ��״̬</td><td>RecentCheckStatus</td></tr>
     * <tr><td>���һ�μ����</td><td>CheckResult</td></tr>
     * <tr><td>���һ�μ���쳣˵��</td><td>OverflowType</td></tr>
     * </table>
     * 
     * @param sAttributeID
     * @return
     * @throws Exception
     */
    public Object getAttribute(String sAttributeID) throws Exception{
        return this.attributes.getAttribute(sAttributeID);
    }

    /**
     * @param sAttributeID
     * @param obj
     * @throws Exception
     */
    public void setAttribute(String sAttributeID,Object obj) throws Exception{
        this.attributes.setAttribute(sAttributeID,obj);
    }

    /** @param Sqlca */
    public double getBalance(Transaction Sqlca) throws Exception{
        return this.getKeeper(Sqlca).calcBalance(Sqlca);
    }

    /** @param Sqlca */
    public double getBalance(Transaction Sqlca,String sBalanceID) throws Exception{
        return this.getKeeper(Sqlca).calcBalance(Sqlca,sBalanceID);
    }

    /**
     * <p>����Ҫ���Ķ���,�ж��Ƿ��ܹ������ڶ�����¡�</p>
     * 
     * <p>ֱ�ӵ��ö�ȶ�Ӧ�ļ�������check()������Ȼ���ÿ�����������飬���ö�Ӧ�����������������check()������</p>
     * 
     * <p>
     * ����ֵ�������ֹ��ɣ��жϽ��+�쳣������ID�����磺fail@0001<br>
     * ���У��쳣�����Ͷ�����CL_ERROR_TYPE����
     * </p>
     * @param Sqlca
     * @param sObjectType
     * @param sObjectNo
     */
    public Vector check(Transaction Sqlca, String sCheckOptions, String sObjectType, String sObjectNo) throws Exception{
    	if(this.getCurCheckNo()==null){
    		throw new ASException("��ǰ�����δ���롰��顱״̬����ͨ�� enterCheckMode()������״̬��");
    	}
    	
    	//��ȼ��
    	Vector errors =  this.getKeeper(Sqlca).check(Sqlca,sCheckOptions,sObjectType,sObjectNo);
    	return errors;
    }

	/**
	 * @return Returns the curCheckLogNo.
	 * @throws Exception 
	 */
	public String getCurCheckNo() throws Exception {
		String sRecentCheckStatus = (String)this.getAttribute("RecentCheckStatus");
		if(sRecentCheckStatus==null || sRecentCheckStatus.equals("0"))
			throw new ASException("��ǰ�����δ���롰��顱״̬����ͨ�� enterCheckMode()������״̬��");
		return (String)this.getAttribute("RecentCheck");
	}

	public String[][] getConstants()throws Exception{
		if(constants!=null) return this.constants;
		
		Object[] sKeys = this.attributes.getKeys();
		this.constants = new String[sKeys.length][2];
		for(int i=0;i<constants.length;i++){
			constants[i][0] = "#"+(String)sKeys[i];
			constants[i][1] = (String)this.getAttribute((String)sKeys[i]);
		}
		return this.constants; 
	}
	/**
	 * @return Returns the limitationSets.
	 */
	public LimitationSet[] getLimitationSets() {
		return limitationSets;
	}
	
    private ICreditLineKeeper getKeeper(Transaction Sqlca) throws Exception {
        if (this.keeper != null) return this.keeper;

        String sClassName = (String) this.getType(Sqlca).getClKeeperClass();
        if (sClassName == null || sClassName.equals("")) {
            //ȱʡʹ��DefaultCreditLineKeeper
            this.keeper = new DefaultCreditLineKeeper();
            this.keeper.setCreditLine(this);
        } else {
            //����̬װ��ָ������
            try {
                Class tClass = Class.forName(sClassName);
                this.keeper = (ICreditLineKeeper) tClass.newInstance();
                this.keeper.setCreditLine(this);
            } catch (Exception ex) {
                throw new ASException("��[" + sClassName + "]װ��ʧ�ܣ�"+ ex.getMessage());
            }
        }
        
        return this.keeper;
    }
    
    /**
     * ռ��һ��CurCheckLogNo���룬����CL_CHECK_LOG�����¼
     * @param Sqlca
     * @return
     * @throws Exception
     */
    public String enterCheckMode(Transaction Sqlca)throws Exception{
        if(this.id==null) throw new ASException("������ģʽ�������󣺱������δ��ʼ����");
        String sRecentCheckStatus = (String)this.getAttribute("RecentCheckStatus");
    	if(sRecentCheckStatus!=null && sRecentCheckStatus.equals("1"))
    		throw new ASException("������ģʽ�������󣺶�ȵ�ǰ�Ѿ����ڼ��ģʽ�С�");
    	SqlObject so = null;//��������
    	//��ռ��һ��CurCheckLogNo����
    	String CurCheckLogNo = DBKeyHelp.getSerialNo("CL_CHECK_LOG","CheckNo","",Sqlca);
    	 so = new SqlObject("update CL_INFO set RecentCheck=:RecentCheck,RecentCheckStatus='1' where LineID=:LineID");
    	 so.setParameter("RecentCheck", CurCheckLogNo);
    	 so.setParameter("LineID", this.id());
    	 Sqlca.executeSQL(so);
    	//��CL_CHECK_LOG�����¼
    	 so = new SqlObject("insert into CL_CHECK_LOG (LineID,CheckNo,CheckTime) values(:LineID,:CheckNo,:CheckTime)");
    	 so.setParameter("LineID", this.id);
    	 so.setParameter("CheckNo", CurCheckLogNo);
    	 so.setParameter("CheckTime", StringFunction.getTodayNow());
    	 Sqlca.executeSQL(so);
    	 
    	//���ĵ�ǰ����־
    	this.setAttribute("RecentCheck",CurCheckLogNo);
    	this.setAttribute("RecentCheckStatus","1");
    	
    	return CurCheckLogNo;
    }
    
    /**
     * ���CurCheckLogNo���˳����ģʽ
     * @throws Exception
     */
    public void exitCheckMode(Transaction Sqlca)throws Exception{
    	String sRecentCheckStatus = (String)this.getAttribute("RecentCheckStatus");
    	if(sRecentCheckStatus!=null && sRecentCheckStatus.equals("0")) throw new ASException("�˳����ģʽ�������󣺶�ȵ�ǰ�����ڼ��ģʽ�С�");
    	SqlObject so = new SqlObject("update CL_INFO set RecentCheckStatus='0' where LineID=:LineID ");
	   	so.setParameter("LineID", this.id);
	   	Sqlca.executeSQL(so);
    	this.setAttribute("RecentCheckStatus","0");
    }
    
    public CreditLineType getType(Transaction Sqlca) throws Exception {
    	if (this.type == null){
    		String sCLTypeID = (String)this.getAttribute("CLTypeID");
    		if(sCLTypeID==null || sCLTypeID.equals("")) throw new ASException("�������û�ж��塣");
    		CreditLineType tmpType = CreditLineManager.getCreditLineType(sCLTypeID);
    		this.type = tmpType;
    	}
    	return this.type;
    }
}