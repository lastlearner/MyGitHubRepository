package com.itheima.bos.service.base;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.itheima.bos.domain.base.SubArea;

public interface SubareaService {

	public void save(SubArea model);

	public List<SubArea> findAll();

	public List<Object[]> showChart();


	List<Object[]> showChart_zhu();
	/**
	 * 查询所有与定区关联的分区
	 * @param id
	 * @return
	 */
	public List<SubArea> findAllSubAreaHasAssosiation(String fixedId);

	/**
	 * 查询所有未与定区关联的分区
	 * @return
	 */
	public List<SubArea> findAllSubAreaNoAssosiation();

	/**
	 * 将定区与一批分区关联
	 * @param id
	 * @param subAreaIds
	 */
	public void assignSubAreas2FixedArea(String fixedId, List<String> subAreaIds);

}
