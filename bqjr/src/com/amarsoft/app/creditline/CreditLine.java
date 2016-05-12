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
 * 属于 amarbank_ALS6 项目
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
     * Comment for <code>id</code> CL_INFO表中全局唯一的id
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
        
        //初始化Attributes
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
        if(sAttValueMatrix.length!=1) throw new ASException("没有找到额度<"+sLineID+">");
        String[] sAttValues = sAttValueMatrix[0];
        this.attributes = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);
    }

    public void initSecondTierCL(Transaction Sqlca, String sLineID) throws Exception {
        this.id = sLineID;
    	SqlObject so = null;//声明对象
        //初始化Attributes
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
        if(sAttValueMatrix.length!=1) throw new ASException("没有找到额度<"+sLineID+">");
        String[] sAttValues = sAttValueMatrix[0];
        this.attributes = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);

        //初始化LimitationSets
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
     * <p>从额度信息参数池中取参数</p>
     * 
     * <p>缺省参数如下：</p>
     * 
     * <table border="1">
     * <tr><td>额度ID</td><td>LineID</td></tr>
     * <tr><td>额度类型编号</td><td>CLTypeID</td></tr>
     * <tr><td>授信申请编号</td><td>ApplySerialNo</td></tr>
     * <tr><td>授信批复编号</td><td>ApproveSerialNo</td></tr>
     * <tr><td>授信合同号</td><td>BCSerialNo</td></tr>
     * <tr><td>人工授信额度协议号</td><td>LineContractNo</td></tr>
     * <tr><td>客户编号</td><td>CustomerID</td></tr>
     * <tr><td>信贷业务额度</td><td>LineSum1</td></tr>
     * <tr><td>信贷敞口额度</td><td>LineSum2</td></tr>
     * <tr><td>对外担保额度</td><td>LineSum3</td></tr>
     * <tr><td>单位币种</td><td>Currency</td></tr>
     * <tr><td>生效日</td><td>LineEffDate</td></tr>
     * <tr><td>额度生效标志</td><td>LineEffFlag</td></tr>
     * <tr><td>项下业务发放日截止日</td><td>PutOutDeadLine</td></tr>
     * <tr><td>项下业务到期日截止日</td><td>MaturityDeadLine</td></tr>
     * <tr><td>循环or不可循环</td><td>Rotative</td></tr>
     * <tr><td>流程简化程度</td><td>ApprovalPolicy</td></tr>
     * <tr><td>冻结标志</td><td>FreezeFlag</td></tr>
     * <tr><td>最近一次检查编号</td><td>RecentCheck</td></tr>
     * <tr><td>最近一次检查状态</td><td>RecentCheckStatus</td></tr>
     * <tr><td>最近一次检查结果</td><td>CheckResult</td></tr>
     * <tr><td>最近一次检查异常说明</td><td>OverflowType</td></tr>
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
     * <p>输入要检查的对象,判断是否能够包含在额度项下。</p>
     * 
     * <p>直接调用额度对应的计算器的check()方法。然后对每个限制条件组，调用对应的限制条件检查器的check()方法。</p>
     * 
     * <p>
     * 返回值由两部分构成：判断结果+异常点类型ID，形如：fail@0001<br>
     * 其中，异常点类型定义在CL_ERROR_TYPE表中
     * </p>
     * @param Sqlca
     * @param sObjectType
     * @param sObjectNo
     */
    public Vector check(Transaction Sqlca, String sCheckOptions, String sObjectType, String sObjectNo) throws Exception{
    	if(this.getCurCheckNo()==null){
    		throw new ASException("当前额度尚未进入“检查”状态，请通过 enterCheckMode()进入检查状态。");
    	}
    	
    	//额度检查
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
			throw new ASException("当前额度尚未进入“检查”状态，请通过 enterCheckMode()进入检查状态。");
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
            //缺省使用DefaultCreditLineKeeper
            this.keeper = new DefaultCreditLineKeeper();
            this.keeper.setCreditLine(this);
        } else {
            //否则动态装载指定的类
            try {
                Class tClass = Class.forName(sClassName);
                this.keeper = (ICreditLineKeeper) tClass.newInstance();
                this.keeper.setCreditLine(this);
            } catch (Exception ex) {
                throw new ASException("类[" + sClassName + "]装载失败："+ ex.getMessage());
            }
        }
        
        return this.keeper;
    }
    
    /**
     * 占用一个CurCheckLogNo号码，并向CL_CHECK_LOG插入记录
     * @param Sqlca
     * @return
     * @throws Exception
     */
    public String enterCheckMode(Transaction Sqlca)throws Exception{
        if(this.id==null) throw new ASException("进入检查模式发生错误：本额度尚未初始化。");
        String sRecentCheckStatus = (String)this.getAttribute("RecentCheckStatus");
    	if(sRecentCheckStatus!=null && sRecentCheckStatus.equals("1"))
    		throw new ASException("进入检查模式发生错误：额度当前已经处于检查模式中。");
    	SqlObject so = null;//声明对象
    	//先占用一个CurCheckLogNo号码
    	String CurCheckLogNo = DBKeyHelp.getSerialNo("CL_CHECK_LOG","CheckNo","",Sqlca);
    	 so = new SqlObject("update CL_INFO set RecentCheck=:RecentCheck,RecentCheckStatus='1' where LineID=:LineID");
    	 so.setParameter("RecentCheck", CurCheckLogNo);
    	 so.setParameter("LineID", this.id());
    	 Sqlca.executeSQL(so);
    	//向CL_CHECK_LOG插入记录
    	 so = new SqlObject("insert into CL_CHECK_LOG (LineID,CheckNo,CheckTime) values(:LineID,:CheckNo,:CheckTime)");
    	 so.setParameter("LineID", this.id);
    	 so.setParameter("CheckNo", CurCheckLogNo);
    	 so.setParameter("CheckTime", StringFunction.getTodayNow());
    	 Sqlca.executeSQL(so);
    	 
    	//更改当前检查标志
    	this.setAttribute("RecentCheck",CurCheckLogNo);
    	this.setAttribute("RecentCheckStatus","1");
    	
    	return CurCheckLogNo;
    }
    
    /**
     * 清空CurCheckLogNo，退出检查模式
     * @throws Exception
     */
    public void exitCheckMode(Transaction Sqlca)throws Exception{
    	String sRecentCheckStatus = (String)this.getAttribute("RecentCheckStatus");
    	if(sRecentCheckStatus!=null && sRecentCheckStatus.equals("0")) throw new ASException("退出检查模式发生错误：额度当前不处于检查模式中。");
    	SqlObject so = new SqlObject("update CL_INFO set RecentCheckStatus='0' where LineID=:LineID ");
	   	so.setParameter("LineID", this.id);
	   	Sqlca.executeSQL(so);
    	this.setAttribute("RecentCheckStatus","0");
    }
    
    public CreditLineType getType(Transaction Sqlca) throws Exception {
    	if (this.type == null){
    		String sCLTypeID = (String)this.getAttribute("CLTypeID");
    		if(sCLTypeID==null || sCLTypeID.equals("")) throw new ASException("额度类型没有定义。");
    		CreditLineType tmpType = CreditLineManager.getCreditLineType(sCLTypeID);
    		this.type = tmpType;
    	}
    	return this.type;
    }
}