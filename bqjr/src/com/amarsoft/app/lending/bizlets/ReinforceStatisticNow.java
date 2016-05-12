package com.amarsoft.app.lending.bizlets;


/*
Author: --zhuang 2010-03-25
Tester:
Describe: --关于补登业务数据的信息的实时查询
Input Param:
        OrgID: 机构号
        ValueType: 返回值的类型       
Output Param:
        
HistoryLog:
*/

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceStatisticNow extends Bizlet{

    public Object run(Transaction Sqlca) throws Exception {
        //获取参数
        String OrgID = (String)this.getAttribute("OrgID");
        String ValueType = (String)this.getAttribute("ValueType");//返回值的类型
        
        //将空值转化成空字符串        
        if(OrgID == null) OrgID = "";       
        if(ValueType == null) ValueType = "";
        
        //定义变量
        ASResultSet rs = null;//查询结果集
        String sSqlFinish = "";//查询补登完成的业务笔数
        String sSqlUnFinish = "";//查询补登未完成的业务笔数
        String sSqlOrgName = "";//查询机构名称
        String sOrgName = "";//机构名称
        int dFinishCounts = 0;//补登完成的业务笔数
        int dUnFinishCounts = 0;//补登完成的业务笔数    
        SqlObject so;
           
        sSqlOrgName = "select OrgName from ORG_INFO where OrgID=:OrgID";
        so = new SqlObject(sSqlOrgName).setParameter("OrgID", OrgID);
        sOrgName = Sqlca.getString(so);
        
        sSqlFinish = " select count(*) from BUSINESS_CONTRACT " +
	     " where ManageOrgID =:ManageOrgID and ReinforceFlag='010' ";
        so = new SqlObject(sSqlFinish).setParameter("ManageOrgID", OrgID);
        dUnFinishCounts = DataConvert.toInt(Sqlca.getString(so));
        sSqlUnFinish = " select count(*) from BUSINESS_CONTRACT " +
        " where ManageOrgID =:ManageOrgID and ReinforceFlag='020' ";
        so = new SqlObject(sSqlUnFinish).setParameter("ManageOrgID", OrgID);
        dFinishCounts = DataConvert.toInt(Sqlca.getString(so));
        
        if(ValueType.equals("Counts")){   
            return sOrgName+"@,"+dFinishCounts+"@"+dUnFinishCounts+"@,"+"补登完成@补登未完成@";          
        }else if(ValueType.equals("Percents")){ 
            double dCounts = dFinishCounts + dUnFinishCounts;//补登业务总数
            if(dCounts==0){
                return sOrgName+"@,"+"0.0@0.0@,补登完成@补登未完成@";//当该机构无补登记录时，返回 补登完成与未完成的业务数的百分比均为0.0
            }else{
                double dFinishPercents = 100*dFinishCounts/dCounts;//补登完成的业务数的百分比
                return sOrgName+"@,"+dFinishPercents+"@"+(100-dFinishPercents)+"@,"+"补登完成百分比@补登未完成百分比@";
            }           
        }       
        return null;      
    }  
}
