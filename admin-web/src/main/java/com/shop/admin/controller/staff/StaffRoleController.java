/**
 *
 */
package com.shop.admin.controller.staff;


import com.alibaba.fastjson.JSON;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.FunctionInfo;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.security.service.SecurityStaffRoleCacheService;
import com.shop.admin.service.staff.FunctionInfoService;
import com.shop.admin.service.staff.StaffRoleService;
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
import java.util.List;
import java.util.Map;


/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class StaffRoleController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(StaffRoleController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private StaffRoleService staffRoleService;

    @Autowired
    private FunctionInfoService functionInfoService;

    @RequestMapping(value = "staffRole/index")
    @OperatorLogger(operatorName = "进入角色管理")
    public ModelAndView index(String status) {
        ModelAndView mv = new ModelAndView("staff/role_index");
        return mv;
    }

    /***
     * 列表
     * @return
     */
    @RequestMapping(value = "staffRole/list")
    @OperatorLogger(operatorName = "查看角色列表")
    @ResponseBody
    public Map<String, Object> list(HttpServletRequest request, HttpServletResponse response, Integer page, Integer rows) {

        total = (int) staffRoleService.getCount();
        if (total > 0) {
            list = staffRoleService.listAll(getFrom(page, rows), total);
        }
        return getResultMap();
    }

    @RequestMapping(value = "staffRole/addInput")
    @OperatorLogger(operatorName = "进入添加角色页面")
    public ModelAndView addInput() {

        ModelAndView mv = new ModelAndView("staff/role_add");
        List<StaffRole> staffRoles = staffRoleService.listAll();
        mv.addObject("roles", staffRoles);
        return mv;
    }

    @RequestMapping(value = "staffRole/add")
    @OperatorLogger(operatorName = "添加角色")
    @ResponseBody
    public Map<String, Object> add( boolean enable, String name, String enName) {
        try {
            staffRoleService.addStaffRole(enable, name, enName);
            result = true;
            message = messageSource.getMessage("add.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("add.failed");
        }
        return getResultMap();
    }


    @RequestMapping("staffRole/updateInput")
    @OperatorLogger(operatorName = "进入修改角色页面")
    public ModelAndView update(Integer id) {
        ModelAndView mv = new ModelAndView("staff/role_edit");
        StaffRole staffRole = staffRoleService.getStaffRoleById(id);
        mv.addObject("staffRole", staffRole);
        return mv;
    }

    @ResponseBody
    @RequestMapping("staffRole/edit")
    @OperatorLogger(operatorName = "修改角色")
    public Map<String, Object> edit(StaffRole staffRole) {
        try {
            String releName = staffRole.getRoleName();
            staffRole.setRoleName(releName);
            StaffRole newStaffRole = staffRoleService.update(staffRole);//更新角色权限
            SecurityStaffRoleCacheService.updateAuthorityByStaffRole(newStaffRole);//跟新角色权限的缓存
            result = true;
            message = "修改成功！";
        } catch (Exception e) {
            result = false;
            message = "修改失败！";
            e.printStackTrace();
        }
        return getResultMap();

    }


    @RequestMapping(value = "staffRole/enable")
    @ResponseBody
    public Map<String, Object> enable(HttpServletRequest request, HttpServletResponse response, Integer staffRoleId) {
        try {
            staffRoleService.enableStaffRole(staffRoleId);
            result = true;
            message = messageSource.getMessage("enable.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("enable.failed");
        }
        return getResultMap();
    }

    @RequestMapping(value = "staffRole/disable")
    @ResponseBody
    public Map<String, Object> disable(HttpServletRequest request, HttpServletResponse response, Integer staffRoleId) {
        try {
            staffRoleService.disableStaffRole(staffRoleId);

            result = true;
            message = messageSource.getMessage("disable.success");
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("disable.failed");
        }
        return getResultMap();
    }


    @RequestMapping(value = "staffRole/tree")
    @ResponseBody
    public Map<String, Object> tree(HttpServletRequest request, HttpServletResponse response, Integer staffRoleId) {

        List<FunctionInfo> functionInfos = functionInfoService.findFunctionInfosByParenId(1);//所有权限
        StaffRole staffRole = staffRoleService.getStaffRoleById(staffRoleId);//当前角色的

        List<TreeVo2> roleTree = TreeUtil.functionInfoToTreeVo(functionInfos, staffRole);//将权限树中，当前角色拥有的权限勾选

        TreeVo2 tree = new TreeVo2();
        tree.setTag(1);
        tree.setText("功能树");
        tree.setChecked(true);
        tree.setNodes(roleTree);
        List<TreeVo2> treeVos = new ArrayList<TreeVo2>();
        treeVos.add(tree);

        addResultMap("treeVos", treeVos);
        return getResultMap();
    }


    @RequestMapping(value = "staffRole/authority")
    public ModelAndView authority(HttpServletRequest request, HttpServletResponse response, Integer staffRoleId) {
        ModelAndView mv = new ModelAndView("staff/role_grant");
        StaffRole staffRole = staffRoleService.getStaffRoleById(staffRoleId);
        mv.addObject("staffRole", staffRole);
//		mv.addObject("functions", new Gson().toJson(staffRole.getFunctionInfos()));
        mv.addObject("functions", JSON.toJSON(staffRole.getFunctionInfos()));
        return mv;
    }

    @RequestMapping(value = "staffRole/authorityUpdate")
    @ResponseBody
    public Map<String, Object> authorityUpdate(HttpServletRequest request, HttpServletResponse response, Integer staffRoleId, String ids) {

        try {
            StaffRole role = staffRoleService.authorityUpdateStaff(staffRoleId, ids);
            result = true;
            message = messageSource.getMessage("authority.success");
            // 更新权限缓存信息
            //TODO 这里异常信息未处理
            SecurityStaffRoleCacheService.updateAuthorityByStaffRole(role);
        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("authority.failed");
        }
        return getResultMap();
    }


}
