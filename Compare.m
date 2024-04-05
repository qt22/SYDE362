%% init
clear
close all
clc

%% read csv

% Specify the path to your CSV file
filename = 'TideMachineData.csv';

% Read the data from the CSV file
data = readmatrix(filename);

% Extract Column 1 and Column 2
x = data(:,1); % Column 1
y = data(:,2); % Column 2

maxY = max(y); % Find the maximum y value
y = 2*maxY - y; % Mirror the y values

y = y - 2.01;

%% Create a plot of Column 2 vs Column 1
figure; % Creates a new figure window
plot(x, y); % Plots y vs x with line and circle markers
xlabel('Time (Hours)'); % Label for the x-axis
ylabel('Predicted Tide Level (m)'); % Label for the y-axis
title('Tide Machine Predicted Tide Level from Day 31 to Day 37'); % Title of the plot
grid on; % Adds a grid to the plot for better readability
