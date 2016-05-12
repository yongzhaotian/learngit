package demo;

import java.util.Iterator;
import java.util.Map;

public class BQNode {
	private String nodeName;
	private Map<String, String> attrMap;
	private String nodeValue;
	private boolean bInputNode;

	public BQNode() {}
	
	public BQNode(String nodeName, Map<String, String> attrMap, String nodeValue) {
		
		this.nodeName = nodeName;
		this.nodeValue = nodeValue;
		this.attrMap = attrMap;
	}
	
	public boolean isbInputNode() {
		return bInputNode;
	}

	public void setbInputNode(boolean bInputNode) {
		this.bInputNode = bInputNode;
	}

	public String getNodeName() {
		return nodeName;
	}
	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}
	public String getNodeValue() {
		return nodeValue;
	}
	public void setNodeValue(String nodeValue) {
		this.nodeValue = nodeValue;
	}
	public Map<String, String> getAttrMap() {
		return attrMap;
	}
	public void setAttrMap(Map<String, String> attrMap) {
		this.attrMap = attrMap;
	}
	
	@Override
	public String toString() {
		
		StringBuffer sb = new StringBuffer();
		
		sb.append(nodeName).append(": ").append(nodeValue).append("\n");
		
		if (attrMap !=null) {
			
			sb.append("Attrs: ");
			Iterator<String> iter = attrMap.keySet().iterator();
			
			while(iter.hasNext()) {
				
				String key = iter.next();
				sb.append(key).append("=").append(attrMap.get(key)).append(", ");
			}
			sb.delete(sb.length()-2, sb.length()).append("\n");
		}
		
		return sb.toString();
	}
}