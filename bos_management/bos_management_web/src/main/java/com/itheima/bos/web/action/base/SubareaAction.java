package com.itheima.bos.web.action.base;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletOutputStream;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.struts2.ServletActionContext;
import org.apache.struts2.convention.annotation.Action;
import org.apache.struts2.convention.annotation.Namespace;
import org.apache.struts2.convention.annotation.ParentPackage;
import org.apache.struts2.convention.annotation.Result;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;

import com.itheima.bos.domain.base.SubArea;
import com.itheima.bos.service.base.SubareaService;
import com.itheima.bos.utils.FileUtils;
import com.itheima.bos.web.action.common.CommonAction;
/**
 * 分区管理
 * @author zhaoqx
 *
 */
@Controller
@Scope("prototype")
@Namespace("/")
@ParentPackage("struts-default")
public class SubareaAction extends CommonAction<SubArea>{
	@Autowired
	private SubareaService service;
	/**
	 * 保存分区数据
	 */
	@Action(value="subareaAction_save",results={
			@Result(name="success",type="redirect",location="/pages/base/sub_area.jsp")})
	public String save(){
		
		System.out.println(getModel().getAssistKeyWords()+""+getModel().getAddress()+getModel().getKeyWords());
		
		service.save(getModel());
		return SUCCESS;
	}
	//查询分区数据
	@Action(value="subareaAction_findAll")
	public String findAll(){
		List<SubArea> list=service.findAll();
		list2json(list, new String[]{"subareas","couriers"});
		return NONE;
	}

	@Action(value="subareaAction_exportXls")
	public String exportXls() throws IOException{
		//1、查询数据库，获取所有分区数据
		List<SubArea> list = service.findAll();
		
		//2、使用ＰＯＩ提供的ＡＰＩ将查询到的数据写入到Ｅｘｃｅｌ文件中
		HSSFWorkbook excel = new HSSFWorkbook();//在内存中创建一个Excel文件
		HSSFSheet sheet = excel.createSheet("分区数据列表");//在Excel文件中创建一个Sheet
		HSSFRow title = sheet.createRow(0);//创建Sheet中的标题行
		title.createCell(0).setCellValue("分区编号");
		title.createCell(1).setCellValue("分区关键字");
		title.createCell(2).setCellValue("分区辅助关键字");
		title.createCell(3).setCellValue("区域信息");
		title.createCell(4).setCellValue("分区地址信息");
		
		for (SubArea subArea : list) {
			HSSFRow data = sheet.createRow(sheet.getLastRowNum() + 1);
			data.createCell(0).setCellValue(subArea.getId());
			data.createCell(1).setCellValue(subArea.getKeyWords());
			data.createCell(2).setCellValue(subArea.getAssistKeyWords());
			data.createCell(3).setCellValue(subArea.getArea().getName());
			data.createCell(4).setCellValue(subArea.getAddress());
		}
		
		//3、通过输出流将Excel文件写回客户端浏览器实现下载（一个流、两个头）
		ServletOutputStream out = ServletActionContext.getResponse().getOutputStream();
		
		String filename = "分区数据统计.xls";
		String contentType = ServletActionContext.getServletContext().getMimeType(filename);
		String agent = ServletActionContext.getRequest().getHeader("User-Agent");
		filename = FileUtils.encodeDownloadFilename(filename, agent);
		
		ServletActionContext.getResponse().setContentType(contentType);
		ServletActionContext.getResponse().setHeader("content-disposition", "attchment;filename=" + filename);
		
		excel.write(out);
		
		return NONE;
	}
	
	/**
	 * 查询数据，在页面中展示为饼形图
	 * @return
	 */
	@Action(value="subareaAction_showChart")
	public String showChart(){
		//查询每个省份中包含多少个分区
		List<Object[]> list = service.showChart();
		list2json(list, null);
		return NONE;
	}
	
	@Action(value="subareaAction_showChart_zhu")
	public String showChart_zhu() throws IOException{
		List<Object[]> list = service.showChart_zhu();
		List<ArrayList> list_zhu = new ArrayList<>();
		ArrayList list_province = new ArrayList();
		ArrayList list_count = new ArrayList();
		for(Object[] obj : list){
			Object province = obj[0];
			Object count =  obj[1];
			list_province.add(province);
			list_count.add(count);
		}
		list_zhu.add(list_province);
		list_zhu.add(list_count);
		list2json(list_zhu, null);
		return null;
	}
}
