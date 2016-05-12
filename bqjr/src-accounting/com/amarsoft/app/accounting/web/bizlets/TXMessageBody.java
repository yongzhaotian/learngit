

package com.amarsoft.app.accounting.web.bizlets;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.*;
import com.amarsoft.are.log.Log;
import java.util.*;

public class TXMessageBody
{

    public TXMessageBody(BizObjectClass clazz, int maxSize)
    {
        bizObjectClass = null;
        this.maxSize = 1;
        objects = null;
        bizObjectClass = clazz;
        this.maxSize = maxSize;
        objects = new ArrayList();
    }

    public TXMessageBody(BizObjectClass clazz)
    {
        bizObjectClass = null;
        maxSize = 1;
        objects = null;
        bizObjectClass = clazz;
        maxSize = 1;
        objects = new ArrayList();
    }

    public int size()
    {
        return objects.size();
    }

    public int getMaxSize()
    {
        return maxSize;
    }

    public final BizObjectClass getBizObjectClass()
    {
        return bizObjectClass;
    }

    public BizObject createObject()
    {
        BizObject b = null;
        BizObjectManager m = null;
        if(getRemainRoom() > 0)
        {
            try
            {
                m = JBOFactory.getFactory().getManager(bizObjectClass.getAbsoluteName());
                b = m.newObject();
            }
            catch(JBOException e)
            {
                ARE.getLog().debug(e);
            }
            if(b != null)
                objects.add(b);
        }
        return b;
    }

    public void addObject(BizObject obj)
    {
        if(getRemainRoom() > 0)
            objects.add(obj);
    }

    public void addObject(int index, BizObject obj)
    {
        if(getRemainRoom() > 0)
            objects.add(index, obj);
    }

    public void addAllObjects(BizObject objs[])
    {
        List l = Arrays.asList(objs);
        if(getRemainRoom() >= l.size())
            objects.addAll(l);
        else
            objects.addAll(l.subList(0, getRemainRoom()));
    }

    public void addAllObjects(int index, BizObject objs[])
    {
        List l = Arrays.asList(objs);
        if(getRemainRoom() >= l.size())
            objects.addAll(index, l);
        else
            objects.addAll(index, l.subList(0, getRemainRoom()));
    }

    private int getRemainRoom()
    {
        if(maxSize <= 0)
            return 2147483647;
        else
            return maxSize - size();
    }

    public BizObject getObject(int index)
    {
        BizObject bo = null;
        if(index >= 0 && index < objects.size())
            bo = (BizObject)objects.get(index);
        return bo;
    }

    public void removeObject(int index)
    {
        if(index >= 0 && index < objects.size())
            objects.remove(index);
    }

    public void removeAllObjects()
    {
        objects.clear();
    }

    private BizObjectClass bizObjectClass;
    private int maxSize;
    private ArrayList objects;
}


