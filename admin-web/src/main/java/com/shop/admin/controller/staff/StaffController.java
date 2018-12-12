/**
 *
 */
package com.shop.admin.controller.staff;


import com.google.common.base.Strings;
import com.mine.common.exception.staff.StaffException;
import com.mine.common.plugin.i18n.MessageSource;
import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.PlatformPreconditions;
import com.mine.common.response.Response;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.model.staff.StaffOperationLog;
import com.shop.admin.model.staff.StaffRole;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.service.staff.StaffRoleService;
import com.shop.admin.service.staff.StaffService;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class StaffController extends BaseController {

    private static Log logger = LogFactory.getLog(StaffController.class);

    @Autowired
    private MessageSource messageSource;

    @Autowired
    private StaffService staffService;

    @Autowired
    private StaffRoleService staffRoleService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    //用户管理页
    @RequestMapping(value = "staff/index")
    @OperatorLogger(operatorName = "进入管理员管理")
    public ModelAndView index(String status) {
        ModelAndView mv = new ModelAndView("staff/staff_index");
        return mv;
    }

    /***
     * 工作人员列表
     *
     * @return
     */
    @RequestMapping(value = "staff/list")
    @OperatorLogger(operatorName = "查看管理员列表")
    @ResponseBody
    public Response list(Integer limit, Integer offset) {

        Staff currentLogin = SecurityUtil.currentLogin();
        currentLogin = staffService.getStaffById(currentLogin.getId());

        total = (int) staffService.getTotalCount();
        List<Staff> staffs = null;
        if (total > 0) {
            staffs = staffService.listAll(getOffset(offset), getLimit(limit));

            for (Staff staff : staffs) {
                String roleStr = "";
                Object[] roles = staff.getRoles().toArray();
                for (Object o : roles) {
                    StaffRole role = (StaffRole) o;
                    roleStr += role.getRoleName() + ";";
                }
                staff.setRoleName(roleStr);
            }
        }

        return Response.listSuccess(total, staffs, "成功");
    }

    /**
     * 新增工作人员页面
     *
     * @return
     */
    @RequestMapping(value = "staff/addInput")
    @OperatorLogger(operatorName = "进入添加管理员页面")
    public ModelAndView addInput() {
        ModelAndView mv = new ModelAndView("staff/staff_add");
        List<StaffRole> roles = staffRoleService.listAllEnable();
        mv.addObject("roles", roles);
        return mv;
    }

    /**
     * 新增工作人员
     *
     * @param name
     * @param realname
     * @param password
     * @param confirm_password
     * @param enable
     * @param enName
     * @return
     */
    @RequestMapping(value = "staff/add")
    @OperatorLogger(operatorName = "添加管理员")
    @ResponseBody
    public Map<String, Object> add(String name, String realname, String password, String confirm_password, boolean enable, String enName, String mobile) {

        if (!password.equals(confirm_password)) {
            result = false;
            message = messageSource.getMessage("password.not.equal");
            return getResultMap();
        }
        try {
            staffService.addStaff(name, realname, confirm_password, enable, enName, mobile);
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

    /**
     * 前往更新角色页面
     *
     * @param request
     * @param response
     * @param staffId
     * @return
     */
    @RequestMapping(value = "staff/updateInput")
    @OperatorLogger(operatorName = "进入管理员页面")
    public ModelAndView updateInput(HttpServletRequest request, HttpServletResponse response, Integer staffId) {

        Staff staff = staffService.getStaffById(staffId);
        ModelAndView mv = new ModelAndView("staff/staff_edit");
        List<StaffRole> roles = staffRoleService.listAllEnable();
        mv.addObject("roles", roles);
        mv.addObject("staff", staff);
        return mv;
    }

    /**
     * 更新工作人员角色
     *
     * @return
     */
    @RequestMapping(value = "staff/update")
    @OperatorLogger(operatorName = "修改管理员")
    @ResponseBody
    public Map<String, Object> update(HttpServletRequest request, HttpServletResponse response, Staff staff, String roleId, Integer orgId) {
        try {
            //String realname = new String(staff.getRealname().getBytes("ISO-8859-1"), "UTF-8");
            //staff.setRealname(realname);
            staffService.updateStaff(staff, roleId, orgId);
            result = true;
            message = messageSource.getMessage("update.success");

        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("update.failed");
        }

        return getResultMap();
    }

    //设置用户是否可用
    @ResponseBody
    @RequestMapping("staff/updateStatus")
    @OperatorLogger(operatorName = "修改管理员状态")
    public Map<String, Object> updateStatus(Integer id, String status) {
        try {

            boolean falg = false;
            if ("enable".equals(status)) {
                falg = true;
            }
            staffService.updateStatus(id, falg);
            result = true;
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
        }

        return getResultMap();
    }


    //重置密码页
    @RequestMapping("staff/reset/password")
    @OperatorLogger(operatorName = "进入重置管理员密码")
    public ModelAndView updete(Integer staffId) {
        Staff staff1 = SecurityUtil.currentLogin();
        Staff staff = staffService.getStaffById(staffId);
        ModelAndView mv = new ModelAndView("staff/reset_password");
        mv.addObject("staff", staff);
        return mv;
    }

    //超级管理员重置密码
    @ResponseBody
    @RequestMapping("staff/password/reset")
    @OperatorLogger(operatorName = "重置管理员密码")
    public Map<String, Object> updatePassword(Staff staff) {
        try {
            staffService.updateStaff(staff);
            result = true;
            message = messageSource.getMessage("update.success");
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = messageSource.getMessage("update.failed");
        }
        return getResultMap();
    }

    //启用用户
    @RequestMapping(value = "staff/enable")
    @OperatorLogger(operatorName = "启用管理员")
    @ResponseBody
    public Map<String, Object> enable(HttpServletRequest request, HttpServletResponse response, Integer staffId) {
        try {
            staffService.enableStaff(staffId);
            result = true;
            message = messageSource.getMessage("enable.success");

        } catch (StaffException e) {
            result = false;
            message = e.getMessage();
        } catch (Exception e) {
            result = false;
            message = messageSource.getMessage("enable.failed");
        }
        PlatformPreconditions.checkArgument(false, CommonResponseCode.COMMON_ILLEGAL_PARAM, "fuck");
        return getResultMap();
    }

    //禁用用户
    @RequestMapping(value = "staff/disable")
    @OperatorLogger(operatorName = "禁用管理员")
    @ResponseBody
    public Map<String, Object> disable(HttpServletRequest request, HttpServletResponse response, Integer staffId) {
        try {
            staffService.disableStaff(staffId);
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

    /**
     * 修改密码页
     *
     * @return
     */
    @RequestMapping("staff/update/password")
    @OperatorLogger(operatorName = "进入修改密码页面")
    public ModelAndView updatePasswordPage() {
        ModelAndView mv = new ModelAndView("staff/update_password");
        Staff staff = SecurityUtil.currentLogin();
        mv.addObject("staff", staff);
        return mv;
    }


    @ResponseBody
    @RequestMapping("staff/password/update")
    @OperatorLogger(operatorName = "修改密码")
    public Map<String, Object> updatePassword(Staff staff, String oldPassword) {
        try {
            if (Strings.isNullOrEmpty(oldPassword)) {
                result = false;
            }
            result = staffService.updatePassword(staff, oldPassword);
        } catch (Exception e) {
            result = false;
        }
        message = result ? "修改成功" : "修改失败";
        return getResultMap();
    }

    //用户操作日志页面
    @RequestMapping(value = "staff/staffOperationLogIndex")
    @OperatorLogger(operatorName = "进入用户操作日志页面")
    public ModelAndView staffOperationLogIndex(String status) {
        List<Map<String,Object>> titleList = staffOperationLogService.getTitleTypeList();
        ModelAndView mv = new ModelAndView("staff/staffOperationLog_index");
        mv.addObject("titleList",titleList);
        return mv;
    }

    /***
     * 用户操作日志列表
     *
     * @return
     */
    @RequestMapping(value = "staff/staffOperationLogList")
    @OperatorLogger(operatorName = "用户操作日志列表")
    @ResponseBody
    public Response staffOperationLogList(Integer limit, Integer offset, String name, Date startDate, Date endDate) {
        total = (int) staffOperationLogService.getTotalCount(name,startDate,endDate);
        List<StaffOperationLog> staffOperationLog = new ArrayList<>();
        if (total > 0) {
            staffOperationLog = staffOperationLogService.listAll(getOffset(offset), getLimit(limit),name,startDate,endDate);
        }
        return Response.listSuccess(total, staffOperationLog, "成功");
    }

}
