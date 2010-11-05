function [g,tfr]=pgauss(L,varargin)
%PGAUSS  Sampled, periodized Gaussian.
%   Usage: g=pgauss(L);
%          g=pgauss(L,tfr);
%          g=pgauss(L,...);
%          [g,tfr]=pgauss( ... );
% 
%   Input parameters:
%         L    : Length of vector.
%         tfr  : ratio between time and frequency support.
%   Output parameters:
%         g    : The periodized Gaussian.
%
%   PGAUSS(L,tfr) computes samples of a periodized Gaussian. The function
%   returns a regular sampling of the periodization of the function
%   exp(-pi*(x.^2/tfr)).
%
%   The returned function has norm == 1.
%
%   The parameter tfr determines the ratio between the effective
%   support of g and the effective support of the DFT of g. If tfr>1 then
%   g has a wider support than the DFT of g.
%
%   PGAUSS(L) does the same setting tfr=1.
%
%   PGAUSS(L,'width',s) returns a Gaussian with an effective support of s
%   samples. This means that approx. 96% of the energy or 79% of the area
%   under the graph is contained within s samples. This corresponds to a
%   -6 db cutoff. This is equivalent to calling PGAUSS(L,s^2/L);
%
%   PGAUSS(L,'bandwidth',s) does as above, but specifies the width in the
%   frequency domain. The bandwidth is measured in samples.
%
%   [g,tfr] = PGAUSS( ... ) will additionally return the time-to-frequency
%   support ratio. This is usefull if you did not specify it (i.e. used
%   the 'width' or bandwidth flag).
%
%   The function is whole-point even. This implies that FFT(PGAUSS(L,tfr))
%   is real for any L and tfr. The DFT of g is equal to PGAUSS(L,1/tfr).
%
%   In addition to the 'width' flag, PGAUSS understands the following
%   flags at the end of the list of input parameters:
%
%-     'wp'      - Output is whole point even. This is the default.
%
%-     'hp'      - Output is half point even, as most Matlab filter
%                  routines.
%
%-     'delay',d - Delay the output by d samples. Default is zero delay.
%
%   If this function is used to generate a window for a Gabor frame, then
%   the window giving the smallest frame bound ratio is generated by
%   PGAUSS(L,a*M/L);
%
%   See also:  longpar, psech, firwin, pbspline
%
%   Demos:  demo_pgauss
%
%R  mazh93

% AUTHOR : Peter Soendergaard.

%   First reference on this found in mazh93 eq. 63

if nargin<1
  error('Too few input parameters.');
end;

if (prod(size(L,1))~=1 || ~isnumeric(L))
  error('L must be a scalar');
end;

if rem(L,1)~=0
  error('L must be an integer.')
end;

% Define initial value for flags and key/value pairs.
definput.flags.centering={'wp','hp'};
definput.flags.delay={'nodelay','delay'};
definput.flags.width={'tfr','width','bandwidth'};

definput.keyvals.tfr=1;
definput.keyvals.delay=0;
definput.keyvals.width=0;
definput.keyvals.bandwidth=0;

[flags,keyvals,tfr]=ltfatarghelper({'tfr'},definput,varargin);

if flags.do_wp
  cent=0;
else
  cent=0.5;
end;

if flags.do_width
  tfr=keyvals.width^2/L;
end;

if flags.do_bandwidth
  tfr=L/keyvals.bandwidth^2;
end;

if (prod(size(tfr,1))~=1 || ~isnumeric(tfr))
  error('tfr must be a scalar.');
end;

g=comp_pgauss(L,tfr,cent-keyvals.delay);
