package com.amarsoft.app.lending.bizlets;


/*
Author: --zhuang 2010-03-25
Tester:
Describe: --关于补登业务数据的信息的历史查询
Input Param:
        OrgIDArray: 机构号字符串
        ValueType: 返回值的类型       
Output Param:
              
HistoryLog:
*/

import com.amarsoft.are.util.DataConvert;
import com.amarsoft.awe.util.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class ReinforceStatisticHistory extends Bizlet{

    public Object run(Transaction Sqlca) throws Exception {
        //获取参数      
        String OrgIDArrayStr = (String)this.getAttribute("OrgIDArray");//机构号字符串       
        String ValueType = (String)this.getAttribute("ValueType");//返回值的类型
        
        //将空值转化成空字符串            
        if(OrgIDArrayStr == null) OrgIDArrayStr = "";
        if(ValueType == null) ValueType = "";
        //空值判断应在操作之前
        String[] OrgIDArray = OrgIDArrayStr.split(";");//机构号数组
        
        //定义变量
        String sSqlFinishCounts = "";//查询补登完成业务笔数
        String sSqlUnFinishCounts = "";//查询补登未完成业务笔数
        String sSqlFinishPercents = "";//查询补登完成业务百分比 
                
        StringBuffer sOrgIDs = new StringBuffer("");//所有机构号的字符串
        String sOrgID = "";//所有机构号的字符串
        String sSqlOrgName = "";//OrgIDArray中所有机构号对应的机构号名称的字符串
        String[] sFinishCounts = new String[OrgIDArray.length];//补登完成的业务笔数
        String[] sUnFinishCounts = new String[OrgIDArray.length];;//补登未完成的业务笔数       
        String[] sFinishPercents =  new String[OrgIDArray.length];//补登完成的业务数的百分比
        
        StringBuffer sReturnPercentsOrgName = new StringBuffer("");//所有的机构名称
        StringBuffer sReturnCounts =new StringBuffer("");//补登业务整数值数据
        StringBuffer sReturnFinishCounts = new StringBuffer("");//补登完成业务整数值数据
        StringBuffer sReturnUnFinishCounts = new StringBuffer("");//补登未完成业务整数值数据
        StringBuffer sReturnPercents = new StringBuffer("");//补登业务百分比数值数据
        StringBuffer sReturnFinishPercents = new StringBuffer("");//补登完成业务百分比数值数据
        StringBuffer sReturnUnFinishPercents = new StringBuffer("");//补登未完成业务百分比数值数据
        
        for (int i = 0; i < OrgIDArray.length; i++) {        
            sOrgIDs.append("'"+OrgIDArray[i]+"',");                           
        }
        sOrgID = sOrgIDs.substring(0, sOrgIDs.length()-1);
              
        sSqlOrgName = "select OrgName from ORG_INFO where OrgID in ("+ sOrgID +")";
        String[] sOrgName = Sqlca.getStringArray(sSqlOrgName);//获取所有机构名称的字符串数组
        
        sSqlFinishCounts = "select FinishedBC from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sFinishCounts = Sqlca.getStringArray(sSqlFinishCounts);//将完成笔数转换为字符数组
        sSqlUnFinishCounts = "select UnfinishBC from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sUnFinishCounts = Sqlca.getStringArray(sSqlUnFinishCounts);//将未完成笔数转换为字符数组
      //获取所选机构已完成业务笔数的百分比，字段"FinishedRatio"在表"REINFORCE_ACCOUNT"中所存形式为"完成笔数/(完成笔数+未完成笔数)"
        sSqlFinishPercents= "select FinishedRatio from REINFORCE_ACCOUNT where OrgID in ("+sOrgID+")";
        sFinishPercents = Sqlca.getStringArray(sSqlFinishPercents);//将完成百分比转换为字符数组

        for (int i = 0; i < OrgIDArray.length; i++) {               
            if(ValueType.equals("Counts")){//如果所需为数量展示则拼接字符串为"sFinishCount[i]@sUnFinishCounts[i]@"的形式
                sReturnFinishCounts.append(sFinishCounts[i]+"@"); 
                sReturnUnFinishCounts.append(sUnFinishCounts[i]+"@");
            }else if(ValueType.equals("Percents")){
            	double FinishPercents = DataConvert.toDouble(sFinishPercents[i]);
            	double FinishCounts = DataConvert.toDouble(sFinishCounts[i]);
            	double UnFinishCounts = DataConvert.toDouble(sUnFinishCounts[i]);
            	sReturnFinishPercents.append(100*FinishPercents+"@");//乘以100使其指标转换为百分制
            	if(FinishCounts+UnFinishCounts==0){//判断过滤掉其中一项的百分比为0.00，而另一项为100.00的情况
            		sReturnUnFinishPercents.append(0.00+"@");
            	}else{
            		sReturnUnFinishPercents.append(100*(1-FinishPercents)+"@");
            	}
            }                   
            sReturnPercentsOrgName.append(sOrgName[i]+"@");//连接机构名称
        }
        
        sReturnCounts = sReturnFinishCounts.append(sReturnUnFinishCounts);//准备需要返回数量的字符串，形式如"10@10@"
        sReturnPercents = sReturnFinishPercents.append(sReturnUnFinishPercents);//准备需要返回百分比的字符串，形式如"0.00@0.00@"
        if(ValueType.equals("Counts")){           
            return sReturnPercentsOrgName.toString()+","+sReturnCounts+","+"补登完成笔数@补登未完成笔数@";          
        }else if(ValueType.equals("Percents")){    
            return sReturnPercentsOrgName.toString()+","+sReturnPercents+","+"补登完成百分比@补登未完成百分比@";
        }                 
        return null;      
    }   
}