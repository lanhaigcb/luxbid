/**
 *
 */
package com.shop.admin.controller.staff;

import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.security.service.SecurityStaffRoleCacheService;
import com.shop.admin.security.staff.AuthorityVo;
import com.shop.admin.service.staff.FunctionInfoService;
import com.shop.admin.vo.staff.TreeUtil;
import com.shop.admin.vo.staff.TreeVo2;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class FunctionInfoController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(FunctionInfoController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private FunctionInfoService functionInfoService;

    @RequestMapping(value = "functionInfo/index")
    @OperatorLogger(operatorName = "进入权限管理")
    public ModelAndView index(String status) {
        ModelAndView mv = new ModelAndView("staff/function_index");
        return mv;
    }

	/*@RequestMapping(value = "functionInfo/tree")
    @ResponseBody
	public Map<String, Object> tree(HttpServletRequest request,HttpServletResponse response,Integer parentId){
		List<FunctionInfo> functionInfos = functionInfoService.findFunctionInfosByParenId(parentId);
		FunctionInfo info = new FunctionInfo();
		info.setId(1);
		info.setName("功能树");
		info.setChildren(functionInfos);
		
		List<FunctionInfo> infos = new ArrayList<FunctionInfo>();
		infos.add(info);
		List<TreeVo> treeVos = TreeUtil.functionInfoToTreeVo(infos, parentId);
		Map<String, Object> result = new HashMap<String, Object>();
        result.put("treeVos", treeVos);
        return result;
	}*/

    @RequestMapping(value = "functionInfo/tree")
    @OperatorLogger(operatorName = "查看权限树")
    @ResponseBody
    public Map<String, Object> tree(HttpServletRequest request, HttpServletResponse response, Integer parentId) {
        List<FunctionInfo> functionInfos = functionInfoService.findFunctionInfosByParenId(parentId);
        FunctionInfo info = new FunctionInfo();
        info.setId(1);
        info.setName("功能树");
        info.setChildren(functionInfos);

        List<FunctionInfo> infos = new ArrayList<FunctionInfo>();
        infos.add(info);
        List<TreeVo2> treeVos = TreeUtil.functionInfoToTreeVo2(infos, parentId);
        Map<String, Object> result = new HashMap<String, Object>();
        result.put("treeVos", treeVos);
        return result;
    }

    /***
     * 列表
     *
     * @return
     */
    @RequestMapping(value = "functionInfo/list")
    @OperatorLogger(operatorName = "查看权限列表")
    @ResponseBody
    public Map<String, Object> list(Integer page, Integer rows, Integer parentId) {

        total = functionInfoService.getCountByParenId(parentId);

        list = functionInfoService.findPageFunctionInfosByParenId(parentId, getFrom(page, rows), total);

        return getResultMap();
    }

    /***
     * 列表
     *
     * @return
     */
    @RequestMapping(value = "functionInfo/roleFunction")
    @OperatorLogger(operatorName = "查看角色权限关系")
    @ResponseBody
    public Map<String, Object> roleFunction(Integer roleId) {

        //list = functionInfoService.findFunctionByRoleId();

        return getResultMap();
    }

    @RequestMapping(value = "functionInfo/addInput")
    @OperatorLogger(operatorName = "进入添加权限页面")
    public ModelAndView addInput(HttpServletRequest request, HttpServletResponse response, Integer parentId) {
        ModelAndView mv = new ModelAndView("staff/function_add");
        mv.addObject("parentId", parentId);
        return mv;
    }

    @RequestMapping(value = "functionInfo/add")
    @OperatorLogger(operatorName = "添加权限")
    @ResponseBody
    public Map<String, Object> add(HttpServletRequest request, HttpServletResponse response, String name, String uri, boolean enable, Integer parentId) {
        try {
            FunctionInfo info = functionInfoService.addFunctionInfo(name, uri, enable, parentId);
            result = true;
            message = messageSource.getMessage("add.success");

            List<AuthorityVo> vos = functionInfoService.loadResourceDefine(info.getId());//获取角色权限集合
            SecurityStaffRoleCacheService.updateAuthorityByFunctionInfo(info, vos);//更新角色权限
        } catch (StaffException e) {
            logger.error(e.getMessage());
            result = false;
            message = e.getMessage();
            logger.error(e.getMessage());
        } catch (Exception e) {
            result = false;
            logger.error(e.getMessage());
            message = messageSource.getMessage("add.failed");
        }

        return getResultMap();
    }


    @RequestMapping(value = "functionInfo/updateInput")
    @OperatorLogger(operatorName = "进入修改权限页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer id) {

        ModelAndView mv = new ModelAndView("staff/function_edit");
        FunctionInfo functionInfo = functionInfoService.getFunctionInfoById(id);
        mv.addObject("functionInfo", functionInfo);
        return mv;
    }

    @RequestMapping(value = "functionInfo/update")
    @OperatorLogger(operatorName = "修改权限")
    @ResponseBody
    public Map<String, Object> update(HttpServletRequest request, HttpServletResponse response, Integer id, String uri, String name) {

        try {
            FunctionInfo info = functionInfoService.updateFunctionInfo(id, name, uri);
            result = true;
            message = messageSource.getMessage("update.success");

            List<AuthorityVo> vos = functionInfoService.loadResourceDefine(info.getId());//获取权限集合
            SecurityStaffRoleCacheService.updateAuthorityByFunctionInfo(info, vos);//更新角色权限的缓存
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            logger.error(e.getMessage());
            result = false;
            message = messageSource.getMessage("update.failed");
        }

        return getResultMap();
    }

    @RequestMapping(value = "functionInfo/enable")
    @OperatorLogger(operatorName = "启用权限")
    @ResponseBody
    public Map<String, Object> enable(HttpServletRequest request, HttpServletResponse response, Integer functionInfoId) {
        try {
            functionInfoService.enable(functionInfoId);
            result = true;
            message = messageSource.getMessage("enable.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            logger.error(e.getMessage());
            result = false;
            message = messageSource.getMessage("enable.failed");
        }

        return getResultMap();
    }

    @RequestMapping(value = "functionInfo/disable")
    @OperatorLogger(operatorName = "禁用权限")
    @ResponseBody
    public Map<String, Object> disable(HttpServletRequest request, HttpServletResponse response, Integer functionInfoId) {
        try {
            functionInfoService.disable(functionInfoId);
            result = true;
            message = messageSource.getMessage("disable.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            logger.error(e.getMessage());
            result = false;
            message = messageSource.getMessage("disable.failed");
        }
        return getResultMap();
    }
}
