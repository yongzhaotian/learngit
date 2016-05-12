package com.amarsoft.app.als.flow.cfg.model;

public class BusinessProcessConst {

	public static final String ACTIVITY_TYPE_START_NODE = "START_NODE"; //开始节点
	public static final String ACTIVITY_TYPE_END_NODE = "END_NODE";     //结束节点
	public static final String ACTIVITY_TYPE_NODE = "NODE";             //任务节点
	public static final String ACTIVITY_TYPE_FORK_NODE = "FORK_NODE";   //分支节点
	public static final String ACTIVITY_TYPE_JOIN_NODE = "JOIN_NODE";   //汇聚节点
	
	//用于生成XML节点的常量
	//root
	public static final String NODE_ROOT = "WorkflowProcess";
	public static final String ATTR_ROOT_ID = "id";
	public static final String ATTR_ROOT_NAME = "name";

	//Activity节点
	public static final String NODE_ACTIVITIES = "Activities";
	public static final String NODE_ACTIVITIE = "Activitie";
	public static final String ATTR_ACTIVITIE_ID = "id";
	public static final String ATTR_ACTIVITIE_TYPE = "type";
	public static final String ATTR_ACTIVITIE_NAME = "name";
	public static final String ATTR_ACTIVITIE_X_COORD = "xCoordinate";
	public static final String ATTR_ACTIVITIE_Y_COORD = "yCoordinate";
	public static final String ATTR_ACTIVITIE_WIDTH = "width";
	public static final String ATTR_ACTIVITIE_HEIGHT = "height";
	public static final String ATTR_ACTIVITIE_BELONGPROCESS = "belongProcess";
	public static final String ATTR_ACTIVITIE_PHASENO = "phaseNo";
	public static final String ATTR_ACTIVITIE_PHASENAME = "phaseName";
	public static final String ATTR_ACTIVITIE_ISINUSE = "isInuse";
	public static final String ATTR_ACTIVITIE_EDITSTATUS = "editStatus";
	public static final String ATTR_ACTIVITIE_TRANPHASENAMES = "tranPhaseNames";
	

	//Transition转移节点
	public static final String NODE_TRANSITIONS = "Transitions";
	public static final String NODE_TRANSITION = "Transition";
	public static final String ATTR_TRANSITION_ID = "id";
	public static final String ATTR_TRANSITION_NAME = "name";
	public static final String ATTR_TRANSITION_FROM = "from";
	public static final String ATTR_TRANSITION_TO = "to";
}
