function [LFinal] = findrules(D,smin,amin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% confuse on how to sdo the amax too  ? 

    L = Apriori(D,smin,amin);
    R = {};
    X = {};
    Y  = {};
for i = 1:size(L,2)
      Z=L{i};
      if size(Z,2) > 2
            for j =  1:size(Z,2)
               for k =  j+1:size(Z,2)
                    temp=union(Z(j),Z(k));
                    if getcount(Z,D) /getcount(temp,D)  >= amin
                        X= [X {temp}  ];    
                        tempy = setdiff(Z,temp);
                        Y = [Y {tempy}];

                    end
               end 
                temp= Z(j);
               if getcount(Z,D) /getcount(temp,D)  >= amin
                      X= [X {temp}  ];
                      tempy = setdiff(Z,temp);
                      Y = [Y {tempy}];
               end
            end     
        end
end
finalAns = {};
for i = 1:size(X,2)
 su = union(X{i},Y{i});
 support = getcount(su,D) / numexamples(D);
 confidance = getcount(su,D) / getcount(X{i},D);
  str = rule2str(X{i},Y{i},D) ;
  finalAns =[finalAns ;{num2str(confidance),num2str(support),str} ];
    
end
%  size(finalAns)
%  finalAns{1}
 out = sortrows(finalAns,1);
 a=out{1,2};
 for i = 1:size(X,2)
     s = 0.0;
     c = 0.0;
     st = '';
     for j = 1:size(finalAns,2)
        if j == 1
            s = out{i,j};
        elseif j == 2
            c = out{i,j};
        else
            st = out{i,j};
        end
     end
     fprintf(s);
      fprintf(', ');
     fprintf(c);
     
     fprintf(' : ');
     fprintf(st);
      fprintf('\n');
 end
%  f=out{1}

end


function [LFinal] = Apriori(D,smin,amax)


   it = items(D);
    count1 = ones( (size(it)));
    L1 = [];
    for i = 1:size(it,2)
         supportI = getcount(it(i),D)/numexamples(D);
         if supportI > smin
            L1 = [L1 {it(i)}];
         end
    end
    L = L1;
    i = 1;
     
     while length(L1) > 0
         i = i+ 1;
         c = AprioriGen(L1,i); %we get a subset
%             a = [c{1,5}] % how to aceess each of the cells into an array
%             wow = a(1,2)   %how to go through the array of the cell
         L1 = []; % we reset
         L1support = zeros(size(c)); %keeping track of the support 
          for j = 1:size(c,2) %size depends on what we get back from the aprio gen
              L1support(j) = getcount([c{1,j}],D)/ numexamples(D); % calculate the support
          end
          for k = 1:size(c,2)
              if  L1support(k) >= smin
                    L1 = [L1 {c{1,k}} ]; % here compuse on how we store it into L1
              end
          end
%          l1 = size(L1)
%          l = size(L)
           L = [L L1];
%             l = size(L)
     end
      LFinal = L;
end

function [CFinal] = AprioriGen(L,num)
 c = [];
 for j = 1:size(L,2)
     for k = j+1:size(L,2)
         LjV = [L{j}];
         LkV = [L{k}];
         if num ==  3
            LjV = [L{j}];
            LkV = [L{k}];
         end
          if num == 2 
              if LjV ~= LkV
                  tempU =  union(L{j},L{k});
                  c = [c, {tempU}];
              end
          elseif isequal( LkV(1,1:end-1), LjV(1,1:end-1))
                 if ~isequal( LjV(1,end), LkV(1,end))
                     tempU =  union(L{j},L{k});
                     c = [c, {tempU}];
                 end
         else
             break;
         end
% 
      end
 end
CFinal = c ;
end

