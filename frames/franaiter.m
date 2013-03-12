function [c,relres,iter]=franaiter(F,f,varargin)
%FRANAITER  Iterative analysis
%   Usage:  c=franaiter(F,f);
%           [c,relres,iter]=franaiter(F,f,...);
%
%   Input parameters:
%         F       : Frame.
%         f       : Signal.
%         Ls      : Length of signal.
%   Output parameters:
%         c       : Array of coefficients.    
%         relres  : Vector of residuals.
%         iter    : Number of iterations done.
%
%   `c=franaiter(F,f)` computes the frame coefficients *c* of the signal *f*
%   using an iterative method such that perfect reconstruction can be
%   obtained using |frsyn|_. `franaiter` always works, even when |frana|_
%   cannot generate perfect reconstruction coefficients.
%
%   `[c,relres,iter]=franaiter(...)` additionally returns the relative
%   residuals in a vector *relres* and the number of iteration steps *iter*.
%  
%   **Note:** If it is possible to explicitly calculate the canonical dual
%   frame then this is usually a much faster method than invoking
%   `franaiter`.
%
%   `franaiter` takes the following parameters at the end of the line of
%   input arguments:
%
%     'tol',t      Stop if relative residual error is less than the
%                  specified tolerance. Default is 1e-9 
%
%     'maxit',n    Do at most n iterations.
%
%     'pg'        Solve the problem using the Conjugate Gradient
%                  algorithm. This is the default.
%
%     'pcg'        Solve the problem using the Preconditioned Conjugate Gradient
%                  algorithm.
%
%     'print'      Display the progress.
%
%     'quiet'      Don't print anything, this is the default.
%
%   Examples
%   --------
%
%   The following example shows how to rectruct a signal without ever
%   using the dual frame:::
%
%      f=greasy;
%      F=frame('dgtreal','gauss',40,60);
%      [c,relres,iter]=franaiter(F,f,'tol',1e-14);
%      r=frsyn(F,c);
%      norm(f-r)/norm(f)
%      semilogy(relres);
%      title('Conversion rate of the CG algorithm');
%      xlabel('No. of iterations');
%      ylabel('Relative residual');
%
%   See also: frame, frana, frsyn, frsyniter
  
% AUTHORS: Peter L. Søndergaard
    
  if nargin<2
    error('%s: Too few input parameters.',upper(mfilename));
  end;
  
  definput.keyvals.Ls=[];
  definput.keyvals.tol=1e-9;
  definput.keyvals.maxit=100;
  definput.flags.alg={'cg','pcg'};
  definput.keyvals.printstep=10;
  definput.flags.print={'quiet','print'};

  [flags,kv,Ls]=ltfatarghelper({'Ls'},definput,varargin);
  
  % Determine L from the first vector, it must match for all of them.
  L=framelengthcoef(F,size(f,1));
    
  A=@(x) frsyn(F,frana(F,x));
           
      
  if flags.do_pcg
      d=framediag(F,L);
      M=spdiags(d,0,L,L);
      
      [fout,flag,~,iter,relres]=pcg(A,f,kv.tol,kv.maxit,M);
  else
      
      [fout,flag,~,iter,relres]=pcg(A,f,kv.tol,kv.maxit);          
  end;

  c=frana(F,fout);

  if nargout>1
      relres=relres/norm(fout(:));
  end;

end


    