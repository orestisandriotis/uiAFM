mkdir(fullfile(ADdir,'post_process_figures'));  

folder = fullfile(ADdir,'post_process_figures');
legendString=cell(valid,1);

figure('Visible','on') 
    figure1=gcf;
    figure1.Units='centimeters';
    figure1.PaperOrientation = 'landscape';
    figure1.Position = [0.5 5 22 15];
    figure1.PaperPositionMode = 'auto';
    axes('Parent',figure1,'FontSize',9);

%% DZslope
subplot(2,3,1);
hold on

    plot([results_valid.Index],[results_valid.DZslope],'ok') 

    plot([0;16],[0.2;0.2],'--k')
    plot([0;16],[0.85;0.85],'-k')
axis([0 16 0 1])  
ax=gca;
ax.TickLabelInterpreter='latex';
xlabel('Index','interpreter','latex')    
ylabel('DZlslope','interpreter','latex')    

% title('DZslope','Interpreter','latex')


%% Elastic modulus vs Index
subplot(2,3,2);
% title('Elastic modulus vs. Index','Interpreter','latex')
hold on
   
    plot([results_valid.Index],[results_valid.Elastic_modulus],'ok')


ax=gca;
ax.TickLabelInterpreter='latex';
xlabel('Index','interpreter','latex')
ylabel(sprintf('Elastic modulus (%s)',units),'interpreter','latex')  

%% BOXPLOT
subplot(2,3,3);

boxplot([results_valid.Elastic_modulus],'Color',[0 0 0],'symbol','k+')
ax=gca;
ax.TickLabelInterpreter='latex';
hold on
plot(1,mean([results_valid.Elastic_modulus]),'ok')
    annot = annotation('textbox');
    annot.Position = [0.83,0.9,0.15,0.09];
    annot.Interpreter = 'latex';
    annot.EdgeColor = 'none';
    annot.BackgroundColor = 'w';
    annot.FontSize = 8;
    annot.FitBoxToText = 'on';
    str = {sprintf('Median = %.2f %s',median([results_valid.Elastic_modulus]),units)...
           sprintf('Mean = %.2f %s',mean([results_valid.Elastic_modulus]),units)...
           sprintf('STD = %.2f %s',std([results_valid.Elastic_modulus]),units)};
    annot.String = str;

ylabel(sprintf('Elastic modulus (%s)',units),'interpreter','latex')


%% Elastic modulus vs. Hc
subplot(2,2,4);
% title('Elastic modulus vs. Contact depth','Interpreter','latex')
  
    plot([results_valid.Hc],[results_valid.Elastic_modulus],'ok')
    

ax=gca;
ax.TickLabelInterpreter='latex';

xlabel('Contact depth ($\mu$m)','interpreter','latex')
ylabel(sprintf('Elastic modulus (%s)',units),'interpreter','latex')  

%% Stiffness
subplot(2,2,3);
% title('Stiffness','Interpreter','latex')
 
plot([results_valid.Hc],[results_valid.Stiffness],'Ok')

ax=gca;
ax.TickLabelInterpreter='latex';
% legend(legendString,'Interpreter','latex')
xlabel('Contact depth ($\mu$m)','interpreter','latex')
ylabel('Stiffness (N/m)','interpreter','latex')  


f = fullfile(folder,sprintf('%s_review_plots.pdf',sample_name));
% f2 = fullfile(folder,sprintf('%s_review_plots.pdf',sample_name));

print(gcf,'-dpdf','-r600',f );
% print(gcf,'-dpdf','-r600',f2 );
clear f f2;
close all;
%%
figure('Visible','on') 
    figure1=gcf;
    figure1.Units='centimeters';
    figure1.Position = [0.5 11 8 8];

    figure1.PaperPositionMode = 'auto';
    axes('Parent',figure1,'FontSize',9);

    plot([results_valid.DZslope],[results_valid.Stiffness],'Ok')


ax=gca;
ax.TickLabelInterpreter='latex';
% legend(legendString,'Interpreter','latex','Location','best')
xlabel('DZ slope ($\mu$m /$\mu$m)','interpreter','latex','FontSize',10)
ylabel('Stiffness (N/m)','interpreter','latex','FontSize',10)  

% hold on
% x=[0:0.01:0.9];
% n=0.035;
% CalibrationFun=(n./(1-x))- n;
% plot(x,CalibrationFun)

f = fullfile(folder,sprintf('%s_review_stiffnessVSdzSlope.pdf',sample_name));
print(gcf,'-dpdf','-r600',f );
%%
close all;
figure('Visible','on') 
    figure1=gcf;
    figure1.Units='centimeters';
    figure1.Position = [0.5 11 8 8];
    figure1.PaperPositionMode = 'auto';
    axes('Parent',figure1,'FontSize',9);
  
    
    plot([results_valid.DZslope],[results_valid.Elastic_modulus],'Ok')

% legend(legendString,'Interpreter','latex','Location','best')
xlabel('DZ slope ($\mu$m /$\mu$m)','interpreter','latex')
ylabel(sprintf('Elastic modulus (%s)',units),'interpreter','latex')  
axis([0 1 0 inf])   
ax=gca;
ax.TickLabelInterpreter='latex';
f = fullfile(folder,sprintf('%s_review_EmodVSdzSlope.pdf',sample_name));
print(gcf,'-dpdf','-r600',f );
% hold on
% x=[0:0.01:0.9];
% n=8;
% CalibrationFun=(n./(1-x))- n;
% plot(x,CalibrationFun)
close all;