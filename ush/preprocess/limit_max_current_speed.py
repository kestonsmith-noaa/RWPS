import numpy as np
import netCDF4 as nc
import sys
import os
import interp_utilities as iutil

nargin = len(sys.argv) - 1

flin=sys.argv[1]
flout=sys.argv[2]
maxspd=float(sys.argv[3])

data = nc.Dataset(flin,"r")
u=np.array(data['u-vel'][:,:])
v=np.array(data['v-vel'][:,:])
spd=np.sqrt(u**2+v**2)
j=np.where(spd>maxspd)
u[j]=maxspd*u[j]/spd[j]
v[j]=maxspd*v[j]/spd[j]

fill_value0=data['u-vel']._FillValue

with  nc.Dataset(flout, "w", format="NETCDF4") as ncout:
    # 1. Copy Global Attributes
    ncout.setncatts({attr: data.getncattr(attr) for attr in data.ncattrs()})
    # 2. Copy Dimensions
    for name, dimension in data.dimensions.items():
        # If the dimension is unlimited, pass None to createDimension
        dim_len = len(dimension) if not dimension.isunlimited() else None
        ncout.createDimension(name, dim_len)
    for name, src_var in data.variables.items():
        if not ("vel" in name): 
            dst_var = ncout.createVariable(name, src_var.datatype, src_var.dimensions)
            dst_var.setncatts({attr: src_var.getncattr(attr) for attr in src_var.ncattrs()})
            dst_var[:] = src_var[:]
    
    u_var=ncout.createVariable('u-vel', 'f4', ('time','node'), fill_value = fill_value0)
    iutil.CopyAttributes(data['u-vel'], u_var)
    u_var[:,:]=u[:,:]

    v_var=ncout.createVariable('v-vel', 'f4', ('time','node'), fill_value = fill_value0)
    iutil.CopyAttributes(data['v-vel'], v_var)
    v_var[:,:]=v[:,:]

    s_var=ncout.createVariable('spd-orig', 'f4', ('time','node'), fill_value = fill_value0)
    iutil.CopyAttributes(data['u-vel'], s_var)
    s_var[:,:]=spd[:,:]
    ncout.close
