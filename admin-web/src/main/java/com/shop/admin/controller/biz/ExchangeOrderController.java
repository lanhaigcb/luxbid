package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.BizService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.enums.ExOrderStatus;
import com.mine.common.order.ExchangeOrderVo;
import com.mine.common.response.Response;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.admin.AdminExchangeOrderVo;
import com.mine.common.vo.admin.AdminQueryVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.service.staff.StaffOperationLogService;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by yaojunbing on 2018/4/9.
 */
@RequestMapping("exchangeOrder")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class ExchangeOrderController extends BaseController {
    @Autowired
    private AdminService adminService;
    @Autowired
    private ExchangeService exchangeService;
    @Autowired
    private StaffOperationLogService staffOperationLogService;

    @Autowired
    private BizService bizService;

    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<ExchangeVo> voList = exchangeService.listAllExchange();
        modelMap.addAttribute("voList", voList);
        return "exchangeOrder/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "page", defaultValue = "1") int page,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       AdminQueryVo queryVo) {

        total = adminService.countExchangeOrder(queryVo);
        if (total > 0) {
            list = adminService.listExchangeOrder(queryVo, page, pageSize);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @ResponseBody
    @RequestMapping("adminCancel")
    public Map<String,Object> cancelOrder(Integer orderId){
        ExchangeOrderVo exchangeOrderVo = bizService.getOrderInfoById(orderId);

        if(null == exchangeOrderVo){
            result = false;
            message = "订单不存在";
        }else if(!ExOrderStatus.EX_ORDER_STATUS_IN.equals(exchangeOrderVo.getOrderStatus())){
            result = false;
            message = "订单不存在";
        }else{
            bizService.orderCancel(exchangeOrderVo.getCustomerId(),exchangeOrderVo.getId());
            result = true;
            message = "撤销提交成功";
        }
        return getResultMap();
    }

    @ResponseBody
    @RequestMapping("totalAmountCNY")
    public Object totalAmountCNY(AdminQueryVo queryVo) {
        List<AdminExchangeOrderVo> listAdminExchangeOrderVo = adminService.listExchangeOrder(queryVo, null, null);
        BigDecimal totalAmountCNY = new BigDecimal(0);
        if (null != listAdminExchangeOrderVo && 0 < listAdminExchangeOrderVo.size()) {
            for (AdminExchangeOrderVo vo : listAdminExchangeOrderVo) {
                totalAmountCNY = totalAmountCNY.add(vo.getTotalAmonutCNY());
            }
        }
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("totalAmountCNY", totalAmountCNY);
        return map;
    }

    @RequestMapping(value = "export")
    @ResponseBody
    public Map<String, Object> exportExcel(HttpServletResponse response, Integer customerId, String account,
                                           String symbol, String orderStatus, String channelId, Integer isProjectStr,
                                           Date startDate, Date endDate, Boolean buy, Boolean whiteList) {
        AdminQueryVo queryVo = new AdminQueryVo();
        queryVo.setCustomerId(customerId);
        queryVo.setAccount(account);
        queryVo.setSymbol(symbol);
        queryVo.setOrderStatus(orderStatus);
        queryVo.setChannelId(channelId);
        queryVo.setBuy(buy);
        queryVo.setIsProjectStr(isProjectStr);
        queryVo.setWhiteList(whiteList);
        queryVo.setStartDate(startDate);
        queryVo.setEndDate(endDate);
        List<AdminExchangeOrderVo> voList = adminService.listExchangeOrder(queryVo, null, null);
        if (voList.size() > 0) {
            for (AdminExchangeOrderVo vo : voList) {
                if (null != vo.getBuy() && vo.getBuy()) {
                    vo.setIsBuyStr("买");
                } else {
                    vo.setIsBuyStr("卖");
                }
                if (null != vo.getWhiteList() && vo.getWhiteList()) {
                    vo.setWhiteListStr("是");
                } else {
                    vo.setWhiteListStr("否");
                }
                if (null != vo.getIsProjectStr() && 1 == vo.getIsProjectStr()) {
                    vo.setIsProjectS("是");
                } else {
                    vo.setIsProjectS("否");
                }
                vo.setOrderStatusStr(vo.getOrderStatus() != null ? vo.getOrderStatus().toString() : "");
            }
            String excelTable = PropertyUtil.getProperty("exchangeOrder");
            String dist = ExcelUtil.export(excelTable, voList, "exchangeOrder_ColumnName", "exchangeOrder_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("客户订单导出", staff.getRealname()
                        + "-客户订单导出" + voList.size() + "条数据", staff.getId(), staff.getRealname());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            result = false;
            message = "无数据可以导出";
        }
        return getResultMap();
    }
}
