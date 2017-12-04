% The COBRAToolbox: testtuneParam.m
%
% Purpose:
%     - testtuneParam tests the CPLEX parameter tuning tool of
%       IBM CPLEX
%
% Author:
%     - Marouen BEN GUEBILA 04/12/2017

global CBTDIR
global ILOG_CPLEX_PATH

addpath(genpath(ILOG_CPLEX_PATH));

%Load the model
model = getDistributedModel('ecoli_core_model.mat');

% save the current path
currentDir = pwd;

% initialize the test
fileDir = fileparts(which('testtuneParam'));
cd(fileDir);    

%Change the solver to IBM Cplex
solverOK = changeCobraSolver('ibm_cplex');

if solverOK
    %retrieve all IBM Cplex paramters
    cpxControl = CPLEXParamSet('ILOGcomplex');
    %set barrier as solver algorithm
    cpxControl.lpmethod=4;
    %Optimize parameter values
    timeLimit=5;%seconds
    nRuns=5;%runs
    printLevel=0;
    optimParam = tuneParam(model,cpxControl,timeLimit,nRuns,printLevel);

    %test results
    %check if automatic is the optimal solver algorithm for Ecoli
    assert(isequal(optimParam.lpmethod,0))
end

% change the directory
cd(currentDir)