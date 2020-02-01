%  MATLAB Source Codes for the book "Cooperative Dedcision and Planning for
%  Connected and Automated Vehicles" published by Mechanical Industry Press
%  in 2020.
% ��������������Эͬ������滮�������鼮���״���
%  Copyright (C) 2020 Bai Li
%  2020.02.01
% ==============================================================================
%  �ڶ���. 2.4.5С��. X-Y-Tͼ��A�������㷨ʵ��һ���ԵĹ켣���ߡ���ӳ��ֽ��
% ==============================================================================
%  ��ע��
%  1. ������Ȳ��ߣ���û�п����˶�ѧ����Լ����ֱ�ӽ������ڲ�������Ŀ����Բ���
%     ������Ҫ�ν��Ż�����.
%  2. Figure 2��Ҫ����������ת�󣬲Żῴ����������ͼ.
% ==============================================================================
close all
clc

% % ��������
global vehicle_geometrics_ % �����������γߴ�
vehicle_geometrics_.vehicle_wheelbase = 2.8;
vehicle_geometrics_.vehicle_front_hang = 0.96;
vehicle_geometrics_.vehicle_rear_hang = 0.929;
vehicle_geometrics_.vehicle_width = 1.942;
vehicle_geometrics_.vehicle_length = vehicle_geometrics_.vehicle_wheelbase + vehicle_geometrics_.vehicle_front_hang + vehicle_geometrics_.vehicle_rear_hang;
vehicle_geometrics_.radius = hypot(0.25 * vehicle_geometrics_.vehicle_length, 0.5 * vehicle_geometrics_.vehicle_width);
global environment_scale_ % �������ڻ�����Χ
environment_scale_.environment_x_min = -20;
environment_scale_.environment_x_max = 20;
environment_scale_.environment_y_min = -20;
environment_scale_.environment_y_max = 20;
environment_scale_.x_scale = environment_scale_.environment_x_max - environment_scale_.environment_x_min;
environment_scale_.y_scale = environment_scale_.environment_y_max - environment_scale_.environment_y_min;
% % ����X-Y-Tͼ������A���㷨�漰�Ĳ���
global xyt_graph_search_
xyt_graph_search_.num_nodes_x = 200;
xyt_graph_search_.num_nodes_y = 200;
xyt_graph_search_.num_nodes_t = 210;
xyt_graph_search_.multiplier_H_for_A_star = 10.0;
xyt_graph_search_.weight_for_time = 3.0;
xyt_graph_search_.max_iter = 5000;
xyt_graph_search_.max_t = 40;
xyt_graph_search_.resolution_t = xyt_graph_search_.max_t / (xyt_graph_search_.num_nodes_t - 1);
xyt_graph_search_.resolution_x = environment_scale_.x_scale / (xyt_graph_search_.num_nodes_x - 1);
xyt_graph_search_.resolution_y = environment_scale_.y_scale / (xyt_graph_search_.num_nodes_y - 1);
% % ����ȶ������Լ���ֹ�ϰ���ֲ����
global vehicle_TPBV_ obstacle_vertexes_ dynamic_obs
load TaskSetup.mat
dynamic_obs = GenerateDynamicObstacles(xyt_graph_search_.num_nodes_t);
% % X-Y-Tͼ����
start_ind = ConvertConfigToIndex(vehicle_TPBV_.x0, vehicle_TPBV_.y0, 0);
goal_ind = ConvertConfigToIndex(vehicle_TPBV_.xtf, vehicle_TPBV_.ytf, xyt_graph_search_.max_t);
tic
[x, y, theta, fitness] = SearchTrajectoryInXYTGraph(start_ind, goal_ind);
disp(['CPU time elapsed for A* search: ',num2str(toc), ' sec.'])
% % ֱ�۳��ֽ��
DemonstrateDynamicResult(x, y, theta);