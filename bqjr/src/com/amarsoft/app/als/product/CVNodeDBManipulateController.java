/**
 * 
 */
package com.amarsoft.app.als.product;

import com.amarsoft.awe.util.ASResultSet;
import com.amarsoft.awe.util.SqlObject;
import com.amarsoft.awe.util.Transaction;

/**
 * @author yzheng
 * @date 2013/05/20
 */
public class CVNodeDBManipulateController {
	private String  records;           //选中的check box
	private String  seperator;       //分隔符
	private String[] nodeIDArray;     //节点ID
	private String[] nodes ;                 //节点名称
	private String[] sortNos;              //节点排序号
	private String productID;             //产品ID
	private String nodeIDArr;           //未处理过的ID字符串
	private String nodeNames;           //未处理过的名称字符串
	private final int facNums = 4;  //因子数（阶段数)
	
	public String getNodeNames() {
		return nodeNames;
	}

	public void setNodeNames(String nodeNames) {
		this.nodeNames = nodeNames;
	}

	public String getRecords() {
		return records;
	}

	public void setRecords(String records) {
		this.records = records;
	}

	public String getSeperator() {
		return seperator;
	}

	public void setSeperator(String seperator) {
		this.seperator = seperator;
	}

	public String getProductID() {
		return productID;
	}

	public void setProductID(String productID) {
		this.productID = productID;
	}

	public String getNodeIDArr() {
		return nodeIDArr;
	}

	public void setNodeIDArr(String nodeIDArr) {
		this.nodeIDArr = nodeIDArr;
	}

	/**
	 *   
	 */
	public CVNodeDBManipulateController() {
		// TODO Auto-generated constructor stub
	}
	
	/**
	 * @return prdIDArr 关联到某个节点ID的产品IDs。可包含多个产品ID，以“@”分隔
	 * */
	public String check4Delete(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;
		String prdIDArr = "";
		String prdNameArr = "";
		String sSql = "";
		
		osql = new SqlObject("select distinct PrdID from PRD_NODECONFIG where NodeID = :nodeID");
		osql.setParameter("nodeID", nodeIDArr);
		rs = Sqlca.getASResultSet(osql);
		
		while(rs.next()){
			prdIDArr = prdIDArr + rs.getString("PrdID") + "@";
		}
		
		if (prdIDArr.length() > 0){
			prdIDArr = prdIDArr.substring(0, prdIDArr.length()-1);
			prdIDArr = prdIDArr.replaceAll("@", "','");
			
			sSql = "SELECT TypeName  FROM BUSINESS_TYPE where TypeNo in ('" + prdIDArr + "' )";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				prdNameArr = prdNameArr + rs.getString("TypeName") + "@";
			}
		}
		rs.getStatement().close();
		
		return (prdIDArr.length() > 0) ? prdNameArr : "NOT EXISTS";
	}
	
	/**
	 * @return prdIDArr   某个产品对应的节点ID数组, 以"@"符号分隔
	 */
	public String checkPRDNode(Transaction Sqlca) throws Exception{
		SqlObject  osql = null;
		ASResultSet rs = null;
		String prdIDArr = "";
		
		osql = new SqlObject("select NodeID from PRD_NODECONFIG where PrdID = :PrdID");
		osql.setParameter("PrdID", productID);
		rs = Sqlca.getASResultSet(osql);
		while(rs.next()){
			prdIDArr = prdIDArr + rs.getString("NodeID") + "@";
		}
		
		rs.getStatement().close();
		
		return prdIDArr;
	}
	
	/**
	 * @return result 更新数据库结果: "SUCCESS" / "FAIL"
	 * */
	public String select2Update(Transaction Sqlca) throws Exception{		
		initRelatedNodeInfo(Sqlca);
		
	    SqlObject  osql = null;
		String resultUpdate = "";  //更新或插入数据库结果："SUCCESS" / "FAIL"
		String resultDel = "";  //删除不需要的记录："SUCCESS" / "FAIL"
		int count = 0;
		
		String rec = records.substring(0, records.length()-1);  //去除最后一个@符号
		String[] selected = rec.split(seperator);
		int[][] map = new int[nodeIDArray.length][facNums];      // array = 节点个数 * 因子数   
		
		//匹配一维records到二维map，实现整条记录的更新或插入
		for (int i = 0; i < selected.length; i++){
			//System.out.println("selected[i]@@:" + selected[i]);
			
			int idx = selected[i].indexOf("|");  //checkbox分隔符索引
			int nodeId = Integer.parseInt(selected[i].substring(1, idx)); 
			int facInx = Integer.parseInt(selected[i].substring(idx+1, selected[i].length()-1)); 
			
			map[nodeId][facInx] = 1;
			//System.out.println("@@(" + nodeId + "," + facInx + ")  =" + map[nodeId][facInx]);
		}	
		
//		for (int i = 0; i < nodeIDArray.length; i++){
//			for (int j = 0; j < facNums; j++){
//				System.out.println("(" + i + "," + j + ")  =" + map[i][j]);
//			}
//		}
		
		//更新数据库, 循环次数=节点个数
		for (int i = 0; i < nodeIDArray.length; i++){
			osql = new SqlObject("select count(*) from PRD_NODECONFIG where PrdID = :productID and NodeID = :nodeID");
			osql.setParameter("productID", productID);
			osql.setParameter("nodeID", nodeIDArray[i]);
			
			String num = Sqlca.getString(osql);  //查询是否有记录
			//int emptyFacs = 0;
			
			if(num.equals("0")) {
				osql = new SqlObject("insert into PRD_NODECONFIG (PrdID, NodeID, NodeName, SortNo, Fac1, Fac2, Fac3, Fac4)"
						+ "values (:PrdID, :NodeID, :NodeName, :SortNo, :Fac1, :Fac2, :Fac3, :Fac4)");
			}
			else{
				osql = new SqlObject("update PRD_NODECONFIG set NodeName=:NodeName, SortNo=:SortNo, Fac1=:Fac1, Fac2=:Fac2, Fac3=:Fac3, Fac4=:Fac4"
						+ " where PrdID = :PrdID and NodeID = :NodeID");
			}
			osql.setParameter("PrdID", productID);
			osql.setParameter("NodeID", nodeIDArray[i]);
			osql.setParameter("NodeName", nodes[i]);
			osql.setParameter("SortNo", sortNos[i]);
			for (int j = 0; j < facNums; j++)  {
				osql.setParameter("Fac" + (j+1), map[i][j]);
				//if( map[i][j] == 0) emptyFacs++;
			}
			
//			if(emptyFacs == facNums){
//				count++;
//				continue;    //节点被选择后，若一列都没被选中，则不存储该节点信息
//			}
			
			if(Sqlca.executeSQL(osql) == 1) count++;
		}
		
		String sSql;		 
		String nodeIDs = nodeIDArr.replaceAll(seperator, "','");  //预处理nodeIDArr
		osql = new SqlObject("select count(*) from PRD_NODECONFIG where PrdID = :productID");  //查询该产品关联的节点个数
		osql.setParameter("productID", productID);
		
		int rowNums = Integer.parseInt(Sqlca.getString(osql));
		
		if(rowNums > count){
			sSql = "delete from PRD_NODECONFIG where PrdID = '" + productID + "' and NodeID not in  ('" + nodeIDs + "') ";  //删除之前存储但本次未选中的节点记录
			resultDel  = (Sqlca.executeSQL(sSql) == (rowNums - count))  ? "SUCCESS" : "FAIL";
		}
		else{
			resultDel = "SUCCESS";
		}
		
		resultUpdate = (count == nodeIDArray.length) ? "SUCCESS" : "FAIL";
		
		return (resultDel.equals("SUCCESS") && resultUpdate.equals("SUCCESS") ) ? "SUCCESS" : "FAIL";
	}
	
	/**
	 * @purpose 私有函数：初始化数据，为数据库的数据更新操作做准备
	 */
	private void initRelatedNodeInfo(Transaction Sqlca) throws Exception{
		 String sSql;		 
		 ASResultSet rsTemp = null;	
		 int count = 0;
		 int len = nodeIDArr.split(seperator).length;  //节点数量
		 
		 String nodeIDs = nodeIDArr.replaceAll(seperator, "','");  //预处理nodeIDArr
		 //初始化私有变量
		 nodeIDArray = new String[len];     //节点ID
	     nodes = new String[len];                //节点名称
		 sortNos = new String[len];            //节点排序号
		 
		 nodes = nodeNames.substring(0, nodeNames.length()-1).split("@");  //分组前去除最后一个@符号
		 
		 sSql = "select NodeName, SortNo, NodeID from PRD_NODEINFO where NodeID in  ('" + nodeIDs + "') order by SortNo ASC";
		 rsTemp = Sqlca.getASResultSet(sSql);
	 	 while(rsTemp.next()){
	 		 //nodes[count] = rsTemp.getString("NodeName");
	 		 sortNos[count] = rsTemp.getString("SortNo");
	 		 nodeIDArray[count] = rsTemp.getString("NodeID");  
	 		 count++;
	 	 }
	 	 rsTemp.getStatement().close();
	}
}