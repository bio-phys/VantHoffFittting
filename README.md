# VantHoffFitting

This package provides a robust framework based on a two-state model to reliably extract temperature-dependent thermodynamic potentials (enthalpies, entropies and Gibbs free energies) and heat capacities from measurements of equilibrium constants at different temperatures.  

For more details on the theoretical framework, please refer to the associated preprint:
> J. T. Bullerjahn and S. M. Hanson, "Extracting thermodynamic properties from van ’t Hoff plots with emphasis on temperature-sensing ion channels", *bioRxiv* (2023). https://doi.org/10.1101/2023.06.02.543442

Please cite the reference above if you use `VantHoffFitting` to analyze your data.  



## Try without installation

Click this [link](https://jabuller.pages.mpcdf.de/vanthofffitting) to try the `pipeline_example.ipynb` notebook in a cloud environment.  

You can either analyze the data sets found in `examples/mock_data/` or upload your own.  The interactive session is only temporary and files will be deleted after termination (File -> Shut Down).  

**Important:** Please shut down JupyterLab properly after use via the drop-down menu (File -> Shut Down) to free resources for other users.  



## Installation

The package is written in the open-source programming language [Julia](https://github.com/JuliaLang/julia), which can be downloaded from their [webpage](https://julialang.org/downloads/#download_julia).  

Currently, the package is not in a registry.  It must therefore be added by specifying a URL to the repository:
```julia
using Pkg; Pkg.add(url="https://github.com/bio-phys/VantHoffFitting")
```
Users of older versions of Julia may need to wrap the contents of the brackets with `PackageSpec()`.  



## Usage

### Importing data

The data should be of the type `Array{Float64,2}`, where the first column contains the temperatures `T` (in *K*) and the second column the logarithm of the equilibrium constant `ln_K` (dimensionless).  An optional third columns should contain associated uncertainties `∆ln_K` (dimensionless).  Users can read their data in from file as follows:
```julia
using DelimitedFiles

data = readdlm(file_name)
```



### Data fitting

The function `fit_data` is used to find the best model that fits the data:
```julia
model, spline_parameters = fit_data(data)
```
It outputs a string `model` and an array `spline_parameters`, where the former contains information about the model that best fits the data (either "linear" or "reciprocal") and the latter gives the associated fit parameters.  These can then be used to evaluate the following built-in functions:
```julia
ln_K(T, spline_parameters, model) # logarithm of equilibrium constant
ΔC_p(T, spline_parameters, model) # isobaric heat capacity
ΔH(T, spline_parameters, model) # enthalpy
ΔS(T, spline_parameters, model) # entropy
ΔG(T, spline_parameters, model) # Gibbs free energy
```
