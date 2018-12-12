package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminExchangePartitionService;
import com.mine.common.enums.PartitionType;
import com.mine.common.response.CommonResponseCode;
import com.mine.common.response.Response;
import com.mine.common.vo.admin.AdminExchangePartitionVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * Created by yaojunbing on 2018/4/28.
 */
@Controller
@RequestMapping("exchangePartition")
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class ExchangePartitionController extends BaseController {
    @Autowired
    private AdminExchangePartitionService adminExchangePartitionService;

    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @OperatorLogger(operatorName = "进入币种分区管理")
    @RequestMapping("index")
    public String index() {
        return "partition/index";
    }


    @OperatorLogger(operatorName = "进入添加币种分区页面")
    @RequestMapping("addInput")
    public ModelAndView addInput() {
        ModelAndView modelAndView = new ModelAndView("partition/add");
        modelAndView.addObject("types", PartitionType.values());
        return modelAndView;
    }

    @OperatorLogger(operatorName = "进入修改币种分区页面")
    @RequestMapping("updateInput")
    public ModelAndView updateInput(Integer id) {
        ModelAndView mv = new ModelAndView("partition/edit");
        AdminExchangePartitionVo vo = adminExchangePartitionService.getExchangePartitionById(id);
        mv.addObject("types", PartitionType.values());
        mv.addObject("vo", vo);
        return mv;
    }

    @ResponseBody
    @RequestMapping("list")
    @OperatorLogger(operatorName = "获取所有币种分区(后台)")
    public Object list(@RequestParam(value = "offset", defaultValue = "0") Integer offset,
                       @RequestParam(value = "limit", defaultValue = "10") Integer limit) {
        int total = adminExchangePartitionService.countExchangePartition();
        if (total > 0) {
            list = adminExchangePartitionService.listExchangePartition(getOffset(offset), getLimit(limit));
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @ResponseBody
    @RequestMapping("add")
    @OperatorLogger(operatorName = "添加币种分区(后台)")
    public Object add(AdminExchangePartitionVo vo) {
        if (StringUtils.isEmpty(vo.getIntroduce())
                || StringUtils.isEmpty(vo.getName())
                || vo.getSortParameter() == null) {
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        adminExchangePartitionService.addExchangePartition(vo);
        //记录用户操作日志
        Staff staff = SecurityUtil.currentLogin();
        staffOperationLogService.addStaffOperationLog("新增币种分区", staff.getRealname() + "-新增币种分区：" + vo.getName(), staff.getId(), staff.getRealname());
        return Response.simpleSuccess();
    }

    /**
     * 更新Banner信息
     */
    @RequestMapping("/update")
    @OperatorLogger(operatorName = "修改币种分区")
    @ResponseBody
    public Object update(AdminExchangePartitionVo vo) {
        if (StringUtils.isEmpty(vo.getIntroduce())
                || StringUtils.isEmpty(vo.getName())
                || vo.getSortParameter() == null) {
            Response response = new Response(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY);
            response.setMessage(CommonResponseCode.HOME_PARAM_CANNOT_EMPTY.getInfo());
            return response;
        }
        adminExchangePartitionService.updateExchangePartition(vo);
        //记录用户操作日志
        Staff staff = SecurityUtil.currentLogin();
        staffOperationLogService.addStaffOperationLog("修改币种分区", staff.getRealname() + "-修改币种分区：" + vo.getName(), staff.getId(), staff.getRealname());
        return Response.simpleSuccess();
    }

}
