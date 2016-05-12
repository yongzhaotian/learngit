package com.amarsoft.app.als.flow.cfg;

import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import com.amarsoft.app.als.flow.cfg.model.Activity;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcess;
import com.amarsoft.app.als.flow.cfg.model.BusinessProcessConst;
import com.amarsoft.app.als.flow.cfg.model.Transition;
import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;

public class WFConverterByDom{

	private Log logger = ARE.getLog();
	
	public Document convertProcessToXML(BusinessProcess bp) {
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		DocumentBuilder builder = null;
		try{
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException e) { 
			logger.debug(e.getMessage(), e);
		} 
		
		Document doc = builder.newDocument();
		//建立XML文档内容
		//建立根元素
		Element root = doc.createElement(BusinessProcessConst.NODE_ROOT);
		root.setAttribute(BusinessProcessConst.ATTR_ROOT_ID, bp.getProcessID());
		root.setAttribute(BusinessProcessConst.ATTR_ROOT_NAME, bp.getProcessName());
		doc.appendChild(root);
		
		//建立Activities元素
		List activities = bp.getActivities();
		if(activities != null && activities.size() > 0){
			Element activitiesNode = doc.createElement(BusinessProcessConst.NODE_ACTIVITIES);
			root.appendChild(activitiesNode);
			for(int i = 0; i < activities.size(); i++){
				Activity activity = (Activity)activities.get(i);
				Element activityNode = doc.createElement(BusinessProcessConst.NODE_ACTIVITIE);
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_ID, activity.getId());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_NAME, activity.getName());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_TYPE, activity.getType());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_X_COORD, activity.getxCoordinate());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_Y_COORD, activity.getyCoordinate());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_WIDTH, activity.getWidth());
				activityNode.setAttribute(BusinessProcessConst.ATTR_ACTIVITIE_HEIGHT, activity.getHeight());
				activitiesNode.appendChild(activityNode);
			}
		}
		
		//建立Transition元素
		List transitions = bp.getTransitions();
		if(transitions !=null && transitions.size() > 0){
			Element transitionsNode = doc.createElement(BusinessProcessConst.NODE_TRANSITIONS);
			root.appendChild(transitionsNode);
			for(int i = 0; i < transitions.size(); i++){
				Transition transition = (Transition)transitions.get(i);
				Element transitionNode = doc.createElement(BusinessProcessConst.NODE_TRANSITION);
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_ID, transition.getId());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_NAME, transition.getName());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_FROM, transition.getFromActivity().getId());
				transitionNode.setAttribute(BusinessProcessConst.ATTR_TRANSITION_TO, transition.getToActivity().getId());
				transitionsNode.appendChild(transitionNode);
			}
		}
		
		return doc;
	}
}
