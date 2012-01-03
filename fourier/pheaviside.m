function h=pheaviside(L)
%PHEAVISIDE  Periodic Heaviside function
%   Usage: h=pheaviside(L);
%
%   PHEAVISIDE(L) will return a periodic Heaviside function. The periodic
%   Heaviside function takes on the value 1 for indices corresponding to
%   positive frequencies, 0 corresponding to negative frequencies and the
%   value .5 for the zero and Nyquest frequencies.
%
%   To get a function that weight the negative frequencies by 1 and the
%   positive by 0, use INVOLUTE(PHEAVISIDE(L))
%
%   As an example, the PHEAVISIDE function can be use to calculate the
%   Hilbert transform for a column vector _f:
%
%C    h=2*ifft(fft(f).*pheaviside(length(f)));
%
%   See also: middlepad, involute, fftindex

%   AUTHOR : Peter Soendergaard.
%   REFERENCE: OK
%   TESTING: OK
  
error(nargchk(1,1,nargin));
  

h=zeros(L,1);
if L>0
  % First term is .5
  h(1)=.5;

  % Set positive frequencies to 1.
  h(2:ceil(L/2))=1;
 
  % Last term (Nyquest frequency) is also .5, if it exists.
  if rem(L,2)==0
    h(L/2+1)=.5;
  end;
end;

%OLDFORMAT
