package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng
 * @date 2013/05/20
 */
public class CVNodeHTMLView {
	private CVNodeDrawController CVnc;  //draw controller  object
	private String[] nodeIDArray;     //节点ID
	private String[] nodeNames;                 //节点名称
	private String[] sortNos;              //节点排序号
	private String[] factors;                //列名称, <申请/审批/合同/贷后合同>
	private int[][] map;
	private final int facNums;  //因子数（阶段数）
	private String[] nodeObjInfoArray;  //将节点信息以类似Object的形式传递,实现选择框的正确赋值(预留,暂时不用)

	public String[] getNodeIDArray() {
		return nodeIDArray;
	}

//	public String[] getSortNos() {
//		return sortNos;
//	}

	public int[][] getMap(){
		return map;
	}
	
	public int getFacNums(){
		return facNums;
	}
	
	public String[] getFactors(){
		return factors;
	}
	
	public String[] getNodeNames(){
		return nodeNames;
	}
	
	public String[] getNodeObjInfoArray() {
		return nodeObjInfoArray;
	}
	
	/**
	 * 构造函数
	 * 
	 * @param productID  产品ID
	 * @param nodeIDArr 节点ID数组
	 * @param seperator 分隔符号
	 */
	public CVNodeHTMLView(Transaction Sqlca, String productID, String nodeIDArr, String seperator) throws Exception{
		 CVnc = new CVNodeDrawController(Sqlca, productID, nodeIDArr, seperator);
		 nodeIDArray = CVnc. getNodeIDArray();
		 nodeNames = CVnc. getNodeNames();
		 sortNos = CVnc. getSortNos();
		 factors = CVnc. getFactors();
		 map = CVnc.getMap();
		 facNums = CVnc. getFacNums();
		 nodeObjInfoArray =  CVnc.getNodeObjInfoArray();
	}
	
	/**
	 * @important   !!  暂时弃用该方法, html代码已经放回到jsp页面
	 * 
	 * @purpose 获取CVNodeDrawController类返回的参数，生成HTML表格
	 * @return sPRDNodeInfo   以String格式存储的HTML代码
	 */
	public String generateHTMLGrid(){
		StringBuffer sTemp=new StringBuffer();
		String sPRDNodeInfo = "";
		String tmpStr= "";
		//String[] factors = CVnc.getFactors();
		//String[] nodeNames =CVnc.getNodeNames() ;
		
		sTemp.append("<form action=''>");	
		sTemp.append("  <input type='button' onclick='saveRecord()' value='保存'><br/>");	
		sTemp.append("  <br/>");
		sTemp.append("  <input type='button' onclick='selectNodes()' value='配置基础节点'><br/>");	
		sTemp.append("  <br/>");
		sTemp.append("  <input type='text' id='content' size='100'></input><br/>");
		sTemp.append("  <br/>");
		sTemp.append("  <table border='1'  cellpadding='0'  cellspacing='0'  width='100%'  align='center'  id='NodeConfigTable'>");
		sTemp.append("    <tr>");
		sTemp.append("      <td class='title1'  align='center' colspan='6'  style='background: #DDD;'>节点信息配置图</td>");
		sTemp.append("    </tr>");
		sTemp.append("    <tr>");
		sTemp.append("      <td class='title2'>结点 \\ 阶段</td>");
		//生成列名称(除TITLE外 起第一行)
		for (int i = 0; i < facNums; i++){
			tmpStr = "      <td class='title2'>";      
			tmpStr += factors[i];
			tmpStr += "<input type='button' id=";
			tmpStr += i;
			tmpStr += " onclick='selColumns(this.id)' value='反选列'><br/></td>";
			sTemp.append(tmpStr);
		}
		sTemp.append("    </tr>");
		//生成节点(行)
		for (int i = 0; i < nodeIDArray.length; i++){
			sTemp.append("    <tr>");
			
			tmpStr =            "      <td class='title2'>";
			if (nodeIDArray[i].length() > 3){
				tmpStr += "&nbsp;&nbsp;&nbsp;&nbsp;";  //子节点缩进
			}
			tmpStr += nodeNames[i];  //节点名称
			tmpStr += "</td>";
			sTemp.append(tmpStr);
			//给每个节点生成check box(列)
			for (int j = 0; j < facNums; j++){
				sTemp.append("      <td class='title2'>");
				tmpStr =            "         <input type='checkbox' name='cell' value='(";
				tmpStr = tmpStr + i + "|" + j;
				tmpStr += ")' onclick='checkStatus(this.id)'><br/>";
				sTemp.append(tmpStr);
				sTemp.append("      </td>");
			}
			
			sTemp.append("    </tr>");
		}
		
		sTemp.append("  </table>");
		sTemp.append("</form>");	
		
		sPRDNodeInfo = sTemp.toString();
		
		return sPRDNodeInfo;
	}
}