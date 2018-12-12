package com.shop.admin.vo.staff;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2017/4/17.
 */
public class TreeVo2 {

    /**
     * 树节点暂时的文字
     */
    private String text;

    /**
     * id
     */
    private int tag;

    private Map<String,Object> state=new HashMap<String, Object>();

    /**
     * 子节点
     */
    private List<TreeVo2> nodes;

    /**
     * 是否选中
     */
    private boolean checked;

    public boolean isChecked() {
        return checked;
    }

    public void setChecked(boolean checked) {
        this.checked = checked;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public int getTag() {
        return tag;
    }

    public void setTag(int tag) {
        this.tag = tag;
    }

    public List<TreeVo2> getNodes() {
        return nodes;
    }

    public void setNodes(List<TreeVo2> nodes) {
        this.nodes = nodes;
    }

    public Map<String, Object> getState() {
       if(checked){
           state.put("checked",true);
       }else{
           state.put("checked",false);
       }
        return state;
    }


}
