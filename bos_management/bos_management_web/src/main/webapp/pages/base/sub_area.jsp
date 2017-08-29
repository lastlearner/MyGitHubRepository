<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta charset="UTF-8">
		<title>管理分区</title>
		<!-- 导入jquery核心类库 -->
		<script type="text/javascript" src="../../js/jquery-1.8.3.js"></script>
		<!-- 导入easyui类库 -->
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/default/easyui.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/themes/icon.css">
		<link rel="stylesheet" type="text/css" href="../../js/easyui/ext/portal.css">
		<link rel="stylesheet" type="text/css" href="../../css/default.css">
		<script type="text/javascript" src="../../js/easyui/jquery.easyui.min.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.portal.js"></script>
		<script type="text/javascript" src="../../js/easyui/ext/jquery.cookie.js"></script>
		<script src="../../js/easyui/locale/easyui-lang-zh_CN.js" type="text/javascript"></script>
		<script type="text/javascript" src="../../js/highcharts/highcharts.js"></script>
		<script type="text/javascript">
			function doAdd(){
				$('#addWindow').window("open");
			}
			
			function doEdit(){
				
				var selected=$('#grid').datagrid('getSelections');
				if(selected.length!=1){
					$.messager.alert("提示","请选中一条数据进行修改！","warning");
					
				}else{
					$('#editWindow').window("open");
					var data=selected[0];
					
					$("#subedit2").val(data.id);
					$('#editWindow').form("load",data);
				}
			}
			
			function doDelete(){
				alert("删除...");
			}
			
			function doSearch(){
				$('#searchWindow').window("open");
			}
			
			//导出按钮绑定的事件
			function doExport(){
				//发送请求
				window.location.href = "../../subareaAction_exportXls.action";
			}
			
			function doImport(){
				alert("导入");
			}
			
			function doShowChart_zhu(){
				$("#chartWindow_zhu").window("open");
				$.post("${pageContext.request.contextPath }/subareaAction_showChart_zhu.action",function(data){
					$('#container_zhu').highcharts({
				        chart: {
				            type: 'column'
				        },
				        title: {
				            text: '分区柱状图'
				        },
				        subtitle: {
				            text: '数据来源: 官方数据'
				        },
				        xAxis: {
				            categories: data[0],
				            crosshair: true
				        },
				        yAxis: {
				            min: 0,
				            title: {
				                text: '分区数量'
				            }
				        },
				        tooltip: {
				            headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
				            pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
				            '<td style="padding:0"><b>{point.y:.0f} </b></td></tr>',
				            footerFormat: '</table>',
				            shared: true,
				            useHTML: true
				        },
				        plotOptions: {
				            column: {
				                pointPadding: 0.2,
				                borderWidth: 0
				            }
				        },
				        series: [{
				            name: '分区数量',
				            data: data[1]
				        }]
				    });
					
				},"json");
			}
			
			
			function doShowChart(){
				//弹出窗口，展示图形
				$("#chartWindow").window("open");
				
				//发送ajax请求，获取数据，提供给highcharts插件，进行页面图形展示
				$.post("../../subareaAction_showChart.action",function(data){
					//回调函数中调用highcharts提供的API创建图表
					 $('#container').highcharts({
					        chart: {
					            plotBackgroundColor: null,
					            plotBorderWidth: null,
					            plotShadow: false
					        },
					        title: {
					            text: '分区分布图'
					        },
					        tooltip: {
					            headerFormat: '{series.name}<br>',
					            pointFormat: '{point.name}: <b>{point.percentage:.1f}%</b>'
					        },
					        plotOptions: {
					            pie: {
					                allowPointSelect: true,
					                cursor: 'pointer',
					                dataLabels: {
					                    enabled: true,
					                    format: '<b>{point.name}</b>: {point.percentage:.1f} %',
					                    style: {
					                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
					                    }
					                }
					            }
					        },
					        series: [{
					            type: 'pie',
					            name: '各省份分区占比',
					            data: data
					        }]
					    });
				},'json');
			}
			//工具栏
			var toolbar = [ {
				id : 'button-search',	
				text : '查询',
				iconCls : 'icon-search',
				handler : doSearch
			}, {
				id : 'button-add',
				text : '增加',
				iconCls : 'icon-add',
				handler : doAdd
			}, {
				id : 'button-edit',	
				text : '修改',
				iconCls : 'icon-edit',
				handler : doEdit
			},{
				id : 'button-delete',
				text : '删除',
				iconCls : 'icon-cancel',
				handler : doDelete
			},{
				id : 'button-import',
				text : '导入',
				iconCls : 'icon-redo',
				handler : doImport
			},{
				id : 'button-export',
				text : '导出',
				iconCls : 'icon-undo',
				handler : doExport
			},{
				id : 'button-showChart',
				text : '分区分布图',
				iconCls : 'icon-search',
				handler : doShowChart
			},{
				id : 'button-showChart_zhu',
				text : '分区柱状图',
				iconCls : 'icon-search',
				handler : doShowChart_zhu
			}];
			// 定义列
			var columns = [ [ {
		
				field : 'id',
				checkbox : true,
			}, {
				field : 'showid',
				title : '编号',
				width : 120,
				align : 'center',
				formatter : function(data,row ,index){
					return row.id;
				}
			},{
				field : 'address',
				title : '地址信息',
				width : 120,
				align : 'center'
			},{
				field : 'keyWords',
				title : '关键字',
				width : 120,
				align : 'center'
			}, {
				field : 'startNum',
				title : '起始号',
				width : 100,
				align : 'center'
			}, {
				field : 'endNum',
				title : '终止号',
				width : 100,
				align : 'center'
			} , {
				field : 'assistKeyWords',
				title : '辅助关键字',
				width : 100,
				align : 'center'
			} ] ];
			
			$(function(){
				// 先将body隐藏，再显示，不会出现页面刷新效果
				$("body").css({visibility:"visible"});
				
				// 分区管理数据表格
				$('#grid').datagrid( {
					iconCls : 'icon-forward',
					fit : true,
					border : true,
					rownumbers : true,
					striped : true,
					pageList: [30,50,100],
					pagination : true,
					toolbar : toolbar,
					url : "../../subareaAction_findAll.action",
					idField : 'id',
					columns : columns,
					onDblClickRow : doDblClickRow
				});
				
				// 添加、修改分区
				$('#addWindow').window({
			        title: '添加修改分区',
			        width: 600,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				$('#chartWindow_zhu').window({
			        width: 600,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				$('#chartWindow').window({
			        width: 700,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 450,
			        resizable:false
			    });
				//修改分区
					$('#editWindow').window({
			        title: '修改分区',
			        width: 600,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				
				// 查询分区
				$('#searchWindow').window({
			        title: '查询分区',
			        width: 400,
			        modal: true,
			        shadow: true,
			        closed: true,
			        height: 400,
			        resizable:false
			    });
				$("#btn").click(function(){
					alert("执行查询...");
				});
			});
		
			function doDblClickRow(){
				alert("双击表格数据...");
			}
		</script>
	</head>

	<body class="easyui-layout" style="visibility:hidden;">
		<div region="center" border="false">
			<table id="grid"></table>
		</div>
		<!-- 添加 修改分区 -->
		<div class="easyui-window" title="分区添加修改" id="addWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="height:31px;overflow:hidden;" split="false" border="false">
				<div class="datagrid-toolbar">
					<a id="save" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
					<script type="text/javascript">
						$(function(){
							//为保存按钮绑定事件
							$("#save").click(function(){
								//进行表单校验
								var v = $("#subareaForm").form("validate");
								if(v){
									//所有输入项都通过校验了，可以提交表单
									$("#subareaForm").submit();
								}
							});
						});
					</script>
				</div>
			</div>

			<div style="overflow:auto;padding:5px;" border="false">
				<form id="subareaForm" method="post" action="../../subareaAction_save.action">
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">分区信息</td>
							<input type="hidden" name="id" id="subedit"/>
						</tr>
						<tr>
							<td>选择区域</td>
							<td>
								<input class="easyui-combobox" name="area.id"
									 data-options="valueField:'id',textField:'name',
									 url:'../../areaAction_findAll.action',editable:false,required:true" />
							</td>
						</tr>
						<tr>
							<td>关键字</td>
							<td>
								<input type="text" name="keyWords" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>辅助关键字</td>
							<td>
								<input type="text" name="assistKeyWords" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>起始号</td>
							<td>
								<input type="text" name="startNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>终止号</td>
							<td>
								<input type="text" name="endNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>位置信息</td>
							<td>
								<input type="text" name="address" class="easyui-validatebox" required="true" style="width:250px;" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		
		<div class="easyui-window" title="分区分布图" id="chartWindow" collapsible="false" 
				minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div id="container"></div>
		</div>
		
		<div class="easyui-window" title="分区柱状图" id="chartWindow_zhu" collapsible="false" 
				minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div id="container_zhu"></div>
		</div>
		
		<!-- 查询分区 -->
		<div class="easyui-window" title="查询分区窗口" id="searchWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<form>
					<table class="table-edit" width="80%" align="center">
										
						<tr>
							<td>编号</td>
							<td>
								<input type="text" name="decidedzone.id" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>省</td>
							<td>
								<input type="text" name="province" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>市</td>
							<td>
								<input type="text" name="city" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>区（县）</td>
							<td>
								<input type="text" name="district" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						
						<tr>
							<td>关键字</td>
							<td>
								<input type="text" name="keyWords" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td colspan="2"><a id="btn" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'">查询</a> </td>
						</tr>
						
					</table>
				</form>
			</div>
		</div>
	</body>
	<!-- 修改分区信息 -->
	<div class="easyui-window" title="修改分区窗口" id="editWindow" collapsible="false" minimizable="false" maximizable="false" style="top:20px;left:200px">
			<div style="overflow:auto;padding:5px;" border="false">
				<div class="datagrid-toolbar">
					<form id="editForm" action="../../subareaAction_save.action" method="post" >
					
					<table class="table-edit" width="80%" align="center">
						<tr class="title">
							<td colspan="2">修改分区</td>
						</tr>
								
						<tr>
							<td>
								<input type="hidden" id="subedit2" name="id" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>地址</td>
							<td>
								<input type="text" name="address" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>关键字</td>
							<td>
								<input type="text" name="keyWords" class="easyui-validatebox" required="true" />
							</td>
						</tr>
						<tr>
							<td>起始号</td>
							<td>
								<input type="text" name="startNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
							<tr>
							<td>终止号</td>
							<td>
								<input type="text" name="endNum" class="easyui-validatebox" required="true" />
							</td>
						</tr>
							<tr>
							<td>辅助关键字</td>
							<td>
								<input type="text" name="assistKeyWords" class="easyui-validatebox" required="true" />
							</td>
							<tr>
							<td>
							<a id="save2" icon="icon-save" href="#" class="easyui-linkbutton" plain="true">保存</a>
					<script type="text/javascript">
						$(function(){
							//为保存按钮绑定事件
							$("#save2").click(function(){
								//进行表单校验
								var v = $("#editForm").form("validate");
								if(v){
									//所有输入项都通过校验了，可以提交表单
									$("#editForm").submit();
								}
							});
						});
					</script>
							</td>
						</tr>
						</tr>
					</table>
				</form>
				
				</div>
			</div>
		</div>
	</body>
</html>