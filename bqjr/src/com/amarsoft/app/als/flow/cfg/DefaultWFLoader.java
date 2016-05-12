package com.amarsoft.app.als.flow.cfg;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.amarsoft.app.als.flow.cfg.model.Activity;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcessConst;
import com.amarsoft.app.als.flow.cfg.model.Transition;
import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.log.Log;

public class DefaultWFLoader implements WFLoader {

	private JBOFactory factory = JBOFactory.getFactory();
	private BizObjectManager bom;
	private BizObjectQuery query;
	
	private Log logger = ARE.getLog();
	
	public BusinessProcess loadWorkFlow(String flowNo) throws JBOException {
		BusinessProcess bp = null;
		BizObject flowCatalogBo = loadWorkFlowCatalog(flowNo);//载入流程定义信息
		if(flowCatalogBo == null || flowCatalogBo.getAttribute("FlowName").isNull()){
			logger.debug("根据流程号[" + flowNo + "]找不到必须的流程定义信息！");
			return null;
		}
		bp = new BusinessProcess(flowNo, flowCatalogBo.getAttribute("FlowName").getString());
		List activities = loadActivities(flowNo);//载入该流程的所有节点
		bp.setActivities(activities);
		List transitions = loadTransitions(activities);//载入转移信息
		bp.setTransitions(transitions);
		
		resetActivities(activities); //设置节点的坐标信息
		
		persistActivities(activities); //将节点的图形信息写入数据库
		
		return bp;
	}
	
	/**
	 * 获取当前流程在流程库中的定义
	 * @param flowNo 流程编号
	 * @return true/false
	 * @throws JBOException
	 */
	private BizObject loadWorkFlowCatalog(String flowNo) throws JBOException {
		String boClass = "jbo.sys.FLOW_CATALOG";
		String sql = "FlowNo=:FlowNo";
		bom = factory.getManager(boClass);
		query = bom.createQuery(sql).setParameter("FlowNo", flowNo);
		BizObject flowCatalogBo = query.getSingleResult(false);
		return flowCatalogBo;
	}
	
	/**
	 * 将FLOW_MODEL中的流程阶段转换为Activity
	 * @param flowNo
	 * @return
	 * @throws JBOException
	 */
	private List loadActivities(String flowNo) throws JBOException {
		List activities = new ArrayList();
		String boClass = "jbo.sys.FLOW_MODEL";
		String sql = "FlowNo=:FlowNo order by PhaseNo";
		bom = factory.getManager(boClass);
		query = bom.createQuery(sql).setParameter("FlowNo", flowNo);
		List workFlowModels = query.getResultList(false);
		
		if(workFlowModels == null || workFlowModels.size() == 0){
			return null;
		}
		
		for(int i = 0; i < workFlowModels.size(); i++){
			BizObject bo = (BizObject)workFlowModels.get(i);
			Activity activity = new Activity();
			activity.setId(String.valueOf(i + 1));  //序号
			String phaseNo = bo.getAttribute("PhaseNo").getString();
			if("0010".equals(phaseNo)){//起始节点
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_START_NODE);
			} else if ("3000".equals(phaseNo)){//退回补充资料为汇聚节点
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_JOIN_NODE);
			} else if("1000".equals(phaseNo) || "8000".equals(phaseNo)){//批准或否决节点为结束节点
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_END_NODE);
			} else{
				//默认其他节点的类型暂时为任务节点
				activity.setType(BusinessProcessConst.ACTIVITY_TYPE_NODE);
			}
			
			if(bo.getAttribute("Name").isNull()){
				activity.setName(bo.getAttribute("PhaseName").getString());
			} else {
				activity.setName(bo.getAttribute("Name").getString());
			}
			activity.setBelongProcess(bo.getAttribute("FlowNo").getString());
			activity.setPhaseNo(bo.getAttribute("PhaseNo").getString());
			activity.setPhaseName(bo.getAttribute("PhaseName").getString());
			activity.setPhaseType(bo.getAttribute("PhaseType").getString());
			activity.setInitScript(bo.getAttribute("InitScript").getString());
			activity.setChoiceScript(bo.getAttribute("ChoiceScript").getString());
			activity.setActionScript(bo.getAttribute("ActionScript").getString());
			activity.setPostScript(bo.getAttribute("PostScript").getString());
			activity.setEditStatus(bo.getAttribute("Attribute7").getString());
			activity.setIsInuse(bo.getAttribute("Attribute8").getString());
			activity.setRealPostScript(bo.getAttribute("Attribute10").getString());
			activity.setxCoordinate(bo.getAttribute("XCOORDINATE").getString());
			activity.setyCoordinate(bo.getAttribute("YCOORDINATE").getString());
			activity.setWidth(bo.getAttribute("Width").getString());
			activity.setHeight(bo.getAttribute("Height").getString());
			
			//置默认值
			if(activity.getIsInuse() == null) activity.setIsInuse("1");
			if(activity.getEditStatus() == null) activity.setEditStatus("00");
			activities.add(activity);
		}
		return activities;
	}
	
	/**
	 * 根据Activity生成转移（连线）
	 * @param activities
	 * @return
	 */
	private List loadTransitions(List activities){
		List transitions = new ArrayList();
		if(activities != null && activities.size() > 0){
			int len = activities.size();
			for(int i = 0; i < activities.size(); i++){
				Activity activity = (Activity)activities.get(i);
				if(activity.getIsInuse().equals("0")) continue;//如果节点被屏蔽，则不为其生成连线
				String postScript = activity.getPostScript();
				if(postScript == null) continue;
				String[] phaseNos = postScript.split("'");
				String tranPhaseNames = "";
				int count = 0; //记录分支数目
				for(int j = 0; j < phaseNos.length; j++){
					String phaseNo = phaseNos[j];
					Activity tmpActivity = new Activity(phaseNo); //Activity以PhaseNo标识
					// 判断是否为4个字符的流程阶段号，且在所有流程阶段中存在，则生成转移
					if (Pattern.matches("\\d{4}", phaseNo) && activities.contains(tmpActivity)) {
						Activity desActivity = (Activity)activities.get(activities.indexOf(tmpActivity));
						Activity realDesActivity = findRealDesActivity(activities, desActivity);
						tranPhaseNames += "," + realDesActivity.getPhaseName();
						Transition transition = new Transition(activity, realDesActivity);
						transition.setId(String.valueOf(++len));
						transitions.add(transition);
						count++;
					}
				}
				if(!"".equals(tranPhaseNames)) activity.setTranPhaseNames(tranPhaseNames.substring(1));
				//如果改节点的后续阶段多于1个则设置该节点的类型为分支节点
				if(count > 1) activity.setType(BusinessProcessConst.ACTIVITY_TYPE_FORK_NODE);
			}
		}
		return transitions;
	}
	
	/**
	 * 寻找真正的后继节点
	 * @param activities
	 * @param curActivity
	 * @return
	 */
	private Activity findRealDesActivity(List activities, Activity curActivity){
		if(activities == null || activities.size() == 0 || curActivity == null) return null;
		Activity realDesActivity = null;
		Activity nextActivity = null;
		if("1".equals(curActivity.getIsInuse())){//节点未被屏蔽
			realDesActivity = curActivity;
		} else {//节点被屏蔽
			if(curActivity.getRealPostScript() == null || "".equals(curActivity.getRealPostScript().trim())){//当前节点未配置直接跳转节点
				realDesActivity = curActivity;
			} else {//当前节点存在直接后继跳转节点
				Activity tmpActivity = new Activity(curActivity.getRealPostScript()); //Activity以PhaseNo标识
				if(activities.indexOf(tmpActivity) > -1){
					nextActivity = (Activity)activities.get(activities.indexOf(tmpActivity));
					realDesActivity = findRealDesActivity(activities, nextActivity);
				} else {
					logger.error("[阶段" + curActivity.getPhaseName() + "(" + curActivity.getPhaseNo() + ")找不到有效的直接跳转:"+ curActivity.getRealPostScript() +"]");	
				}
			}
		}
		
		return realDesActivity;
	}
	
	/**
	 * 设置节点的坐标信息
	 * @param activities
	 */
	private void resetActivities(List activities){
		if(activities == null || activities.size() == 0)
			return;
		
		int count = activities.size();//节点数目
		
		for(int i = 0; i < count; i++){
			Activity activity = (Activity)activities.get(i);
			int x = Math.abs(i/LINE_NODE_COUNT);
			int y = Math.abs((x%2)*(LINE_NODE_COUNT-1) - (i - x*LINE_NODE_COUNT)%LINE_NODE_COUNT);
			
			if(activity.getxCoordinate() == null || "".equals(activity.getxCoordinate()))
				activity.setxCoordinate(String.valueOf(ACTIVITY_NODE_FIRST_XCOORDINATE + y*(ACTIVITY_NODE_INCREAMENT + ACTIVITY_NODE_WIDTH)));
			if(activity.getyCoordinate() == null || "".equals(activity.getyCoordinate()))
				activity.setyCoordinate(String.valueOf(ACTIVITY_NODE_FIRST_YCOORDINATE + x*(ACTIVITY_LINE_INCREAMENT + ACTIVITY_NODE_HEIGHT)));
			if(activity.getWidth() == null || "".equals(activity.getWidth()))
				activity.setWidth(String.valueOf(ACTIVITY_NODE_WIDTH));
			if(activity.getHeight() == null || "".equals(activity.getHeight()))
				activity.setHeight(String.valueOf(ACTIVITY_NODE_HEIGHT));
		}
	}
	
	/**
	 * 将流程的图形信息写入数据库
	 */
	public void persistWorkFlow(BusinessProcess bp) throws JBOException{
		persistActivities(bp.getActivities());
	}
	
	/**
	 * 将节点的图形信息写入数据库
	 * @param activities
	 */
	private void persistActivities(List activities) throws JBOException {
		if(activities == null || activities.size() == 0) return;
		String boClass = "jbo.sys.FLOW_MODEL";
		String sql = "FlowNo=:FlowNo and PhaseNo=:PhaseNo";
		bom = factory.getManager(boClass);
		for(int i = 0; i < activities.size(); i++){
			Activity activity = (Activity)activities.get(i);
			query = bom.createQuery(sql)
					   .setParameter("FlowNo", activity.getBelongProcess())
					   .setParameter("PhaseNo", activity.getPhaseNo());
			BizObject activityBo = query.getSingleResult(true);
			if(activityBo == null) continue;
			activityBo.setAttributeValue("ID", activity.getId());
			activityBo.setAttributeValue("Name", activity.getName());
			activityBo.setAttributeValue("Type", activity.getType());
			activityBo.setAttributeValue("XCoordinate", activity.getxCoordinate());
			activityBo.setAttributeValue("YCoordinate", activity.getyCoordinate());
			activityBo.setAttributeValue("Width", activity.getWidth());
			activityBo.setAttributeValue("Height", activity.getHeight());
			bom.saveObject(activityBo);
		}
	}
	
	private static final int LINE_NODE_COUNT = 4;//定义每行显示的节点数,用于初始化流程图时简单定位
	private static final int ACTIVITY_NODE_WIDTH = 100;//默认节点的显示宽度
	private static final int ACTIVITY_NODE_HEIGHT = 30;//默认节点的显示高度
	private static final int ACTIVITY_NODE_FIRST_XCOORDINATE = 20;//第一个节点的默认位置x坐标
	private static final int ACTIVITY_NODE_FIRST_YCOORDINATE = 60;//第一个节点的默认位置y坐标
	private static final int ACTIVITY_NODE_INCREAMENT = 100;//节点之间的间距
	private static final int ACTIVITY_LINE_INCREAMENT = 100;//节点之间的行距

}
