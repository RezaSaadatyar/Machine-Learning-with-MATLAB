%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

function [Input, Inputch, DataFilter, fs, Inpuf, FVal, Fstr, SW, SS, InputWApprox_Detial, InputWRecons, ...
    Input_classification, Labels, Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT, ...
    TPerf, TPe, TPer, FTP, TPerfT, FTPerf] = clear_parameters(S, list, Nfeat1, Nfeat2)

% This function clears and resets all parameters and GUI elements to their default values.
% It is used to initialize or reset the state of the machine learning software.

% Check if the radio button (radio1) is selected
if S.radio1.Value == 1
    % Reset all output variables to their default values
    Inputch = 0; DataFilter = 0; Input = 0; fs = 0; Inpuf = 0; FVal = []; Fstr = ''; SW = []; SS = []; 
    InputWApprox_Detial = []; InputWRecons = 0; Input_classification = 0; TPerf = []; FTPerf = []; 
    Perfomance = 0; PerfomanceTotal = []; TPerfT = []; Labels = 0; PerfomanceT = []; 
    PerfomanceTotalT = []; TPe = []; FTP = []; TPer = [];
    
    % Reset GUI elements to their default values
    S.radio.Value = 0; S.inp.Value = 1; list.Data = []; S.radio1.Value = 0; S.input.Value = 1;
    S.input.String = 'Select:';
    S.notch.Value = 0; S.Fnotch.String = '50'; S.design.Value = 1; S.response.Value = 1; 
    S.response.Enable = 'on'; S.fs.String = ''; S.fs.Enable = 'on'; S.order.String = '3'; 
    S.order.Enable = 'on'; S.fl.String = ''; S.fl.Enable = 'on'; S.fh.String = ''; S.fh.Enable = 'on'; 
    S.rp.String = '2'; S.rp.Enable = 'on'; S.rs.String = '3'; S.rs.Enable = 'on'; S.window.String = '3'; 
    S.window.Enable = 'on'; S.checkFil.Value = 0; S.tabel.Data = []; S.display.Value = 0;

    % Clear plots in the GUI axes
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(1)); S.savfilt.Value = 0; 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(13));

    % Reset additional GUI elements
    S.inputf.Value = 1; S.Windw.Value = 1; S.TFDomain.Value = 1; S.FDomain.Value = 1; S.TDomain.Value = 1; 
    S.display1.Value = 0; S.save.Value = 0; S.delete.Value = 0; S.list2.Value = 1; S.list2.String = 'Select:'; 
    S.savfea.Value = 0; S.Novelab.String = ''; S.SlidW.String = ''; S.thr.String = ''; 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(2));

    % Reset wavelet-related GUI elements
    S.inputw.Value = 1; S.Nwavelet.Value = 1; S.nlevel.Value = 1; S.THR.Value = 1; S.softhard.Value = 1; 
    S.Plotwavelet.Value = 0; S.savwav.Value = 0; S.savwavAD.Value = 0; 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(3)); subplot(1, 1, 1, 'replace', 'Parent', S.ax(4));

    % Reset classification and clustering-related GUI elements
    S.inputCC.Value = 1; S.Lals.Value = 1; S.NSC.Value = 1; S.NumClass.String = ''; S.NumClass1.String = ''; 
    S.valid.Value = 1; S.Kfold.String = '3'; S.NumClass1.String = ''; S.reduct.Value = 1; S.Nfeat.String = ''; 
    S.redfeat.Value = 1; S.redfeat1.Value = 1; S.alpha.String = '0.01'; S.bin.String = '30'; S.Classify.Value = 1; 
    S.Cluster1.Value = 1; S.Cluster.Value = 1; S.KernalSVM.Value = 1; S.lda.Value = 1; S.Bay.Value = 1; 
    S.redfeat.Enable = 'on'; S.cent.Value = 1; S.nrbf.String = '15'; S.diskmean.Value = 1; 
    S.Iterkmean.String = '500'; S.val.Value = 0; S.typ.Value = 1; S.sigm.String = '0.1'; S.activefun.Value = 1; 
    S.weights.Value = 1; S.NNue.String = '12'; S.MKnn.Value = 1; S.Knndist.Value = 1; S.Nneigh.String = '3'; 
    S.learnfun.Value = 1; S.Nonedim.String = '10'; S.learnR.String = '0.01'; S.epoc.String = '50'; 
    S.maxf.String = '8'; S.Nonedim1.String = '10'; S.Nonedim2.String = '10'; S.Eta.String = '0.8'; 
    S.Tau.String = '2000'; S.Epoch.String = '1000'; S.Sig.String = '1.2'; S.lfmlp.Value = 1; S.TFun.Value = 1; 
    S.Numhl.String = '1'; S.NNhmlp.String = '10'; S.NNhmlp1.String = '10'; S.NNhmlp2.String = '5'; 
    S.epocmlp.String = '100'; S.maxfmlp.String = '10';

    % Clear additional plots in the GUI axes
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(5)); subplot(1, 1, 1, 'replace', 'Parent', S.ax(6)); 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(7)); subplot(1, 1, 1, 'replace', 'Parent', S.ax(8)); 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(9)); subplot(1, 1, 1, 'replace', 'Parent', S.ax(10)); 
    subplot(1, 1, 1, 'replace', 'Parent', S.ax(11)); subplot(1, 1, 1, 'replace', 'Parent', S.ax(12));

    % Clear feature-related data
    Nfeat1.Data = []; Nfeat2.Data = [];

    % Reset the radio button (radio1) to its default state
    S.radio1.Value = 0;
end
end