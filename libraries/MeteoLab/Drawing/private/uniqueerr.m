function [b,ndx,pos] = uniqueerr(a,flag,err)
%UNIQUEERR set unique with erro

% Copyright 1996-2002 Systems Planning and Analysis, Inc. and The MathWorks, Inc.
% $Revision: 1.4 $ $Date: 2002/03/20 21:26:58 $

if isempty(a), b = a; ndx = []; pos = []; return, end

if nargin<3,  err = 0;  end  %%%

rowvec = 0;
if nargin==1 | isempty(flag),
  rowvec = size(a,1)==1;
  [b,ndx] = sort(a(:));
  % d indicates the location of matching entries
  db = abs(b((1:end-1)') - b((2:end)'));
  d = db>=0 & db<=err;
  n = length(a);
else
  if ~isstr(flag) | ~strcmp(flag,'rows'), error('Unknown flag.'); end
  [b,ndx] = sortrows(a);
  n = size(a,1);
  if n > 1,
    % d indicates the location of matching entries
	db = abs(b(1:end-1,:) - b(2:end,:));
    d = db>=0 & db<=err;
    if ~isempty(d), d = all(d,2); end
  else
    d = [];
  end
end

if nargout==3, % Create position mapping vector
  pos(ndx) = cumsum([1;~d]);
  pos = pos';
end

b(d,:) = [];
ndx(d) = [];

if rowvec, 
  b = b.';
  ndx = ndx.'; 
  if nargout==3, pos=pos.'; end
end

