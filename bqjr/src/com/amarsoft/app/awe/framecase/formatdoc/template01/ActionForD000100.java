package com.amarsoft.app.awe.framecase.formatdoc.template01;

import java.util.ArrayList;
import java.util.Random;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.awe.dw.handler.BusinessProcessData;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;
import com.amarsoft.awe.dw.ui.util.WordConvertor;
import com.amarsoft.biz.formatdoc.model.FormatDocHelp;
import com.amarsoft.biz.formatdoc.model.TestExtClass;
import com.amarsoft.biz.formatdoc.util.CommonUtil;


public class ActionForD000100 extends CommonHandler{
	public boolean saveList(BusinessProcessData bpData){
		try{
			String sDataSerialNo = this.asPage.getParameter("DataSerialNo");
			D001_00 oData = (D001_00)FormatDocHelp.getFDDataObject(sDataSerialNo,"com.amarsoft.app",null);
			StringBuffer sbHtml = new StringBuffer();//拼接字符串，用于返回到js处理 
			//获得选中的jbo
			int[] rows = bpData.SelectedRows;
			//填充list数据
			if(rows!=null){
				ArrayList list = new ArrayList();
				if(oData.getExtobj1()!=null){
					for(int i=0;i<oData.getExtobj1().length;i++)
						list.add(oData.getExtobj1()[i]);
				}
				for(int i=0;i<rows.length;i++){
					BizObject obj = this.jbos[rows[i]];
					TestExtClass extobj = new  TestExtClass();
					extobj.setAttr1(obj.getAttribute("DOCID").getValue()==null?"":obj.getAttribute("DOCID").getString());
					extobj.setAttr2(obj.getAttribute("DOCNAME").getValue()==null?"":obj.getAttribute("DOCNAME").getString());
					extobj.setAttr3(obj.getAttribute("DOCTYPE").getValue()==null?"":obj.getAttribute("DOCTYPE").getString());
					extobj.setAttr4(obj.getAttribute("ORGID").getValue()==null?"":obj.getAttribute("ORGID").getString());
					//随机生成数值
					Random random = new Random();
					int iRandValue = random.nextInt(1000);
					extobj.setAttr4(iRandValue+ "");
					list.add(extobj);
					sbHtml.append(",['"+ WordConvertor.convertJava2Js(extobj.getAttr1())+"','"+WordConvertor.convertJava2Js(extobj.getAttr2())
							+"','"+WordConvertor.convertJava2Js(extobj.getAttr3())+"','"+WordConvertor.convertJava2Js(extobj.getAttr4())+"']");
				}
				oData.setExtobj1((TestExtClass[])list.toArray(new TestExtClass[0]));
			}
			//保存回数据库
			oData.saveObject();
			String sHtml = sbHtml.toString().trim();
			if(sHtml.startsWith(","))
				sHtml ='[' + sHtml.substring(1) + ']';
			this.resultInfo = sHtml;
			return true;
		}
		catch(Exception e){
			ARE.getLog().error("保存列表失败:" + e.toString());
			this.errors = "保存列表失败:" + e.toString();
			return false;
		}
		
	}
	
	public boolean removeList(BusinessProcessData bpData){
		try{
			String sDataSerialNo = this.asPage.getParameter("DataSerialNo");
			D001_00 oData = (D001_00)FormatDocHelp.getFDDataObject(sDataSerialNo,"com.amarsoft.app",null);
			String[][] datas = null;
			//获得选中的jbo
			int[] rows = bpData.SelectedRows;
			//填充list数据
			if(rows!=null){
				datas = (String[][])bpData.mapData.get("datas");
				//过滤选中的数组,并重新拼接数据
				ArrayList list = new ArrayList();
				for(int i=0;i<datas.length;i++){
					if(CommonUtil.numberInArr(rows, i)==-1){
						TestExtClass extData = new TestExtClass();
						extData.setAttr1(datas[i][0]);
						extData.setAttr2(datas[i][1]);
						extData.setAttr3(datas[i][2]);
						extData.setAttr4(datas[i][3]);
						list.add(extData);
					}
				}
				oData.setExtobj1((TestExtClass[])list.toArray(new TestExtClass[0]));
				//保存回数据库
				oData.saveObject();
			}
			return true;
		}
		catch(Exception e){
			ARE.getLog().error("删除列表失败:" + e.toString());
			this.errors = "删除列表失败:" + e.toString();
			return false;
		}
	}
	
	/**
	 * 获得查询条件
	 * @return
	 */
	public static String genJboWhere(String sDataSerialNo)throws Exception{
		String result = "";
		D001_00 oData = (D001_00)FormatDocHelp.getFDDataObject(sDataSerialNo,"com.amarsoft.app",null);
		if(oData.getExtobj1()==null || oData.getExtobj1().length==0)
			return "1=1";
		for(int i=0;i<oData.getExtobj1().length;i++){
			result += ",'" + oData.getExtobj1()[i].getAttr1() + "'";
		}
		result = "DOCID not in("+ result.substring(1) +")";
		System.out.println("===============result = " + result);
		return result;
	}
	
	/**
	 * 初始化时候获得选中的数据
	 * @param sDataSerialNo
	 * @return
	 * @throws Exception
	 */
	public static String[][] getSelectedDatas(String sDataSerialNo)throws Exception{
		String[][] result = null;
		D001_00 oData = (D001_00)FormatDocHelp.getFDDataObject(sDataSerialNo,"com.amarsoft.app",null);
		if(oData.getExtobj1()==null)
			return null;
		result = new String[oData.getExtobj1().length][4];
		for(int i=0;i<result.length;i++){
			result[i][0] = oData.getExtobj1()[i].getAttr1();
			result[i][1] = oData.getExtobj1()[i].getAttr2();
			result[i][2] = oData.getExtobj1()[i].getAttr3();
			result[i][3] = oData.getExtobj1()[i].getAttr4();
		}
		return result;
	}
}
