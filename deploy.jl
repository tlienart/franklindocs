using Franklin
if !(@isdefined msg)
    msg = "jd-update"
end
publish(prerender=false, final=lunr, message=msg)
