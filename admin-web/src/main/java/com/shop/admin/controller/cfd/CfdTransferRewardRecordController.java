package com.shop.admin.controller.cfd;

import com.mine.bizservice.CfdTransferRewardRecordService;
import com.mine.common.cfd.CfdTransferRewardRecordVo;
import com.shop.admin.controller.BaseController;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * @ Author     ：yangminglei
 * @ Date       ：Created in 19:53 2018/11/3
 * @ Description：${description} 合约交易 活动管理
 * @ Modified By：
 * @Version: $version$
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/cfdTransferRewardRecord")
public class CfdTransferRewardRecordController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(CfdTransferRewardRecordController.class);


    @Autowired
    private CfdTransferRewardRecordService cfdTransferRewardRecordService;





    /**
     * 跳转合约活动管理页面的方法
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "index")
    public String products(ModelMap modelMap){
        return  "cfdTransferRewardRecord/index";
    }

    /**
     * 合约活动管理list页面
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "list")
    public Object findListAll(String symbol, Integer customerId, Integer offset,
                              Integer limit){
        symbol ="BTC";
        //1获取总条数
        total = cfdTransferRewardRecordService.count(customerId,symbol);
        //2获取当前list
        if(total>0){
            List<CfdTransferRewardRecordVo> listvos = cfdTransferRewardRecordService.list(customerId, symbol, getOffset(offset), getLimit(limit));
            this.list =listvos.size()>0?listvos:null;
        }
        //3返回
        result = true;
        message = "查询成功";
        return  getResultMap();
    }
}
