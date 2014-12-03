function [ results ] = cmpM(parsed,model)


% example: results_M=cmpM(parseRecon2_species,recon2)

%% INPUT

% parsed --- 'parseCD'outputed variable, e.g., parseRecon2

% model --- a COBRA model;

% there are three fields "meid, id and name"; we would like to compare
% the reaction IDs in Recon 2 to thoese three independent columns.


%% OUTPUT
%  main: This contains all the analysis results.

%  listOfFound --- a list of reactions in the focusing model that
%  are present in the reference COBRA model.

%  listOfNotFound --- a list of reactions in the focusing model that
%  are NOT present in the reference COBRA model.

%  list_of_rxns_not_present_in_ReferenceModel --- A list of reactions in the
%  reference model that are NOT included in the focusing model.



%%



% isempty(find(~cellfun('isempty',strfind(model.mets,secM_red))));

metList_p=parsed.r_info.species(:,:);
[r_original,c_original]=size(parsed.r_info.species);

metList_m(:,1)=model.mets(:,1);metList_m(:,2)=model.metNames(:,1);

metList_m(:,:)=lower(metList_m(:,:));%% Convert string to lowercase.


results.main=metList_p;  % metList_p, the parsed CD model.
nF=1; nU=1;
for r_p=1:length(metList_p(:,1));
    
    for numOfmet=1:c_original;  % three different forms of ID, names;
        
        %% the rxn acts as the keywords in the searching
        met=strtrim(metList_p(r_p,numOfmet)); % removing the leading and the trailing white space from the string.
        met{1}=lower(met{1})
        % find(~cellfun('isempty',strfind(metList_m(:,1),name{2})))
        if ~ischar(met{1})
            disp(met{1})
            met{1}=char(met{1});
            % error('wrong');
            
        end
        
        
        if ~isempty(find(~cellfun('isempty',strfind(metList_m(:,1),met{1}))))
            results.main{r_p,c_original+2}='found';
            results.listOfFound(nF,1:c_original)=metList_p(r_p,1:c_original);  % metList_p reference model
            results.listOfFound{nF,c_original+2}='Present in the Reference mode';
            nF=nF+1;
            break;
        elseif numOfmet==c_original
            results.listOfNotFound(nU,1:c_original)=metList_p(r_p,1:c_original);
            results.listOfNotFound{nU,c_original+2}='Not Present in the Reference mode';
            results.listOfNotFound{nU,c_original+3}=r_p; % r_p is the metabolite number in the r_info.species list.
            nU=nU+1;
        end        
        
    end
    
end

nL=1;rxnList_p_2=parsed.r_info.species(:,:);
nn=1;


for col=1:c_original
    for row=1:r_original;
        
        masterList(nn,1)=rxnList_p_2(row,col);
        nn=nn+1;
    end
end

disp('start searching metabolites present in the reference model but not in the CD model')
for r_m=1:length(metList_m(:,1));
    
    met=strtrim(metList_m(r_m,1)); % removing the leading and the trailing white space from the string.
    %         try
    %  if isempty(find(strcmpi(rxn,rxnList_p_2(:,col))))
    
    if isempty(find(strcmpi(met,masterList(:,1))))
        
        results.list_of_rxns_not_present_in_ReferenceModel(nL,1)=met;
        
        %isempty(find(~cellfun('isempty',strfind(metList_p(:,1),rxn{1}))));
        % results.main_{r_p,c_original+2}='found';
        % results.listOfFound(nF,1:3)=metList_p(r_p,1:3);
        %results.listOfFound{nF,c_original+2}='Present in the Reference mode';
        %nF=nF+1;
        %     else
        %
        %         results.listOfNotFound(nU,1:3)=metList_p(r_p,1:3);;
        %         results.listOfNotFound{nU,c_original+2}='Not Present in the Reference mode';
        %
        nL=nL+1;
        
        %         catch
        %             disp(metList_m{r_m,1})
        %             disp(metList_p(:,col))
        %         end
        
        
    end
    
    
end


