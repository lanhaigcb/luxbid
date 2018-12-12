package com.shop.admin.controller.cfd;


import com.alibaba.fastjson.JSON;
import com.mine.bizservice.CfdBizService;
import com.mine.bizservice.CfdNodeService;

import com.mine.common.cfdCurrencyVo.CfdCurrencyAdminVo;
import com.mine.common.enums.cfd.CfdApplyType;
import com.mine.common.enums.cfd.CfdNodeType;
import com.mine.common.exception.currency.CurrencyException;
import com.mine.common.response.Response;
import com.mine.common.vo.CustomerVo;
import com.mine.common.vo.cfd.CfdNodeRedisVo;
import com.mine.common.vo.cfd.CfdNodeVo;
import com.shop.admin.controller.BaseController;

import com.shop.admin.model.staff.Staff;
import com.shop.admin.security.util.SecurityUtil;
import com.shop.admin.util.RedisUtil;
import com.mine.userservice.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.CriteriaBuilder;
import java.security.PrivateKey;
import java.util.*;

/**
 * CfdNodeController
 *
 * @author Dog Knight
 * @date 2018/09/20 01:10
 * @description
 */
@Controller
@Scope(BaseController.REQUEST_SCOPE)
@RequestMapping("cfdNode")
public class CfdNodeController extends BaseController {

    @Autowired
    private CfdNodeService cfdNodeService;

    @Autowired
    private CfdBizService cfdBizService;

    @Autowired
    private UserService userService;
    @Autowired
    private RedisUtil redisUtil;



    @RequestMapping("index")
    public String index(ModelMap modelMap) {
        return "cfdNode/index";
    }

    @ResponseBody
    @RequestMapping("list")
    public Object list(Integer offset, Integer limit) {
        total = cfdNodeService.count(new CfdNodeVo());
        if(total >0 ){
            list = cfdNodeService.list(new CfdNodeVo(),offset,limit);
        }
        result = true;
        message = "查询成功";
        return getResultMap();
    }

    @RequestMapping("/addInput")
    public ModelAndView addIndex(ModelMap modelMap) {
        ModelAndView mv = new ModelAndView("cfdNode/add");

        //查询所有超级节点
        List<CfdNodeVo> superCfdNodes = cfdNodeService.findAllByCfdNodeType(CfdNodeType.SUPER);
        modelMap.addAttribute("superCfdNodes",superCfdNodes);
        //查询所有特殊节点
        List<CfdNodeVo> specialCfdNodes = cfdNodeService.findAllByCfdNodeType(CfdNodeType.SPECIAL);
        modelMap.addAttribute("specialCfdNodes",specialCfdNodes);
        //返回所有节点类型
        CfdNodeType[] cfdNodeTypes = CfdNodeType.values();
        List<Map<String,String>> list = new ArrayList<>();
        for (CfdNodeType cfdNodeType : cfdNodeTypes) {
            Map<String,String> map = new HashMap<>();
            map.put("key",cfdNodeType.name());
            map.put("value",cfdNodeType.toString());
            list.add(map);
        }
        modelMap.addAttribute("cfdNodeTypes",list);
        return mv;
    }

    @RequestMapping("/add")
    @ResponseBody
    public Response add(CfdNodeVo cfdNodeVo) {
        cfdNodeService.add(cfdNodeVo);
        return Response.simpleSuccess();
    }
    @RequestMapping("/updateInput")
    public String updateIndex(ModelMap modelMap, Integer id){
        CfdNodeVo cfdNodeVo = cfdNodeService.get(id);
        modelMap.addAttribute("cfdNode",cfdNodeVo);
        //查询所有超级节点
        List<CfdNodeVo> superCfdNodes = cfdNodeService.findAllByCfdNodeType(CfdNodeType.SUPER);
        modelMap.addAttribute("superCfdNodes",superCfdNodes);
        //查询所有特殊节点
        List<CfdNodeVo> specialCfdNodes = cfdNodeService.findAllByCfdNodeType(CfdNodeType.SPECIAL);
        modelMap.addAttribute("specialCfdNodes",specialCfdNodes);
        //返回所有节点类型
        CfdNodeType[] cfdNodeTypes = CfdNodeType.values();
        List<Map<String,String>> list = new ArrayList<>();
        for (CfdNodeType cfdNodeType : cfdNodeTypes) {
            Map<String,String> map = new HashMap<>();
            map.put("key",cfdNodeType.name());
            map.put("value",cfdNodeType.toString());
            list.add(map);
        }
        modelMap.addAttribute("cfdNodeTypes",list);
        return "/cfdNode/edit";
    }

    /**
     *@描述   更新的方法 要先查询 然后设置新的属性值 然后更新
     *@参数  [cfdNodeVo]
     *@返回值  java.lang.Object
     *@创建人  yangminglei
     *@创建时间  2018/9/26
     *@修改人和其它信息(非作者修改 请备注一下 多人就写多个)
     */
    @RequestMapping(method = RequestMethod.POST,value = "update")
    @ResponseBody
    public Object updateCfdNode(CfdNodeVo cfdNodeVo){
       //进行设置值
        try {
            cfdNodeService.update(cfdNodeVo);
            result = true;
            message = "更新数据成功";
            return  getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = "更新数据失败";
            return  getResultMap();
        }

    }

    /**
     *@描述 修改禁用/启用状态的方法
     *@参数  [id, enable]
     *@返回值  java.util.Map<java.lang.String,java.lang.Object>
     *@创建人  yangminglei
     *@创建时间  2018/9/26
     *@修改人和其它信息(非作者修改 请备注一下 多人就写多个)
     */
    @ResponseBody
    @RequestMapping(method = RequestMethod.POST,value = "enable")
    public Map<String, Object> cfdCurrencyEnable(Integer id, Boolean enable){
        CfdNodeVo cfdNodeVo = cfdNodeService.get(id);
        cfdNodeVo.setEnable(enable);
        cfdNodeVo.setUpdateTime(new Date());
        Integer customerId = cfdNodeVo.getAdminId();

        try {
            cfdNodeService.update(cfdNodeVo);
            userService.updateUserStatus(customerId,enable);
            result = true;
            message = "更新状态成功";
            return  getResultMap();
        } catch (Exception e) {
            e.printStackTrace();
            result = false;
            message = "更新状态失败";
            return  getResultMap();
        }

    }

    @RequestMapping("nodes")
    public String  nodesIndex(ModelMap modelMap){
        List<CfdNodeVo> list = cfdNodeService.list(new CfdNodeVo(), 0, Integer.MAX_VALUE);
        modelMap.addAttribute("nodes",list);
        return  "cfdNode/nodes";
    }
    /**
     *@描述  系统后台 节点管理的方法  节点监控
     *@参数  [nodeId, offset, limit]
     *@返回值  java.lang.Object
     *@创建人  yangminglei
     *@创建时间  2018/9/29
     *@修改人和其它信息(非作者修改 请备注一下 多人就写多个)
     */

    @RequestMapping("nodeList")
    @ResponseBody
    public Object findNodeList(Integer nodeId){
        CfdNodeVo cfdNodeVo = new CfdNodeVo();
        if(null!=nodeId){
            cfdNodeVo.setId(nodeId);
        }
        List<HashMap<String, Object>> hashMaps = new ArrayList<>();
        List<CfdNodeVo> lists = cfdNodeService.list(cfdNodeVo, 0, Integer.MAX_VALUE);
        for (CfdNodeVo nodeVo : lists) {
            HashMap<String, Object> node = cfdBizService.findNode(nodeVo.getId(), nodeVo.getAdminId());
            /*if(redisUtil.exists("cfd_node:risk_rate:USD:"+nodeVo.getId())){
                CfdNodeRedisVo redisVo = JSON.parseObject(redisUtil.get("cfd_node:risk_rate:USD:" + nodeVo.getId()).toString(), CfdNodeRedisVo.class);
                node.put("risk",redisVo.getRiskRate());
            }else{
                node.put("risk",0);
            }*/
            hashMaps.add(node);
        }
        total=lists.size();
        list=hashMaps;
        result = true;
        message = "查询成功";
        return  getResultMap();
    }
    @RequestMapping({"/transfer"})
    public ModelAndView findNodeTransfer(Integer id) {
        ModelAndView mv = new ModelAndView("cfdNode/transfer");
        List lists = this.cfdBizService.cfdTransferRecorList(id, (Date)null, (Date)null, (Integer)null, (String)null, (CfdApplyType)null, "BTC", 0, Integer.MAX_VALUE);
        mv.addObject("id", id);
        return mv;
    }
    @RequestMapping("/transfers")
    @ResponseBody
    public Object  findNodeTransfers(Integer id){
        List lists = this.cfdBizService.cfdTransferRecorList(id, (Date)null, (Date)null, (Integer)null, (String)null, (CfdApplyType)null, "BTC", 0, Integer.MAX_VALUE);
        total=lists.size();
        list=lists;
        result = true;
        message = "查询成功";
        return  getResultMap();
    }
}
