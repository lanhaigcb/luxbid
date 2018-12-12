package com.shop.admin.util;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.reflect.FieldUtils;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.*;


public class ExcelUtil {

    /**
     * 设置 excel 的表头
     *
     * @param wb
     * @param row
     * @return
     */
    public static HSSFCell setRowCells(HSSFWorkbook wb, HSSFRow row, String[] orderFiels) {
        HSSFCellStyle style = wb.createCellStyle();
        style.setAlignment(HSSFCellStyle.ALIGN_CENTER); // 创建一个居中格式
        HSSFCell cell = null;
        for (int i = 0; i < orderFiels.length; i++) {
            cell = row.createCell(i);
            cell.setCellValue(orderFiels[i]);
            cell.setCellStyle(style);
        }
        return cell;
    }

    /**
     * 写入实体数据 到excel 每 行
     *
     * @param sheet
     * @param list
     * @param row
     */
    public static void writeData(HSSFSheet sheet, List<?> list, HSSFRow row, String[] fieldKeys) {
        for (int i = 0, n = list.size(); i < n; i++) {
            row = sheet.createRow(i + 1);
            Object o = list.get(i);
            Map<String, Object> map = null;
            try {
                map = objectToMap(o);
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } finally {
            }
            for (int j = 0; j < fieldKeys.length; j++) {
                String value = String.valueOf(map.get(fieldKeys[j]));
                row.createCell((short) j).setCellValue(value);
            }
        }
    }


    public static String export(String templateFile, List<?> list, String columnName, String keys) {
        String destPath = "";
        // 第一步，创建一个webbook，对应一个Excel文件
        HSSFWorkbook wb = new HSSFWorkbook();
        // 第二步，在webbook中添加一个sheet,对应Excel文件中的sheet
        HSSFSheet sheet = wb.createSheet("shell1");
        // 第三步，在sheet中添加表头第0行,注意老版本poi对Excel的行数列数有限制short
        HSSFRow row = sheet.createRow((int) 0);

        // 第四步，创建单元格，并设置值表头 设置表头居中
        // 从配置文件读取要导出数据的表头
        String excelColumnName = PropertyUtil.getProperty(columnName);
        if (!StringUtils.isEmpty(excelColumnName)) {
            String[] fieldColumn = excelColumnName.split(",");
            setRowCells(wb, row, fieldColumn);
        }
        // 第五步，写入实体数据 实际应用中这些数据从数据库得到，
        String excelKeys = PropertyUtil.getProperty(keys);
        if (!StringUtils.isEmpty(excelKeys)) {
            String[] fieldKeys = excelKeys.split(",");
            writeData(sheet, list, row, fieldKeys);
        }
        // 第六步，将文件存到指定位置
        try {
            String suffix = ".xls";
            String filePath = FileUtil.getRootPath() + "//report//";
            destPath = filePath + templateFile + suffix;

            File fp = new File(filePath);
            // 创建目录
            if (!fp.exists()) {
                fp.mkdirs();// 目录不存在的情况下，创建目录。
            }
            FileOutputStream fout = new FileOutputStream(destPath);
            wb.write(fout);
            fout.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return destPath;
    }

    /**
     * 获取利用反射获取类里面的值和名称
     *
     * @param obj
     * @return
     * @throws IllegalAccessException
     */
    public static Map<String, Object> objectToMap(Object obj) throws IllegalAccessException {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Map<String, Object> map = new HashMap<>();
        Class<?> clazz = obj.getClass();
        System.out.println(clazz);
        for (Field field : clazz.getDeclaredFields()) {
            field.setAccessible(true);
            String fieldName = field.getName();
            Object value = field.get(obj);
            map.put(fieldName, value instanceof Date ? formatter.format(value) : value);
        }
        return map;
    }

}
