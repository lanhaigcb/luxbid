package com.shop.admin.controller.cfd;

import com.mine.bizservice.CfdBizService;
import com.mine.bizservice.CfdTransferRewardApplyService;
import com.mine.bizservice.CfdTransferRewardRecordService;
import com.mine.common.cfd.CfdTransferRewardApplyVo;
import com.mine.common.cfd.CfdTransferRewardRecordVo;
import com.mine.common.enums.cfd.CfdRewardApplyStatus;
import com.mine.common.vo.ResultVo;
import com.mine.common.vo.cfd.CfdOrderUnwindDetailAdminVo;
import com.shop.admin.controller.BaseController;
import com.shop.admin.util.RedisUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

/**
 * @ Author     ：yangminglei
 * @ Date       ：Created in 19:53 2018/11/3
 * @ Description：${description} 合约交易  活动管理 参与列表
  * @ Modified By：
 * @Version: $version$
 */

@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("/cfdTransferRewardApply")
public class CfdTransferRewardApplyController extends BaseController {
    private static Logger logger = LoggerFactory.getLogger(CfdTransferRewardApplyController.class);


    @Autowired
    private RedisUtil redisUtil;

    @Autowired
    private CfdTransferRewardApplyService cfdTransferRewardApplyService;

    @Autowired
    private CfdBizService cfdBizService;
    /**
     * 跳转合约活动满足条件管理页面的方法
     * @return
     */
    @RequestMapping(method = RequestMethod.GET,value = "index")
    public String products(ModelMap modelMap){
        return  "cfdTransferRewardApply/index";
    }

    /**
     * 合约活动满足条件管理list页面
     * @return
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "list")
    public Object findListAll(CfdRewardApplyStatus cfdRewardApplyStatus, Integer customerId, Integer offset,
                              Integer limit){
        //1获取总条数
        total = cfdTransferRewardApplyService.count(customerId,cfdRewardApplyStatus);
        //2获取当前list
        if(total>0){
            List<CfdTransferRewardApplyVo> listvos = cfdTransferRewardApplyService.list(customerId, cfdRewardApplyStatus, getOffset(offset), getLimit(limit));
            this.list =listvos.size()>0?listvos:null;
        }
        //3返回
        result = true;
        message = "查询成功";
        return  getResultMap();
    }

    /**
     *@描述       查看奖励订单的信息
     *@创建人  yangminglei
     *@参数  [id]
     *@返回值  org.springframework.web.servlet.ModelAndView
     *@创建时间  2018/11/5
     *@修改人和其它信息 多人就是多个
     */
    @RequestMapping("orders")
    public ModelAndView findOrders(Integer   id) {

        ModelAndView mv = new ModelAndView("cfdTransferRewardApply/orders");
        mv.addObject("id", id);
        return mv;
    }

    /**
     *@描述   查看当前平仓订单的方法
     *@创建人  yangminglei
     *@参数  [id]
     *@返回值  java.lang.Object
     *@创建时间  2018/11/5
     *@修改人和其它信息 多人就是多个
     */
    @RequestMapping("/order")
    @ResponseBody
    public Object  findOrder( Integer   id){
        CfdTransferRewardApplyVo byId = cfdTransferRewardApplyService.getById(id);
        List<CfdOrderUnwindDetailAdminVo> cfdOrderUnwindDetailAdminVos = cfdBizService.adminUnwindList(null, byId.getCustomerId(), null, null, null, null, null, byId.getCreateTime(), null, null,0, Integer.MAX_VALUE);
        total=cfdOrderUnwindDetailAdminVos.size();
        list=cfdOrderUnwindDetailAdminVos;
        result = true;
        message = "查询成功";
        return  getResultMap();
    }
    /**
     *@描述   一键转账的方法  添加转账记录
     *@创建人  yangminglei
     *@参数  [customerId, amount]
     *@返回值  java.lang.Object
     *@创建时间  2018/11/5
     *@修改人和其它信息 多人就是多个
     */
    @RequestMapping("/transfer")
    @ResponseBody
    public Object  transfer(Integer id){
            String key = "cfdTransferRewardApply:transfer:"+id;
            if(redisUtil.exists(key)){
                result = false;
                message = "请不要重复请求";
                return getResultMap();
            }else{
                redisUtil.set(key,id);
            }
        String benchmarkingCurrency ="USDT";
        CfdTransferRewardApplyVo byId = cfdTransferRewardApplyService.getById(id);
        ResultVo transfer = cfdTransferRewardApplyService.transfer(byId.getId(),byId.getCustomerId(), byId.getRewardAmount(), benchmarkingCurrency);
        if(transfer.isSuccess()){
            redisUtil.remove(key);
            result = true;
            message = "划转奖励成功";
            return  getResultMap();

        }else{
            redisUtil.remove(key);
            result = false;
            message = transfer.getMessage();
            return  getResultMap();
        }

    }

}
