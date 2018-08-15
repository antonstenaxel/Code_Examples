clear all 
clf 
clc

N=200;

subplot(2,1,1)
p=5;
StochasticHopfieldModel(N,p);

subplot(2,1,2)
p=40;
StochasticHopfieldModel(N,p);

