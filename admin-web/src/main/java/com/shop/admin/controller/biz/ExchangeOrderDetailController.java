package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.ExchangeService;
import com.mine.common.response.Response;
import com.mine.common.vo.ExchangeVo;
import com.mine.common.vo.admin.AdminOrderDetailVo;
import com.mine.common.vo.admin.AdminQueryVo;
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
import java.util.List;
import java.util.Map;

/**
 * Created by yaojunbing on 2018/4/9.
 */
@RequestMapping("exchangeOrderDetail")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class ExchangeOrderDetailController extends BaseController {
    @Autowired
    private AdminService adminService;
    @Autowired
    private ExchangeService exchangeService;
    @Autowired
    private StaffOperationLogService staffOperationLogService;


    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<ExchangeVo> voList = exchangeService.listAllExchange();
        modelMap.addAttribute("voList", voList);
        return "exchangeOrderDetail/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "offset", defaultValue = "1") int from,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       AdminQueryVo queryVo) {

        total = adminService.countExchangeOrderDetail(queryVo);
        if (total > 0) {
            list = adminService.listExchangeOrderDetail(queryVo, from, pageSize);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "export")
    @ResponseBody
    public Map<String, Object> exportExcel(HttpServletResponse response, AdminQueryVo queryVo) {
        List<AdminOrderDetailVo> voList = adminService.listExchangeOrderDetail(queryVo, null, null);
        if (null != voList && 0 < voList.size()) {
            for (AdminOrderDetailVo vo : voList) {
                if (vo.getBuy()) {
                    vo.setIsBuyStr("买");
                } else {
                    vo.setIsBuyStr("卖");
                }
            }
            String excelTable = PropertyUtil.getProperty("exchangeOrderDetail");
            String dist = ExcelUtil.export(excelTable, voList, "exchangeOrderDetail_ColumnName", "exchangeOrderDetail_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
                //记录用户操作日志
                Staff staff = SecurityUtil.currentLogin();
                staffOperationLogService.addStaffOperationLog("订单成交记录导出", staff.getRealname()
                        + "-订单成交记录导出" + voList.size() + "条数据", staff.getId(), staff.getRealname());
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
