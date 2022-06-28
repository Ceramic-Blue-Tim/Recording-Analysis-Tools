% joinRecPhases_main.m
% MAIN SCRIPT
[mainRegExp,regExprToFullfill,regToFulfillInName,flag] = joinRecPhases_getParam();
if flag
    catDifferentPhasePtrain(mainRegExp,regExprToFullfill,regToFulfillInName)
end