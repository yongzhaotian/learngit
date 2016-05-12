/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.Transaction;


/**
 * @author yzheng
 * @date 2013/05/20
 */
public class CVNodeDrawController {
	private String[] nodeIDArray;     //节点ID
	private String[] nodes;                 //节点名称
	private String[] sortNos;              //节点排序号
	private String[] factors;                //列名称, <申请/审批/合同/贷后合同>
	private int[][] map;                      //存储factors值(0/1), 二维数组
	private String productID;             //产品ID
	private final int facNums = 4;  //因子数（阶段数）
	private String[] nodeObjInfoArray;  //将节点信息以类似Object的形式传递,实现选择框的正确赋值(预留,暂时不用)
	
	public int getFacNums(){
		return facNums;
	}
	
	public  String[] getNodeIDArray(){
		return nodeIDArray;
	}
	
	public String[] getFactors(){
		return factors;
	}
	
	public String[] getNodeNames(){
		return nodes;
	}
	
	public String[] getSortNos(){
		return sortNos;
	}
	
	public int[][] getMap(){
		return map;
	}
	
	public String[] getNodeObjInfoArray() {
		return nodeObjInfoArray;
	}

	/**
	 * @param sProductID  产品ID
	 * @param sNodeIDArr 节点ID数组
	 * @param seperator 分隔符号
	 */
	public CVNodeDrawController(Transaction Sqlca, String productID, String nodeIDArr, String seperator) throws Exception{
	 	String nodeIDs;
		
		if(nodeIDArr.length() > 0){  //判断节点数量是否为空
			nodeIDArray =  nodeIDArr.split(seperator);
			nodeIDs = nodeIDArr.replaceAll(seperator, "','");  		//预处理ID
		}
		else{
			nodeIDArray = new String[0];
			nodeIDs = "";
		}
		
		this.productID = productID;
		factors = new String[facNums]; 
		factors[0] = "申请阶段展现";
	    factors[1] = "审批阶段展现";
	    factors[2] = "合同阶段展现";
	    factors[3] = "贷后合同阶段展现";
		nodes = new String[nodeIDArray.length];     //节点信息名称
		sortNos = new String[nodeIDArray.length];  //节点信息排序号
		map = new int[nodeIDArray.length][facNums];
		nodeObjInfoArray = new String[nodeIDArray.length];
	      
	    initRelatedNodeInfo(Sqlca, nodeIDs);   //初始化nodeIDArray, nodes, sortNo, 根据sortNo排序
	}
	
	/**
	 * @purpose 私有函数：初始化数据，为画HTML表格做准备
	 * @param nodeIDs 处理过的节点ID信息。格式样式  ('001','002')
	 */
	private void initRelatedNodeInfo(Transaction Sqlca,  String nodeIDs) throws Exception{
		 String sSql;
		 ASResultSet rsTemp = null;	
		 int count = 0;
		 
		 sSql = "select NodeName, SortNo, NodeID  from PRD_NODEINFO where NodeID in  ('" + nodeIDs + "') order by SortNo ASC";
		 rsTemp = Sqlca.getASResultSet(sSql);
	 	 while(rsTemp.next()){
	 		 nodes[count] = rsTemp.getString("NodeName");
	 		 sortNos[count] = rsTemp.getString("SortNo");
	 		 nodeIDArray[count] = rsTemp.getString("NodeID");  
	 		 
	 		 count++;
	 	 }
	 	 
	 	 if(count > 0){
		 	 count = 0;
		 	 
		 	 for(int k = 0; k < nodeIDArray.length; k++){
		 		 String tmpStr = "";
			 	 sSql = "select Fac1, Fac2, Fac3, Fac4  from PRD_NODECONFIG where PrdID = '" + productID + "' and NodeID = '" + nodeIDArray[k] + "' order by SortNo ASC";
			 	 rsTemp = Sqlca.getASResultSet(sSql);
			  	 if(rsTemp.next()){
			 		  for(int i = 0; i < facNums; i++)  {
			 			  map[count][i] = Integer.parseInt(rsTemp.getString("Fac" + (i+1)));  
			 			  //System.out.println("(" + count + "," + i + ")  =" + map[count][i]);
			 			 tmpStr += map[count][i] + "@";
			 		  }
			 	 }
			  	 else{
			  		tmpStr += "0@0@0@0@";
			  	 }
		 		 nodeObjInfoArray[count] = tmpStr + sortNos[count];
		 		 count++;
		 	 }
	 	 }
	 	 rsTemp.getStatement().close();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
//		String s1 = "Hello";
//		
//		if(s1.toLowerCase().contains("hell"))
//		{
//			System.out.println("@@@@@@@@");
//		}
	}
}