package com.amarsoft.app.als.bizobject;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.awe.util.json.JSONObject;

/**
 * @author syang
 * @since 2011-6-15
 * @describe ���󹤾���
 */
public class ObjectHelper {
	private static Map<String,Class<?>> baseDataTypeMap = new HashMap<String,Class<?>>();
	static{
		baseDataTypeMap.put("float",Float.class);
		baseDataTypeMap.put("double",Double.class);
		baseDataTypeMap.put("int",Integer.class);
		baseDataTypeMap.put("long",Long.class);
		baseDataTypeMap.put("short",Short.class);
		baseDataTypeMap.put("char",Character.class);
		baseDataTypeMap.put("byte",Byte.class);
		baseDataTypeMap.put("boolean",Boolean.class);
	}
	/**
	 * ��map���������������object
	 * @param object ���Ŀ�����
	 * @param map ����
	 * @return �����Object
	 * @throws Exception 
	 */
	public static Object fillObjectFromMap(Object object,Map<String,?> map) throws Exception{
		return fillObjectFromMap(object,map,false);
	}
	/***
	 * ��map���������������object
	 * @param object ���Ŀ�����
	 * @param map map����
	 * @param ignoreCase �Ƿ���Դ�Сд
	 * @return �����Object
	 * @throws Exception 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Object fillObjectFromMap(Object object,Map map,boolean ignoreCase) throws Exception{
		Method[] methods = object.getClass().getMethods();
		for(Method method:methods){
			String methodName = method.getName();
			Class[] parameterClass = method.getParameterTypes();
			if(!(methodName.startsWith("set")&&methodName.length()>3))continue;//ֻҪsetXXX����
			if(parameterClass.length!=1)continue;							 //����set����ֻ��һ������
			
			String setField = methodName.substring(3);		//ȡsetXyz�е�Xyz
			setField = setField.substring(0,1).toLowerCase()+setField.substring(1);	//��һ��Сд
			setField = getMapRealKey(map,setField,ignoreCase);//�����Ƿ����ִ�Сд��ȡ��ʵ����Ҫ��key
			Object mapValue = map.get(setField);			//ȡmap�е�ֵ
			if(mapValue==null) continue;					//map��û��ֵ����һ��
			Class<?> p1ClassName = parameterClass[0];	//�β���
			Class<?> p2ClassName = mapValue.getClass();	//ʵ����
			
			//����ǻ����������ͣ���תΪ��װ��
			if(baseDataTypeMap.containsKey(p1ClassName.getName())) p1ClassName = baseDataTypeMap.get(p1ClassName.getName());
			if(p2ClassName.equals(p1ClassName)){//�β�������map����ֵ������ͬʱ���ŵ��� setXyz����
				Object[] args = new Object[1]; 
				args[0] = mapValue;
				method.invoke(object,args);
			}
		}
		return object;
	}
	/**
	 * ��map��ȡ����ʵ��key
	 * @param map map����
	 * @param key �ؼ���
	 * @param IgnoreCase �Ƿ���Դ�Сд
	 * @return
	 */
	private static String getMapRealKey(Map<String,?> map,String key,boolean ignoreCase){
		String newKey = key;
		if(ignoreCase){	//������Դ�Сд������Ҫ��ȥ��map�У��Ǹ����key
			Iterator<String> iterator = map.keySet().iterator();
			while(iterator.hasNext()){
				String curKey  = iterator.next();
				if(newKey.equalsIgnoreCase(curKey)){
					newKey = curKey;
					break;
				}
			}
		}
		return newKey;
	}
	/**
	 * ��Object ����תΪJSONObject��ֻת�������������ͼ�String���֣������Զ����಻ת
	 * @param object
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	public static synchronized JSONObject convert2JSONObject(Object object) throws Exception{
		JSONObject jsonObject = new JSONObject();
		Method[] methods = object.getClass().getMethods();
		for(int i=0;i<methods.length;i++){
			Method method = methods[i];
			String methodName = method.getName();
			Class<?> returnType = method.getReturnType();		//ȡ����ֵ����
			Class<?>[] parameter = method.getParameterTypes();	//ȡ����
			// getX�������1.��������������4λ��2.��get��ʼ��3.��3λ����Ϊ��д��4.�����з���ֵ��5.���������в���
			// isX�����   ��1.��������������3λ��2.��is��ʼ��  3.��2λ����Ϊ��д��4.�����з���ֵ��5.���������в���
			if((returnType.getName().equals(String.class.getName())	//String���ͻ������������
					||baseDataTypeMap.containsKey(returnType.getName())
					||baseDataTypeMap.containsValue(returnType)
				)&&(!"void".equals(returnType.getName())
					&&parameter.length==0
				)&&((methodName.length()>=4
						&&methodName.startsWith("get")
						&&Character.isUpperCase(methodName.charAt(3))
					)||(methodName.length()>=3
						&&methodName.startsWith("is")
						&&Character.isUpperCase(methodName.charAt(2))
				))){
				String fieldName = "";
				if(methodName.startsWith("get")) fieldName = methodName.substring(3);
				else if(methodName.startsWith("is")) fieldName = methodName.substring(2);
				
				String startChar = fieldName.substring(0,1).toLowerCase();
				if(fieldName.length()>1)fieldName=startChar+fieldName.substring(1);
				Object value = method.invoke(object);
				jsonObject.put(fieldName, value);
			}
		}
		return jsonObject;
	}
	/**
	 * ��JBO����������䵽����
	 * @param object:Ҫ������ݵ�Ŀ�����
	 * @param bo:�ṩ���ݵ�JBO����
	 * @return
	 */
	public static Object fillObjectFromJBO(Object object,BizObject bo){
		return fillObjectFromJBO(object,bo,false);
	}
	/**
	 * ��JBO����������䵽����
	 * @param object:Ҫ������ݵ�Ŀ�����
	 * @param bo:�ṩ���ݵ�JBO����
	 * @param IgnoreCase �Ƿ���Դ�Сд
	 * @return
	 * @throws JBOException 
	 */
	public static Object fillObjectFromJBO(Object object,BizObject bo,boolean IgnoreCase){
		Method[] methods = object.getClass().getMethods();
		for(Method method:methods){
			String methodName = method.getName();
			@SuppressWarnings("rawtypes")
			Class[] parameterClass = method.getParameterTypes();
			if(!(methodName.startsWith("set") && methodName.length()>3))continue;//ֻҪsetXXX����
			if(parameterClass.length!=1)continue;							 //����set����ֻ��һ������
			
			String setField = methodName.substring(3);		//ȡsetXyz�е�Xyz
			setField = setField.toUpperCase();	//ȫ��תΪ��д
			Object jboAttributeValue=null;//JBO����ֵ
			try {
				jboAttributeValue = bo.getAttribute(setField).getValue();
			} catch (JBOException e1) {
				//���ﲻ���κδ���,�������JBO�����Ҳ�����������ԡ�
//				ARE.getLog().debug("JBO��ȡ���Գ���!JBOClass=["+bo.getBizObjectClass()+"],Attribute=["+setField+"]");
//				e1.printStackTrace();
			}
			if(jboAttributeValue==null) continue;					//JBO��û�и����ԣ���һ��
			String p1ClassName = parameterClass[0].getName();	//�β���
			String p2ClassName = jboAttributeValue.getClass().getName();	//ʵ����
			
			//����ǻ����������ͣ���תΪ��װ��
			if(baseDataTypeMap.containsKey(p1ClassName)) p1ClassName = baseDataTypeMap.get(p1ClassName).getName();
			
			if(p2ClassName.equals(p1ClassName)){//�β�������map����ֵ������ͬʱ���ŵ��� setXyz����
				try {
					Object[] args = new Object[1]; 
					args[0] = jboAttributeValue;
					method.invoke(object,args);
				}catch(Exception e){ 
					e.printStackTrace();
				}
			}
		}
		return object;
	}
}
