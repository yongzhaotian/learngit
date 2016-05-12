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
	private String[] nodeIDArray;     //�ڵ�ID
	private String[] nodes;                 //�ڵ�����
	private String[] sortNos;              //�ڵ������
	private String[] factors;                //������, <����/����/��ͬ/�����ͬ>
	private int[][] map;                      //�洢factorsֵ(0/1), ��ά����
	private String productID;             //��ƷID
	private final int facNums = 4;  //���������׶�����
	private String[] nodeObjInfoArray;  //���ڵ���Ϣ������Object����ʽ����,ʵ��ѡ������ȷ��ֵ(Ԥ��,��ʱ����)
	
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
	 * @param sProductID  ��ƷID
	 * @param sNodeIDArr �ڵ�ID����
	 * @param seperator �ָ�����
	 */
	public CVNodeDrawController(Transaction Sqlca, String productID, String nodeIDArr, String seperator) throws Exception{
	 	String nodeIDs;
		
		if(nodeIDArr.length() > 0){  //�жϽڵ������Ƿ�Ϊ��
			nodeIDArray =  nodeIDArr.split(seperator);
			nodeIDs = nodeIDArr.replaceAll(seperator, "','");  		//Ԥ����ID
		}
		else{
			nodeIDArray = new String[0];
			nodeIDs = "";
		}
		
		this.productID = productID;
		factors = new String[facNums]; 
		factors[0] = "����׶�չ��";
	    factors[1] = "�����׶�չ��";
	    factors[2] = "��ͬ�׶�չ��";
	    factors[3] = "�����ͬ�׶�չ��";
		nodes = new String[nodeIDArray.length];     //�ڵ���Ϣ����
		sortNos = new String[nodeIDArray.length];  //�ڵ���Ϣ�����
		map = new int[nodeIDArray.length][facNums];
		nodeObjInfoArray = new String[nodeIDArray.length];
	      
	    initRelatedNodeInfo(Sqlca, nodeIDs);   //��ʼ��nodeIDArray, nodes, sortNo, ����sortNo����
	}
	
	/**
	 * @purpose ˽�к�������ʼ�����ݣ�Ϊ��HTML�����׼��
	 * @param nodeIDs ������Ľڵ�ID��Ϣ����ʽ��ʽ  ('001','002')
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