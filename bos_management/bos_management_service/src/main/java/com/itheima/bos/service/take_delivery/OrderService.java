package com.itheima.bos.service.take_delivery;

import javax.jws.WebService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.itheima.bos.domain.base.Courier;
import com.itheima.bos.domain.take_delivery.Order;

@WebService
public interface OrderService {
	/**
	 * 保存订单、自动分单、保存工单
	 */
	public void autoOrder(Order order);
	/**
	 * 人工调度订单
	 */
	public void dispatcher(Order order, Courier courier);
	
	
	public Order findByOrderNum(String orderNum);

}
