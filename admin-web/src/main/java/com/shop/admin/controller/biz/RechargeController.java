package com.shop.admin.controller.biz;

import com.mine.bizservice.AdminService;
import com.mine.bizservice.CurrencyService;
import com.mine.common.currencyVo.CurrencyVo;
import com.mine.common.response.Response;
import com.mine.common.vo.admin.AdminQueryVo;
import com.shop.admin.controller.BaseController;
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
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by yaojunbing on 2018/4/10.
 */
@Controller
@RequestMapping("recharge")
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class RechargeController extends BaseController {
    @Autowired
    private AdminService adminService;
    @Autowired
    private CurrencyService currencyService;

    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        List<CurrencyVo> voList = currencyService.listAllEnable();
        modelMap.addAttribute("voList", voList);
        return "recharge/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(@RequestParam(value = "offset", defaultValue = "1") int from,
                       @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
                       AdminQueryVo queryVo) {
        total = adminService.countRecharegeRecord(queryVo);
        if (total > 0) {
            list = adminService.listRechargeRecord(queryVo, from, pageSize);
        }
        result = true;
        return Response.listSuccess(total, list, "查询成功");
    }

    @RequestMapping(value = "export")
    @ResponseBody
    public Map<String, Object> exportExcel(HttpServletResponse response, Date startDate, Date endDate, Integer customerId, String symbol) {
        AdminQueryVo queryVo = new AdminQueryVo();
        queryVo.setStartDate(startDate);
        queryVo.setEndDate(endDate);
        queryVo.setCustomerId(customerId);
        queryVo.setSymbol(symbol);
        list = adminService.listRechargeRecord(queryVo, null, null);
        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("rechargeRecord");
            String dist = ExcelUtil.export(excelTable, list, "rechargeRecord_ColumnName", "rechargeRecord_Keys");
            try {
                FileUtil.downLoadFile(dist, response);
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
