package com.shop.admin.controller.c2c;

import com.mine.bizservice.BonusService;
import com.mine.common.vo.HubiAmountSnapshotVo;
import com.mine.common.vo.admin.AdminCustomerAccountInfoVo;
import com.shop.admin.aop.annotation.OperatorLogger;
import com.shop.admin.controller.BaseController;
import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.util.ExcelUtil;
import com.shop.admin.util.FileUtil;
import com.shop.admin.util.PropertyUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * @author baixiaozheng
 * @desc ${DESCRIPTION}
 * @date 2018/7/9 下午7:28
 */
@RequestMapping("bonus")
@Controller
@Scope(BeanDefinition.SCOPE_PROTOTYPE)
public class BonusController extends BaseController {

    @Autowired
    private BonusService bonusService;

    @RequestMapping(value = "bonusExport")
    @ResponseBody
    @OperatorLogger(operatorName = "分红统计导出")
    public Map<String, Object> tradeFeelistExport(String symbol, HttpServletResponse response) {

        List<HubiAmountSnapshotVo> list = bonusService.initHubiAmountSnapshot();

        if (list.size() > 0) {
            String excelTable = PropertyUtil.getProperty("bonusRecord");
            String dist = ExcelUtil.export(excelTable, list, "bonusRecord_ColumnName", "bonusRecord_Keys");
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
