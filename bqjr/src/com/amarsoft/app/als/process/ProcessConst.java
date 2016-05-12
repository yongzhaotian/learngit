package com.amarsoft.app.als.process;

public class ProcessConst {
	
	public static final String BUSINESS_PROCESS_APPLY_NEWLY = "0010";//待处理申请阶段类型标识
	public static final String BUSINESS_PROCESS_APPLY_PASSED = "1000";//审批通过申请阶段类型标识
	public static final String BUSINESS_PROCESS_APPLY_NEGATIVE = "8000";//被否决申请阶段类型标识
	public static final String BUSINESS_PROCESS_APPLY_ENRICHSTUFF = "3000";//退回补充资料申请阶段类型标识
	
	public static final String ORGTYPE_CODE = "OrgType";//机构类型属性代码
	public static final String ORGTYPE_ALL = "ALL"; //机构类型:所有机构
	public static final String ORGTYPE_CURRENT = "CURRENT"; //机构类型:当前机构
	
	public static final String UNFINISHED_TASK_LIST_BUTTON = "ButtonOfUnfinishedTask"; //未完成工作列表显示按钮
	public static final String FINISHED_TASK_LIST_BUTTON = "ButtonOfFinishedTask"; //已完成工作列表显示按钮
	
	public static final String BUSINESS_APPLY_CODENO = "ApplyType"; //CODE_LIBRARY中定义的流程相关对象所属代码编号
	public static final String BUSINESS_APPROVE_CODENO = "ApproveType"; //CODE_LIBRARY中定义的流程相关对象所属代码编号
	public static final String BUSINESS_OBJECT_CLASS_FIELD = "Attribute1"; //CODE_LIBRARY中定义的流程业务对象JBO属性所在字段
	public static final String BUSINESS_TASK_CLASS_FIELD = "Attribute3"; //CODE_LIBRARY中定义的流程任务对象JBO属性所在字段
	public static final String BUSINESS_OPINION_CLASS_FIELD = "Attribute4"; //CODE_LIBRARY中定义的流程意见对象JBO属性所在字段
	
	public static final String NODE_ALIAS_CODE = "Alias"; //流程节点别名属性代码

}
