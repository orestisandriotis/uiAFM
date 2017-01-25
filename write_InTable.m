function write_InTable(n,results,units,sample_name,ADdir,odir)
%+++++++++++++++

% results=results_valid;
% n = valid

%+++++++++++++++

Name = cell(n,1); 
index = zeros(n,1);
Dmax = zeros(n,1);
Zmax = zeros(n,1);
DZslope = zeros(n,1);
Hmax = zeros(n,1);
Fmax = zeros(n,1);
Hc = zeros(n,1);
Stiffness = zeros(n,1);
Area = zeros(n,1);
Elastic_modulus = zeros(n,1);

for j = 1 : n;
force_name=results(j).Filename;
    Name{j,1} = force_name;
    index(j,1) = results(j).Index;           
    Dmax(j,1) = results(j).Dmax;
    Zmax(j,1) = results(j).Zmax;
    DZslope(j,1) = results(j).DZslope;
    Hmax(j,1) = results(j).Hmax;
    Fmax(j,1) = results(j).Fmax;
    Hc(j,1) = results(j).Hc;
    Stiffness(j,1) = results(j).Stiffness;
    Area(j,1) = results(j).Area;
    Elastic_modulus(j,1) = results(j).Elastic_modulus;
end

T = array2table([
            index,...
            Dmax,...
            Zmax,...
            DZslope,...
            Hmax,...
            Fmax,...
            Hc,...
            Stiffness,...
            Area,...
            Elastic_modulus
            ],...
            'VariableNames',{'Index' 'Dmax_um' 'Zmax_um' 'DZslope'...
    'MaxIndentation_um' 'Fmax_uN' 'ContactDepth_um' 'Stiffness_Nperm'...
    'Area_um2' sprintf('ElasticModulus_%s',units)});

cd(ADdir);
stringname = sprintf('Results_%s.txt',sample_name);
writetable(T,stringname);
cd(odir);
