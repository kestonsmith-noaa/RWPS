import numpy as np
import netCDF4 as nc
import sys
import os
import interp_utilities as iutil

nargin = len(sys.argv) - 1

flin=sys.argv[1]
flout=sys.argv[2]
varname0=sys.argv[3]

varnames=varname0.split(":")
nvar=len(varnames)

data = nc.Dataset(flin,"r")
f=np.array(data[varnames[0]][:,:])
n0=f.shape[0]
n1=f.shape[1]

F=np.zeros((nvar,n0,n1))

for jv in range(nvar):
    try:
        fill_value0=data[varnames[jv]]._FillValue
    except:
        fill_value0=-99999
    F[jv,:,:]=np.array(data[varnames[jv]][:,:])

jnan=np.where(np.isnan(F))
F[jnan]=0.

with  nc.Dataset(flout, "w", format="NETCDF4") as ncout:
    # 1. Copy Global Attributes
    ncout.setncatts({attr: data.getncattr(attr) for attr in data.ncattrs()})
    # 2. Copy Dimensions
    for name, dimension in data.dimensions.items():
        # If the dimension is unlimited, pass None to createDimension
        dim_len = len(dimension) if not dimension.isunlimited() else None
        ncout.createDimension(name, dim_len)
    for name, src_var in data.variables.items():
        if not any(varname in name for varname in varnames): 
            dst_var = ncout.createVariable(name, src_var.datatype, src_var.dimensions)
            dst_var.setncatts({attr: src_var.getncattr(attr) for attr in src_var.ncattrs()})
            dst_var[:] = src_var[:]
    for jv in range(nvar):
        varname=varnames[jv]
        fill_value0=data[varname]._FillValue
        f_var=ncout.createVariable(varname, 'f4', ('time','node'), fill_value = fill_value0)
        iutil.CopyAttributes(data[varname], f_var)
        f_var[:,:]=F[jv,:,:]
    ncout.close
