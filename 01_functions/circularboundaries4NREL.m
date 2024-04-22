    function [c, ceq]=circularboundaries4NREL(x)
    %%%%%%%%% Position Boundaries %%%%%%%%
    % Function for                       %
    %   1) safety circle around turbines %
    %   2) HR1 Outer Boundaries          %
    % For usage with NREL5MW    turbine  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Circular Boundaries
        xSpacing=zeros(numel(x(1,:)),numel(x(1,:)));
        for ii=1:numel(x(1,:))
        xSpacing(ii,:)=sqrt(((x(1,ii)-x(1,:)).^2)+((x(2,ii)-x(2,:)).^2));
        end
        idx=eye(size(xSpacing));
%         c=5-min(xSpacing(~i<dx),[],'all');
        c1=3.7-xSpacing(~idx);

        %Boundaries for HR1
        xmin=(-6/48.63.*x(2,:))-0.01;
        xmax=(-6/48.63.*x(2,:)+40)+0.01;
        c2=xmin-x(1,:);
        c3=x(1,:)-xmax;
        c=[c1; c2'; c3'];
        ceq=[];
    end
       