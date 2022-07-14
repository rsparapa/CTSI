
byvalue = function(by=NULL, data=NULL, debug=FALSE) {
    P=length(by)
 
    if(P==0 || length(data)==0) return(NULL)

    N=nrow(data)
    out=data
    
    first=paste0('first.', by)
    last =paste0('last.', by)
    first.=matrix(0, nrow=N, ncol=P)
    last. =matrix(0, nrow=N, ncol=P)
    
    for(j in 1:P) {
        code=paste0('out=data.frame(out, ',
                    first[j], '=1, ', last[j], '=1)')
        if(debug) print(code)
        eval(parse(text=code))
    }
    
    first=paste0('out$', first)
    last =paste0('out$', last)

    if(N>1) for(i in 2:N) for(j in 1:P) {
        if(is.na(out[i-1, by[j]]) && is.na(out[i, by[j]])) first.[i, j]=0
        else if(is.na(out[i-1, by[j]]) || is.na(out[i, by[j]])) first.[i, j]=1
        else first.[i, j]=(out[i-1, by[j]]!=out[i, by[j]])*1
        if(j>1) first.[i, j]=(sum(first.[i, 1:j])>0)*1
        if(first.[i, j]==0) {
            code=paste0(first[j], '[i]=0')
            if(debug) print(code)
            eval(parse(text=code))
        }
    }

    if(N>1) for(i in (N-1):1) for(j in 1:P) {
        if(is.na(out[i+1, by[j]]) && is.na(out[i, by[j]])) last.[i, j]=0
        else if(is.na(out[i+1, by[j]]) || is.na(out[i, by[j]])) last.[i, j]=1
        else last.[i, j]=(out[i+1, by[j]]!=out[i, by[j]])*1
        if(j>1) last.[i, j]=(sum(last.[i, 1:j])>0)*1
        if(last.[i, j]==0) {
            code=paste0(last[j], '[i]=0')
            if(debug) print(code)
            eval(parse(text=code))
        }
    }
    
    return(out)
}

## test=data.frame(
##     by1=c(1, 1, 1, 2, 2, NA, NA),
##     by2=c(1, 2, 3, 1, 1, 1, 2))

## print(byvalue(c('by1'), test))
## print(byvalue(c('by2'), test))
## print(byvalue(c('by1', 'by2'), test))

