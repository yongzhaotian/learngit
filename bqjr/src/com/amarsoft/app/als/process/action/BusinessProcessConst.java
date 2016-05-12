package com.amarsoft.app.als.process.action;

/**
 * 本类定义流程状态,任务状态的常量
 * @author zszhang
 * @since 2011-8-2
 *
 */
public class BusinessProcessConst {
	
	public static final String BUSINESS_PROCESS_UNFINISH = "0";          //任务状态：未提交
	public static final String BUSINESS_PROCESS_FINISHED = "1";          //任务状态：已提交
	public static final String BUSINESS_PROCESS_END = "2";               //任务状态：流程终结
	public static final String BUSINESS_PROCESS_SECRETARY = "7";         //任务状态：贷审会秘书
	public static final String BUSINESS_PROCESS_VOTE = "8";              //任务状态：贷审会
	public static final String BUSINESS_PROCESS_TASKPOOL = "9";          //任务状态：任务池
	public static final String BUSINESS_PROCESS_CLOSE = "99";            //任务状态：关闭	
	
	public static final String UNFINISHED = "0";                         //投票状态：未投票
	public static final String FINISHED = "1";                           //投票状态：已投票
	
	public static final String FLOWSTATE_APPLY            = "1010";      //流程状态：发起申请
	public static final String FLOWSTATE_APPROVE          = "1020";      //流程状态：审查审批
	public static final String FLOWSTATE_WITHDRAW         = "1030";      //流程状态：主动撤回
	public static final String FLOWSTATE_RETURN           = "1040";      //流程状态：退回
	public static final String FLOWSTATE_SUPPLYMENT       = "1050";      //流程状态：补充资料
	public static final String FLOWSTATE_RECONSIDERATION  = "1060";      //流程状态：再议
	public static final String FLOWSTATE_RECONSIDER       = "1070";      //流程状态：发起复议
	public static final String FLOWSTATE_POOL             = "1080";      //流程状态：任务池
	public static final String FLOWSTATE_VOTE             = "1090";      //流程状态：会签
	public static final String FLOWSTATE_MCHECK           = "2000";      //流程状态：贷审会主任
	public static final String FLOWSTATE_SECRETARY        = "2010";      //流程状态：贷审会秘书
	public static final String FLOWSTATE_MAPPROVE         = "3000";      //流程状态：一票否决人
	public static final String FLOWSTATE_AGREE            = "1000";      //流程状态：同意
	public static final String FLOWSTATE_REJECT           = "8000";      //流程状态：否决

	public static final String FORKSTATE_START = "0";                    //分支状态：分支起始
	public static final String FORKSTATE_MIDDLE = "1";                   //分支状态：分支中



}
