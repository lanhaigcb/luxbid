package com.shop.utils.BeanUtil;

import java.beans.BeanInfo;
import java.beans.IntrospectionException;
import java.beans.Introspector;
import java.beans.PropertyDescriptor;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Map 对象与 JavaBean 对象互转工具类
 */
public class BeanToMapUtil<T>
{
    private BeanToMapUtil()
    {
        //私有的构造方法
    }

    /**
     * 将一个 JavaBean 对象转化为一个 Map
     * @param bean
     * @return
     * @throws IntrospectionException
     * @throws IllegalAccessException
     * @throws InvocationTargetException
     */
    public static Map<String, Object> convertBean2Map(Object bean) {
        Map<String, Object> returnMap = new HashMap<String, Object>();
        try{
            Class<? extends Object> type = bean.getClass();
            BeanInfo beanInfo = Introspector.getBeanInfo(type);

            PropertyDescriptor[] propertyDescriptors = beanInfo.getPropertyDescriptors();
            for (int i = 0; i < propertyDescriptors.length; i++)
            {
                PropertyDescriptor descriptor = propertyDescriptors[i];
                String propertyName = descriptor.getName();
                if (!"class".equals(propertyName))
                {
                    Method readMethod = descriptor.getReadMethod();
                    Object result = readMethod.invoke(bean, new Object[0]);
                    if (result != null)
                    {
                        returnMap.put(propertyName, result);
                    }
                    else
                    {
                        returnMap.put(propertyName, null);
                    }
                }
            }
        }catch (Exception e){
            e.printStackTrace();
        }
        return returnMap;
    }


    /**
     * 将 List<JavaBean>对象转化为List<Map>
     * @param beanList
     * @return
     * @throws Exception
     */
    public static <T> List<Map<String, Object>> convertListBean2ListMap(List<T> beanList)
            throws Exception
    {
        List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();
        for (int i = 0, n = beanList.size(); i < n; i++)
        {
            Object bean = beanList.get(i);
            Map<String, Object> map = convertBean2Map(bean);
            mapList.add(map);
        }
        return mapList;
    }
}