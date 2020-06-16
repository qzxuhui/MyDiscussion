clc
clear
close all

n=960;
data_A=load('data_A.txt');
row_A=data_A(:,1)+1;
col_A=data_A(:,2)+1;
value_A=data_A(:,3);
A=sparse(row_A,col_A,value_A);

data_B=load('data_B.txt');
row_B=data_B(:,1)+1;
col_B=data_B(:,2)+1;
value_B=data_B(:,3);
B=sparse(row_B,col_B,value_B);

tic
eigs(A,B,5,'smallestabs');
toc

full_A=full(A);
full_B=full(B);

tic
eig(full_A,full_B);
toc