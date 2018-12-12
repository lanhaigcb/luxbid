package com.shop.admin.controller.user;

import com.mine.bizservice.MessageService;
import com.mine.common.enums.RegisterType;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.IdInfoVo;
import com.mine.common.vo.ResultVo;
import com.mine.common.vo.message.MessageVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.notify.NotifyService;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.mine.userservice.IdInfoService;
import com.mine.userservice.UserService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 用户信息审核
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
public class IdAuditController extends BaseController {

    private static Logger logger = LoggerFactory.getLogger(IdAuditController.class);

    @Autowired
    private NotifyService notifyService;

    @Autowired
    private IdInfoService infoService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @Autowired
    private UserService userService;

    @Autowired
    private MessageService messageService;

    @OperatorLogger(operatorName = "进入审核列表")
    @RequestMapping(value = "idAudit/index")
    public ModelAndView index() {
        ModelAndView mv = new ModelAndView("idAudit/index");
        return mv;
    }

    @RequestMapping(value = "idAudit/list")
    @ResponseBody
    @OperatorLogger(operatorName = "查看审核列表")
    public Map<String, Object> list(
            Integer offset, Integer limit
    ) {
        total = (int) infoService.countAll();
        if (total > 0) {
            List<IdInfoVo> clist = infoService.list(getOffset(offset), getLimit(limit));
            list = clist;
        } else {
            list = new ArrayList();
        }
        result = true;
        return getResultMap();
    }

    @OperatorLogger(operatorName = "进入审核页面")
    @RequestMapping(value = "idAudit/showInfo")
    public ModelAndView renderAuditView(Integer id) {
        IdInfoVo idInfoVo = infoService.findById(id);
        CustomerVo customerVo = userService.getCustomerById(idInfoVo.getCustomerId());
        ModelAndView mv = new ModelAndView("idAudit/audit");
        mv.addObject("customerVo", customerVo);
        mv.addObject("info", idInfoVo);
        return mv;
    }

    @ResponseBody
    @RequestMapping("idAudit/update")
    public Object update(Boolean audit, String note, Integer id) {
        if (StringUtils.isBlank(note) || audit == null || id == null) {
            result = false;
            message = "有为空的参数";
            return getResultMap();
        }
        Staff staff = SecurityUtil.currentLogin();
        ResultVo vo = infoService.updateIdInfo(id, note, staff.getId(), audit);
        IdInfoVo idInfoVo = infoService.findById(id);
        if (vo.isSuccess()) {
            try {
                notifyService.sendIdCardPassNotifyWithAuditInfoId(id);
            } catch (Exception e) {
                e.printStackTrace();
                logger.error(e.getMessage());
            }
            //记录用户操作日志
            String auditResult;
            //站内信
            MessageVo messageVo = new MessageVo();
            if (audit) {
                auditResult = "审核通过";
                messageVo.setContent("实名审核成功！");
            } else {
                auditResult = "审核不通过";
                messageVo.setContent("实名审核失败！" + idInfoVo.getNote());
            }
            messageVo.setCustomerId(idInfoVo.getCustomerId());
            messageService.add(messageVo);
            CustomerVo customerVo = userService.getCustomerById(idInfoVo.getCustomerId());
            String account = customerVo.getRegType().equals(RegisterType.EMAIL) ? customerVo.getEmail() : customerVo.getMobile();
            staffOperationLogService.addStaffOperationLog("实名审核", staff.getRealname() + "-实名审核：" + account + "(" + customerVo.getRealName() + ")" + auditResult, staff.getId(), staff.getRealname());
            result = true;
            message = "实名审核完成";
        } else {
            result = false;
            message = vo.getMessage();
        }
        return getResultMap();
    }

}
