package com.shop.admin.vo.staff;


import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.model.staff.StaffRole;

import java.util.ArrayList;
import java.util.List;



public class TreeUtil {
	
	
	/**
	 * 将function对象转换成 树
	 * @param functionInfos
	 * @return
	 */
	public static List<TreeVo> functionInfoToTreeVo(List<FunctionInfo> functionInfos, Integer id){
		List<TreeVo> treeVos = new ArrayList<TreeVo>();
		for(FunctionInfo info : functionInfos){
			TreeVo treeVo = new TreeVo();
			treeVo.setId(info.getId());
			
			if(null == info.getId() && null == id){
				treeVo.setState(TreeVo.STATE_OPNE);
				treeVo.setChecked(true);
			}
			
			if(null != info.getId() && null != id && info.getId().equals(id)){
				treeVo.setState(TreeVo.STATE_OPNE);
				treeVo.setChecked(true);
			}
			
			treeVo.setText(info.getName());
			treeVo.setUrl(info.getUri());
			List<TreeVo> childrenList = null;
			if(null != info.getChildren() && info.getChildren().size() != 0){
				childrenList = functionInfoToTreeVo(info.getChildren(),id);
			}
			treeVo.setChildren(childrenList);
			treeVos.add(treeVo);
		}
		return treeVos;
		
	}

	/**
	 * 将function对象转换成 树
	 * @param functionInfos
	 * @return
	 */
	public static List<TreeVo2> functionInfoToTreeVo2(List<FunctionInfo> functionInfos,Integer id){
		List<TreeVo2> treeVos = new ArrayList<TreeVo2>();
		for(FunctionInfo info : functionInfos){
			TreeVo2 treeVo = new TreeVo2();
			treeVo.setTag(info.getId());
			treeVo.setText(info.getName());
			List<TreeVo2> childrenList = null;
			if(null != info.getChildren() && info.getChildren().size() != 0){
				childrenList = functionInfoToTreeVo2(info.getChildren(),id);
			}
			treeVo.setNodes(childrenList);
			treeVos.add(treeVo);
		}
		return treeVos;

	}
	
	/**
	 * 将function对象转换成 树
	 * @param functionInfos
	 * @return
	 */
	public static List<TreeVo2> functionInfoToTreeVo(List<FunctionInfo> functionInfos,StaffRole staffRole){
		
		List<TreeVo2> treeVos = new ArrayList<TreeVo2>();

		for(FunctionInfo info : functionInfos){//遍历权限
			TreeVo2 treeVo = new TreeVo2();
			treeVo.setTag(info.getId());
			treeVo.setText(info.getName());

			List<TreeVo2> nodes = null;
			if(null != staffRole.getFunctionInfos()){
				for(FunctionInfo functionInfo : staffRole.getFunctionInfos()){
					if(functionInfo.getId().intValue() == info.getId().intValue()){//当前角色拥有该权限则勾选
						treeVo.setChecked(true);
						break;
					}
				}
			}
			if(null != info.getChildren() && info.getChildren().size() != 0){//递归封装
				nodes = functionInfoToTreeVo(info.getChildren(),staffRole);
			}
			
			treeVo.setNodes(nodes);
			treeVos.add(treeVo);
		}
		return treeVos;
	}

}
