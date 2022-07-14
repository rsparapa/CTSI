
inclause = function(var) {
    res=paste(unique(sort(var)), collapse="','")
    res=paste0("('", res, "')")
}
