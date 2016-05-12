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
 * @describe 对象工具类
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
	 * 把map对象中数据填充至object
	 * @param object 填充目标对象
	 * @param map 对象
	 * @return 填充后的Object
	 * @throws Exception 
	 */
	public static Object fillObjectFromMap(Object object,Map<String,?> map) throws Exception{
		return fillObjectFromMap(object,map,false);
	}
	/***
	 * 把map对象中数据填充至object
	 * @param object 填充目标对象
	 * @param map map对象
	 * @param ignoreCase 是否忽略大小写
	 * @return 填充后的Object
	 * @throws Exception 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Object fillObjectFromMap(Object object,Map map,boolean ignoreCase) throws Exception{
		Method[] methods = object.getClass().getMethods();
		for(Method method:methods){
			String methodName = method.getName();
			Class[] parameterClass = method.getParameterTypes();
			if(!(methodName.startsWith("set")&&methodName.length()>3))continue;//只要setXXX方法
			if(parameterClass.length!=1)continue;							 //限制set方法只有一个参数
			
			String setField = methodName.substring(3);		//取setXyz中的Xyz
			setField = setField.substring(0,1).toLowerCase()+setField.substring(1);	//第一个小写
			setField = getMapRealKey(map,setField,ignoreCase);//根据是否区分大小写，取出实际需要的key
			Object mapValue = map.get(setField);			//取map中的值
			if(mapValue==null) continue;					//map中没有值，下一个
			Class<?> p1ClassName = parameterClass[0];	//形参类
			Class<?> p2ClassName = mapValue.getClass();	//实参类
			
			//如果是基础数据类型，则转为封装类
			if(baseDataTypeMap.containsKey(p1ClassName.getName())) p1ClassName = baseDataTypeMap.get(p1ClassName.getName());
			if(p2ClassName.equals(p1ClassName)){//形参类名与map域中值类名相同时，才调用 setXyz方法
				Object[] args = new Object[1]; 
				args[0] = mapValue;
				method.invoke(object,args);
			}
		}
		return object;
	}
	/**
	 * 从map中取出真实的key
	 * @param map map对象
	 * @param key 关键字
	 * @param IgnoreCase 是否忽略大小写
	 * @return
	 */
	private static String getMapRealKey(Map<String,?> map,String key,boolean ignoreCase){
		String newKey = key;
		if(ignoreCase){	//如果忽略大小写，则需要进去找map中，那个真的key
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
	 * 把Object 对象转为JSONObject，只转换基础数据类型及String部分，其他自定义类不转
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
			Class<?> returnType = method.getReturnType();		//取返回值类型
			Class<?>[] parameter = method.getParameterTypes();	//取参数
			// getX的情况：1.方法名长度至少4位，2.以get开始，3.第3位必需为大写，4.必需有返回值，5.方法不能有参数
			// isX的情况   ：1.方法名长度至少3位，2.以is开始，  3.第2位必需为大写，4.必需有返回值，5.方法不能有参数
			if((returnType.getName().equals(String.class.getName())	//String类型或基础数据类型
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
	 * 将JBO对象数据填充到对象
	 * @param object:要填充数据的目标对象
	 * @param bo:提供数据的JBO对象
	 * @return
	 */
	public static Object fillObjectFromJBO(Object object,BizObject bo){
		return fillObjectFromJBO(object,bo,false);
	}
	/**
	 * 将JBO对象数据填充到对象
	 * @param object:要填充数据的目标对象
	 * @param bo:提供数据的JBO对象
	 * @param IgnoreCase 是否忽略大小写
	 * @return
	 * @throws JBOException 
	 */
	public static Object fillObjectFromJBO(Object object,BizObject bo,boolean IgnoreCase){
		Method[] methods = object.getClass().getMethods();
		for(Method method:methods){
			String methodName = method.getName();
			@SuppressWarnings("rawtypes")
			Class[] parameterClass = method.getParameterTypes();
			if(!(methodName.startsWith("set") && methodName.length()>3))continue;//只要setXXX方法
			if(parameterClass.length!=1)continue;							 //限制set方法只有一个参数
			
			String setField = methodName.substring(3);		//取setXyz中的Xyz
			setField = setField.toUpperCase();	//全部转为大写
			Object jboAttributeValue=null;//JBO属性值
			try {
				jboAttributeValue = bo.getAttribute(setField).getValue();
			} catch (JBOException e1) {
				//这里不做任何处理,允许出现JBO对象找不到对象的属性。
//				ARE.getLog().debug("JBO获取属性出错!JBOClass=["+bo.getBizObjectClass()+"],Attribute=["+setField+"]");
//				e1.printStackTrace();
			}
			if(jboAttributeValue==null) continue;					//JBO中没有该属性，下一个
			String p1ClassName = parameterClass[0].getName();	//形参类
			String p2ClassName = jboAttributeValue.getClass().getName();	//实参类
			
			//如果是基础数据类型，则转为封装类
			if(baseDataTypeMap.containsKey(p1ClassName)) p1ClassName = baseDataTypeMap.get(p1ClassName).getName();
			
			if(p2ClassName.equals(p1ClassName)){//形参类名与map域中值类名相同时，才调用 setXyz方法
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
